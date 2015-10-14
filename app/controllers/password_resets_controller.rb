class PasswordResetsController < ApplicationController
	before_filter :set_host_from_request, only: [:create]

	def new
	end

	def create
		if params[:email].blank?
			flash.now[:notice] =  'Enter your email'
			render :new
		else
			user = User.find_by_email params[:email]
			user.send_password_reset if user
			flash[:success] = "Email sent with password reset instruction."
			redirect_to root_url
		end
	end

	def edit
		@user = User.find_by_password_reset_token! params[:id]
	end

	def update
		@user = User.find_by_password_reset_token! params[:id]
		if @user.password_reset_sent_at < 2.hours.ago
			flash[:error] = 'Password reset has expired'
			redirect_to new_password_reset_path
		elsif @user.update_attributes user_params
				flash[:success] = 'Password has been reset!'
				redirect_to root_url
		else
			render :edit
		end
	end

	private
		def set_host_from_request
			ActionMailer::Base.default_url_options = { host: request.host_with_port }
		end

		def user_params
			params.require(:user).permit(:login, :full_name, :birthday, :email, :address,
					:city, :state, :country, :zip, :password, :password_confirmation)
		end
end
