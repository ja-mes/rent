class EnterRecurringTransJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    today = Date.today
    user = User.find(user_id)

    user.recurring_trans.where('last_charged <= ?', today.prev_month).find_each do |tran|
      num_months = (today.year * 12 + today.month) - (tran.last_charged.year * 12 + tran.last_charged.month)
      
      num_months.times do
        tran.tran_type.singularize.classify.constantize.enter_recurring_tran(tran)
        tran.after_entry
      end
    end
  end
end
