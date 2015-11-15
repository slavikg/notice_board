class Comment < ActiveRecord::Base

	belongs_to :user
	belongs_to :advert

	validates :comment, presence: true
end
