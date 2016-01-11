class UsersController < ApplicationController
	before_action :signed_in_user, only: [:edit, :update]
	before_action :correct_user, only: [:edit, :update]
	before_action :hash_for_gmap, only: [:show, :new, :edit]

	def index
		@users = User.all.paginate(page: params[:page], per_page: 20)
	end

	def show
		@user = User.find params[:id]
		@adverts = @user.adverts.paginate(page: params[:page], per_page: 6)
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new user_params
		if @user.save
			flash[:success] = "Welcome to the notice board!"
			sign_in @user
			redirect_to @user
		else
			render 'new'
			# redirect_to signup_path
		end
	end

	def edit
	end

	def update
		if @user.update_attributes user_params
			redirect_to @user
		else
			render 'edit'
		end
	end

	def update_user_role
		@user = User.find params[:id]
		@user.role = params[:user][:role]
		@user.save! validate: false
		redirect_to @user
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

		def hash_for_gmap
			return if params[:id].blank?
			@hash = Gmaps4rails.build_markers(User.find(params[:id])) do |user, marker|
			  marker.lat user.latitude
			  marker.lng user.longitude
			end
		end
end
