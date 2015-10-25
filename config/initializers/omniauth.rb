Rails.application.config.middleware.use OmniAuth::Builder do
	provider :facebook, '1050100865040712',
		'd5a56521d82c3244a46a2f718db64d58',
		scope: 'email, user_location',
		info_fields: 'email, name, birthday, location',
		image_size: "large"
		# scope: 'public_profile,email,user_about_me', display: 'popup'

	provider :twitter, 'TuaDZ7jpTwkNVggpgokS7mAIt',
		'j6Olg09ijP3HVicmWFqXTWiMU8GQPI0Fa0sPMkOPxsBP6Gfig6',
		secure_image_url: true, image_size: 'bigger'

	provider :google_oauth2,
		'854556902707-4lhrpos7osg33ebm9q7e8mi8kub820gv.apps.googleusercontent.com',
		'I62rY50pUbamlCg8NR4VhEuy',
		access_type: 'online',
		scope: 'profile', image_aspect_ratio: 'square', image_size: 90,
		name: 'google', prompt: "consent", redirect_uri: true
end