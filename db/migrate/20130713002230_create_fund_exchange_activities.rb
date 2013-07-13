class CreateFundExchangeActivities < ActiveRecord::Migration
  def change
    create_table :fund_exchange_activities do |t|
      t.integer :user_id
      t.date :date
      t.string :place
      t.string :trading_way
      t.string :exchange_type
      t.integer :amount
      t.string :usage
      t.text :comment

      t.timestamps
    end
  end
end
