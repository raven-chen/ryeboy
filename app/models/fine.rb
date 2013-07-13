class Fine < ActiveRecord::Base
  attr_accessible :amount, :comment, :date, :paid, :reason, :user_id

  belongs_to :user

  validates :user, :amount, :date, :reason, :presence => true
end
