class Customer < ActiveRecord::Base
  # ASSOCIATIONS
  belongs_to :user
  belongs_to :property
  has_many :payments, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_many :trans
  has_many :notes
  has_many :credits

  # VALIDATIONS
  # TODO validate customer_type with inclusion
  validates :user_id, presence: true
  validates :property_id, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :rent, presence: true
  validate :due_date_range
  validates :last_charged, presence: true

  # HOOKS
  before_validation :setup_last_charged
  before_update :update_last_charged
  after_create :charge_prorated_rent

  def due_date_range
    unless (1..28).include?(self.due_date.to_i) 
      errors.add(:base, "Due date must be between 1 and 28")
    end
  end

  after_create do
    self.property.update_attribute(:rented, true)
  end

  def enter_rent(amount = self.rent, memo = nil, account_id = nil)
    memo ||= "Rent for #{Date::MONTHNAMES[Date.today.month]} #{Date.today.year}"
    account_id ||= self.user.rental_income_account.id

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
    if self.new_record?
      self.last_charged = Date.new(Date.today.year, Date.today.month, self.due_date.to_i) if self.due_date
    end
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

  def full_name
    "#{self.first_name} #{self.middle_name} #{self.last_name}"
  end

  def archive
    self.toggle!(:active)
    self.property.toggle!(:rented)

    if self.balance > 0
      credit = self.credits.build do |c|
        c.user = self.user
        c.amount = self.balance
        c.date = Date.today
        c.memo = "Write off remaining balance"
      end
      credit.skip_tran_validation = true
      credit.save

      account_tran = AccountTran.create do |c|
        c.user = self.user
        c.account = self.user.rental_income_account
        c.account_transable = credit
        c.amount = -credit.amount
        c.memo = credit.memo
        c.property = self.property
        c.date = credit.date
      end

      credit
    end
  end

  def self.search(search, display_param, user)
    if search
      query = "first_name ilike ? OR middle_name ilike ?"\
        " OR last_name ilike ? OR concat_ws(' ' , first_name, middle_name, last_name) ilike ?"\
        " OR concat_ws(' ' , first_name, last_name) ilike ?"\
        " OR properties.address ilike ?",
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
end
