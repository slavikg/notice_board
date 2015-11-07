class Advert < ActiveRecord::Base
	belongs_to :user
	has_many :comments

	validates :name, presence: true, length: {maximum: 60}
	validates :description, presence: true, length: {maximum: 800}

	has_attached_file :image,
		url: '/system/a1dvert/:attachment/:id_partition/:style/:filename',
		styles: { medium: "300x200>", thumb: "100x50>" }, default_url: "/images/:style/no_image.jpg"
	validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

	self.per_page = 8
end
