class RecurringTran < ActiveRecord::Base
  belongs_to :user
  
  validates :user_id, presence: true
  validates :amount, presence: true
  validates :due_date, presence: true
  validates :tran_type, presence: true

  def self.memorize(item, due_date)
    # add num, vendor
    tran = RecurringTran.new(user: item.user, amount: item.amount, memo: item.memo, due_date: due_date, tran_type: item.class.name, account_trans: [])

    if item.class.name == "Check"
      tran.num = item.num
      tran.charge_id = item.vendor_id
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
  end
end
