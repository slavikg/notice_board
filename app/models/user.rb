class User < ActiveRecord::Base

	has_many :adverts
	has_many :comments
	
	before_save {self.email.downcase!}
	before_create :create_remember_token

	geocoded_by :full_address
	before_create :geocode
	before_update :geocode

	validates :login, length: {maximum: 15}, presence: true, uniqueness: true
	validates :full_name, length: {in: 6..30}, presence: true
	validates :birthday, presence: true
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, format: {with: VALID_EMAIL_REGEX},
		uniqueness: true
	validates :address, length: {in: 6..15}, presence: true
	validates :city, length: {maximum: 20}, presence: true
	validates :state, length: {maximum: 20}, presence: true
	validates :country, length: {maximum: 20}, presence: true
	validates :zip, length: {is: 5}, presence: true,
		numericality: { only_integer: true }
	validates :password, length: {in: 6..15}
	validates :password_confirmation, length: {in: 6..15}, presence: true

	has_secure_password

	ROLES = %w[admin moderator user]

	def full_address
		self.address.to_s + ' ' + self.city.to_s + ' ' + self.state.to_s + ' ' + self.country.to_s + ' ' + self.zip.to_s
	end

	def send_password_reset
		generate_token :password_reset_token
		self.password_reset_sent_at = Time.zone.now
		# self.password = 'foobar'
		# self.password_confirmation = 'foobar'
		self.save! validate: false
		UserMailer.password_reset(self).deliver
	end

	def generate_token column
		begin
			self[column] = SecureRandom.urlsafe_base64
		end while User.exists?(column => self[column])
	end

	def User.new_remember_token
		SecureRandom.urlsafe_base64
	end

	def User.encrypt token
		Digest::SHA1.hexdigest token.to_s
	end

	def self.sign_in_from_omniauth auth
		find_by(provider: auth['provider'], uid: auth['uid']) || 
			create_user_from_omniauth(auth)
	end

	def self.create_user_from_omniauth auth
		user = new(provider: auth['provider'], uid: auth['uid'], full_name: auth['info']['name'],
			address: auth['info']['location'], birthday: auth['extra']['birthday'],
			image_url: auth['info']['image'], email: auth['info']['email'].to_s,
			password: '84181949asdqwezxc19498418', password_confirmation: '84181949asdqwezxc19498418')
		user.save! validate: false
		user
		# user = create(provider: auth['provider'], uid: auth['uid'], full_name: auth['info']['name'],
				# login: auth['info']['nickname'], address: auth['info']['location'],
				# email: auth['info']['email'])
		# user.save! validate: false
		# user
	end

	# def self.search_for_advert(params)
	# 	select(:id).where("full_name like :search_user",
	# 		{search_user: "%#{params}%"})
	# end

	def role? role
		role.to_s == self.role
	end

	private
		def create_remember_token
			self.remember_token = User.encrypt User.new_remember_token
		end
end
