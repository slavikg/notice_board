class SessionsController < ApplicationController
	def new
	end

	def create
		cookies.delete :remember_token
		self.current_user = nil
		session[:user_id] = nil
		session[:omniauth] = nil
		session[:auth] = nil
		session.delete :auth
		# raise env["omniauth.auth"].to_yaml
		# raise request.env["omniauth.auth"].to_yaml
		# render :text => request.env["omniauth.auth"]
		if params[:session]
			user = User.find_by(login: params[:session][:login].downcase)
			if user and user.authenticate params[:session][:password]
				sign_in user
				redirect_back_or user
			else
				flash.now[:error] = 'Invalid login/password combination'
				render 'new'
			end
		else
			auth = request.env["omniauth.auth"]
			# session[:auth] = auth
			session[:omniauth] = auth.except('extra')
			user = User.sign_in_from_omniauth(auth)
			session[:user_id] = user.id
			sign_in(user, true)
			redirect_back_or user
			# redirect_to root_url
		end
	end

	def destroy
		sign_out
		session[:user_id] = nil
		session[:omniauth] = nil
		session[:auth] = nil
		redirect_to signin_path
	end
end