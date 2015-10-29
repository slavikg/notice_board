module SessionsHelper
	def sign_in(user, social_network = false)
		# if social_network
			remember_token = User.new_remember_token
			cookies.permanent[:remember_token] = remember_token
			if social_network
				user.remember_token = User.encrypt(remember_token)
				user.save! validate: false
			else
				user.update_attribute(:remember_token, User.encrypt(remember_token))
			end
			self.current_user = user
		# else
		# 	self.current_user = user
		# end
	end

	def signed_in?
		!current_user.nil?
	end

	def current_user= user
		@current_user = current_user
	end

	def current_user
		remember_token = User.encrypt cookies[:remember_token]
		if session[:user_id]
			@current_user ||= User.find session[:user_id]
		else
			@current_user ||= User.find_by(remember_token: remember_token)
		end
	end

	def current_user? user
		user == current_user
	end

	def sign_out
		current_user.update_attribute(:remember_token,
			User.encrypt(User.new_remember_token))
		cookies.delete :remember_token
		self.current_user = nil
	end

	def redirect_back_or default
		redirect_to(session[:return_to] || default)
		session.delete :return_to
	end

	def store_location
		session[:return_to] = request.url if request.get?
	end

	def please_signin
		if !signed_in?
			store_location
			flash[:error] = "Please Sign in"
			redirect_to signin_path
		end
	end
end