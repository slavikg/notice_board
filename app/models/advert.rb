class Advert < ActiveRecord::Base

	belongs_to :user
	has_many :comments

	validates :name, presence: true, length: {maximum: 60}
	validates :description, presence: true, length: {maximum: 800}
	VALID_TAGS_REGEX = /\A^([0-9a-z_][^\s,'+-]+)(\s[^\s,'+-][0-9a-z_]+)*$\z/i
	validates :tags, allow_blank: true, format: {with: VALID_TAGS_REGEX,
		message: "should be separated by a space and begin without #"}

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
		# joins(:user).where("(adverts.name || adverts.description || adverts.tags like :search_param)
		# 	|| (users.full_name || users.address || users.city || users.state ||
		# 	users.country || users.zip like :search_param)",
		# 	{search_param: "%#{params}%"})
		joins(:user).where("adverts.name LIKE :search_param OR adverts.description LIKE :search_param OR
			adverts.tags LIKE :search_param OR users.full_name LIKE :search_param OR
			users.address LIKE :search_param OR users.city LIKE :search_param OR users.state LIKE :search_param OR
			users.country LIKE :search_param OR users.zip LIKE :search_param",
			{search_param: "%#{params}%"})
	end
	
end