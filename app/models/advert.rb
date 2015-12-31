class Advert < ActiveRecord::Base

	belongs_to :user
	has_many :comments

	validates :name, presence: true, length: {maximum: 60}
	validates :description, presence: true, length: {maximum: 800}

	has_attached_file :image,
		url: '/system/a1dvert/:attachment/:id_partition/:style/:filename',
		styles: { medium: "300x200>", thumb: "100x50>" }, default_url: "/images/:style/no_image.jpg"
	# has_attached_file :image,
	# 	storage: :dropbox, dropbox_credentials: Rails.root.join("config/dropbox.yml"),
	# 	dropbox_options: {path: proc {|style| "notice_board/#{id}/#{style}/#{image.original_filename}" }},
	# 	# url: '/system/a1dvert/:attachment/:id_partition/:style/:filename',
	# 	path: "notice_board/:attachment/:id_partition/:style/:filename",
	# 	styles: { medium: "300x200>", thumb: "100x50>" }, default_url: "/images/:style/no_image.jpg"
	validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

	self.per_page = 8

	def self.search(params)
		# where("(name || description like :search_param) || (user_id like :search_by_user)",
		# 		{search_param: "%#{params}%",
		# 		search_by_user: "%#{User.search_for_advert(params)}%" })
		joins(:user).where("(adverts.name || adverts.description like :search_param) ||
			(users.full_name || users.address || users.city || users.state ||
			users.country || users.zip like :search_param)",
			{search_param: "%#{params}%"})
	end
	
end