class Reconciliation < ActiveRecord::Base
  has_many :checks
  has_many :deposits
end
