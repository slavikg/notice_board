class UsersController < ApplicationController
	before_action :signed_in_user, only: [:edit, :update]
	before_action :correct_user, only: [:edit, :update]

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
		@hash = Gmaps4rails.build_markers(@user) do |user, marker|
		  marker.lat user.latitude
		  marker.lng user.longitude
		end
	end

	def update
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

		# Before filters

		def signed_in_user
			store_location
			redirect_to signin_url, notice: "Please sign in." if !signed_in?
		end

		def correct_user
			@user = User.find params[:id]
			redirect_to(root_url) if !current_user?(@user)
		end
end
