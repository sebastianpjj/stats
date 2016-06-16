class CreateItemBundles < ActiveRecord::Migration
  def change
    create_table :item_bundles do |t|
    	t.integer :item_id 
    	t.integer :item_source_id
    	t.float :item_source_quantity
    	t.timestamps null: false
    end
  end
end
