class Advert < ActiveRecord::Base
	belongs_to :user
	has_many :comments

	validates :name, presence: true, length: {maximum: 60}
	validates :description, presence: true, length: {maximum: 800}

	self.per_page = 8
end
