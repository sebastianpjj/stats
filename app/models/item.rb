class Item < ActiveRecord::Base
	has_many :itemBundles
	has_many :orders

end
