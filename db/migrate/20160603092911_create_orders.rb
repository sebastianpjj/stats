class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
    	t.integer :order_id
    	t.integer :item_id
    	t.float :item_quantity
    	t.float :order_amount
    	t.datetime :order_timestamp
    	t.string :order_referrer
    	t.timestamps null: false 
    end
  end
end
