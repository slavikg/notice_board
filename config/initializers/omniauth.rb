Rails.application.config.middleware.use OmniAuth::Builder do
	provider :facebook, ENV['FACEBOOK_TOKEN'], ENV['FACEBOOK_SECRET'],
		scope: 'email, user_location',
		info_fields: 'email, name, birthday, location',
		image_size: "large"
		# scope: 'public_profile,email,user_about_me', display: 'popup'

	provider :twitter, ENV['TWITTER_TOKEN'], ENV['TWITTER_SECRET'],
		secure_image_url: true, image_size: 'bigger'

	provider :google_oauth2, ENV['GPLUS_TOKEN'], ENV['GPLUS_SECRET'],
		access_type: 'online',
		scope: 'profile', image_aspect_ratio: 'square', image_size: 90,
		name: 'google', prompt: "consent", redirect_uri: true
end