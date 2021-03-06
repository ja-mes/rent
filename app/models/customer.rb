class Customer < ApplicationRecord

  attr_accessor :should_charge_rent
  attr_accessor :should_charge_deposit

  # ASSOCIATIONS
  belongs_to :user
  belongs_to :property
  has_many :payments, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_many :trans
  has_many :notes
  has_many :credits

  # VALIDATIONS
  validates :user_id, presence: true
  validates :property_id, presence: true, unless: :is_blank?
  validates :rent, presence: true, unless: :is_blank?
  validate :due_date_range, unless: :is_blank?
  validates :last_charged, presence: true, unless: :is_blank?
  validates :customer_type, inclusion: { in: ['blank', 'tenant'] }
  validate :name_is_present
  validate :property_not_internal, unless: :is_blank?

  # HOOKS
  before_validation :setup_last_charged, unless: :is_blank?
  before_update :update_last_charged, unless: :is_blank?
  after_create :charge_prorated_rent, unless: :is_blank?, if: :should_charge_rent
  after_create :update_property, unless: :is_blank?

  # CUSTOM VALIDATIONS
  def is_blank?
    customer_type == "blank"
  end

  def name_is_present
    if company_name.blank? && first_name.blank? && last_name.blank?
      errors.add(:base, 'Customer name must be present')
    end
  end

  def due_date_range
    unless (1..28).include?(self.due_date.to_i)
      errors.add(:base, "Due date must be between 1 and 28")
    end
  end

  def property_not_internal
    errors.add(:base, "Cannot rent internal property") if self.property && self.property.internal?
  end

  # METHODS
  def update_property
    self.property.update_attribute(:rented, true)
  end

  def enter_rent(amount = self.rent, memo = nil, account_id = nil)
    memo ||= "Rent for #{Date::MONTHNAMES[Date.today.month]} #{Date.today.year}"
    account_id ||= self.user.rental_income_account.id

    unless amount.to_d == 0
      invoice = self.invoices.build do |i|
        i.amount = amount
        i.date = Date.today
        i.due_date = Date.today
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
  end

  def setup_last_charged
    if self.new_record?
      self.last_charged = Date.new(Date.today.year, Date.today.month, self.due_date.to_i) if self.due_date
    end
  end

  def charge_prorated_rent
    rent_day = self.due_date.to_i
    rent_amount = self.rent
    days_this_month = Date.today.end_of_month.day
    todays_day = Date.yesterday.day

    if Date.today.day == rent_day
      prorated_rent = self.rent
    elsif rent_day == 1
      prorated_rent = ((rent_amount / days_this_month) * (days_this_month - todays_day)).round(2)
    else
      if rent_day < Date.today.day
        days_next_month = Date.today.next_month.end_of_month.day

        amount_for_this_month = ((rent_amount / days_this_month) * (days_this_month - todays_day))
        amount_for_next_month = ((rent_amount / days_next_month) * (rent_day - 1))

        prorated_rent = (amount_for_this_month + amount_for_next_month).round(2)
      else
        prorated_rent = ((rent_amount / days_this_month) * (rent_day - todays_day - 1)).round(2)
      end

    end

    enter_rent(prorated_rent)
  end

  def update_last_charged
    if self.last_charged && self.last_charged.day.to_s != self.due_date
      self.last_charged = Date.new(self.last_charged.year, self.last_charged.month, self.due_date.to_i)
    end
  end

  def full_name
    full_name = "#{first_name} #{middle_name} #{last_name}"
    if full_name.blank? then "#{company_name}" else full_name end
    end

    def archive
      self.toggle!(:active)

      self.property.toggle!(:rented) if self.property

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
          c.property = self.property if self.property
          c.date = credit.date
        end

        credit
      end
    end

    def grab_trans(display_param = nil)
      if display_param.blank? || display_param == 'payments'
        trans.includes(:transactionable).where(transactionable_type: "Payment").order(date: :desc)
      else
        trans.includes(:transactionable).order(date: :desc)
      end
    end

    def self.grab_all(user, display_param = nil)
      if display_param.blank? || display_param == 'active'
        includes(:property).where(user: user, active: true).order(last_name: :asc, first_name: :asc, company_name: :asc)
      else
        where(user: user).order(last_name: :asc, first_name: :asc, company_name: :asc)
      end
    end
  end
