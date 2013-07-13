class FundExchangeActivity < ActiveRecord::Base
  attr_accessible :amount, :commet, :date, :exchange_type, :place, :trading_way, :usage, :user_id

  belongs_to :user

  validates :user, :exchange_type, :amount, :date, :trading_way, :usage, :presence => true

  validates_inclusion_of :exchange_type, :in => %w(deposit withdraw)
end
