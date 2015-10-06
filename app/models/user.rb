class User < ActiveRecord::Base
	before_save {self.email = email.downcase}
	validates :login, length: {maximum: 15}, presence: true, uniqueness: true
	validates :full_name, length: {in: 6..15}, presence: true
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
end
