class Customer < ActiveRecord::Base
  # ASSOCIATIONS
  belongs_to :user
  belongs_to :property
  has_many :payments
  has_many :invoices
  has_many :trans
  has_many :notes
  has_many :credits

  # VALIDATIONS
  validates :user_id, presence: true
  validates :property_id, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :rent, presence: true

  # HOOKS
  before_create :setup_last_charged
  before_update :update_last_charged
  after_create :charge_prorated_rent

  after_create do
    self.property.update_attribute(:rented, true)
  end

  def enter_rent(amount = self.rent, memo = nil, account_id = nil)
    memo ||= "Rent for #{Date::MONTHNAMES[Date.today.month]} #{Date.today.year}"
    account_id ||= Account.find_by(name: "Rental Income", user: self.user).id

    invoice = self.invoices.build do |i|
      i.amount = amount
      i.date = Date.today
      i.memo = memo
      i.user = user
    end
    invoice.skip_tran_validation = true
    invoice.save

    account_tran = AccountTran.create do |t|
      t.user = user
      t.account_id = account_id
      t.account_transable = invoice
      t.amount = amount
      t.memo = memo
      t.property_id = self.property.id
      t.date = invoice.date
    end

    invoice
  end

  def setup_last_charged
    self.last_charged = Date.new(Date.today.year, Date.today.month, self.due_date.to_i)
  end

  def charge_prorated_rent
    rent_amount = self.rent
    days_in_month = Date.today.end_of_month.day
    todays_day = Date.yesterday.day

    prorated_rent = self.rent

    unless Date.today.day == 1
      prorated_rent = ((rent_amount / days_in_month) * (days_in_month - todays_day)).round(2)
    end

    enter_rent prorated_rent
  end

  def update_last_charged
    if self.last_charged && self.last_charged.day.to_s != self.due_date
      self.last_charged = Date.new(self.last_charged.year, self.last_charged.month, self.due_date.to_i)
    end
  end

  def self.search(search, display_param, user)
    if search
      query = "first_name LIKE ? OR middle_name LIKE ?"\
       " OR last_name LIKE ? OR concat_ws(' ' , first_name, middle_name, last_name) LIKE ?"\
       " OR concat_ws(' ' , first_name, last_name) LIKE ?"\
       " OR properties.address LIKE ?",
       "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%"

      if display_param.blank? || display_param == 'active'
        return joins(:property).where(query).where(user: user, active: true).order(:last_name)
      else
        return joins(:property).where(query).where(user: user)
      end
    else
      if display_param.blank? || display_param == 'active'
        return where(user: user, active: true).order(:last_name)
      else
        return where(user: user)
      end
    end
  end

  def full_name
    "#{self.first_name} #{self.middle_name} #{self.last_name}"
  end

  def archive
    self.toggle!(:active)
    self.property.toggle!(:rented)
  end
end
