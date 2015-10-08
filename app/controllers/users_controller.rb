class UsersController < ApplicationController

	def show
		@user = User.find params[:id]
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new user_params
		if @user.save
			flash[:success] = "Welcome to the notice board!"
			redirect_to @user
		else
			render 'new'
			# redirect_to signup_path
		end
	end

	def edit
		@user = User.find params[:id]
	end

	def update
		@user = User.find params[:id]
		if @user.update_attributes user_params
			redirect_to @user
		else
			render 'edit'
		end
	end

	private
		def user_params
			params.require(:user).permit(:login, :full_name, :birthday, :email, :address,
					:city, :state, :country, :zip, :password, :password_confirmation)
		end
end
