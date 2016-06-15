class CreateDefaultAccountsJob < ActiveJob::Base
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    user.create_default_accounts
  end
end
