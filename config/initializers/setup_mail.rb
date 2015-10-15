ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
	address:              'smtp.gmail.com',
	port:                 587,
	domain:               'gmail.com',
	user_name:             ENV["GMAIL_USERNAME"], 
	password:              ENV["GMAIL_PASSWORD"],
	authentication:       'plain',
	enable_starttls_auto: true  }
ActionMailer::Base.default_url_options = {
	host: "localhost:3000" } if Rails.env.development?
ActionMailer::Base.default_url_options = {
	host: "slavikg-notice-board.herokuapp.com" } if Rails.env.production?