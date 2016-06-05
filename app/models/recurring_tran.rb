class RecurringTran < ActiveRecord::Base
  # ASSOCIATIONS
  belongs_to :user
  
  # VALIDATIONS
  validates :user_id, presence: true
  validates :amount, presence: true
  validates :due_date, presence: true
  validates :tran_type, presence: true
  validates :last_charged, presence: true
  
  # HOOKS
  after_initialize :setup_last_charged
  before_update :update_last_charged

  def setup_last_charged
    if self.new_record?
      self.last_charged = Date.new(Date.today.year, Date.today.month, self.due_date.to_i)
    end
  end

  def update_last_charged
    if self.last_charged.day.to_s != self.due_date
      self.last_charged = Date.new(self.last_charged.year, self.last_charged.month, self.due_date.to_i)
    end
  end

  def next_entry_date
    self.last_charged + 1.month
  end

  def self.memorize(item, due_date)
    # add num, vendor
    tran = RecurringTran.new(user: item.user, amount: item.amount, memo: item.memo, due_date: due_date, tran_type: item.class.name, account_trans: [])

    case item.class.name
    when "Check"
      tran.num = item.num
      tran.charge_id = item.vendor_id
    when "Invoice"
      tran.charge_id = item.customer_id
    end

    item.account_trans.each do |act_tran|
      tran.account_trans << {
        account_id: act_tran[:account_id],
        amount: act_tran[:amount], 
        memo: act_tran[:memo],
        property_id: act_tran[:property_id],
      }
    end

    tran.save
    tran
  end
end
