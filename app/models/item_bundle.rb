class ItemBundle < ActiveRecord::Base
	belongs_to :item
	has_many :orders
end
