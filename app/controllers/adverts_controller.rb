class AdvertsController < ApplicationController

	before_action :access_to_action, only: [:edit, :update, :destroy]

	def index
		@adverts = Advert.all.paginate(page: params[:page])
	end

	def show
		@advert = Advert.find params[:id]
		@comments = @advert.comments
		# @comment = @advert.comments.build
	end

	def new
		please_signin
		@advert = Advert.new
	end

	def create
		@advert = current_user.adverts.build advert_params
		if @advert.save
			redirect_to @advert
		else
			# flash[:error] = "Fill in all "
			render 'new'
		end
	end

	def edit
	end

	def update
		@advert.update_attributes advert_params
		if @advert.save
			flash[:success] = 'Advert update success!'
			redirect_to @advert
		else
			render 'edit'
		end
	end

	def destroy
		@advert = Advert.find params[:id]
		@advert.destroy
		flash[:success] = 'Your advert have been deleted!'
		redirect_to root_url
	end

	private

	def advert_params
		params.require(:advert).permit(:name, :description, :image)
	end

	def access_to_action
		@advert = Advert.find params[:id]
		redirect_to @advert,
			notice: "You don't have permittion to edit this advert! Please sign in if this your advert" if !current_user?(@advert.user)
	end
end
