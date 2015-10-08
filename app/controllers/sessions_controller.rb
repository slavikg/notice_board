class SessionsController < ApplicationController
	def new
	end

	def create
		user = User.find_by(login: params[:session][:login].downcase)
		if user and user.authenticate params[:session][:password]
			sign_in user
			redirect_to user
		else
			flash.now[:error] = 'Invalid login/password combination'
			render 'new'
		end
	end

	def destroy
		sign_out
		redirect_to signin_path
	end
end
