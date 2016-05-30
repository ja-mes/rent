class EnterRecurringTransJob < ActiveJob::Base
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)

    user.recurring_trans.where(due_date: Date.today.day.to_s).find_each do |tran|
      tran.tran_type.singularize.classify.constantize.enter_recurring_tran(tran)
    end
  end
end
