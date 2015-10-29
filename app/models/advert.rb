class Advert < ActiveRecord::Base
	belongs_to :user
	has_many :comments

	self.per_page = 8
end
