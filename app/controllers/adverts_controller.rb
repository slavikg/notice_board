class AdvertsController < ApplicationController

	def index
		@adverts = Advert.all.paginate(page: params[:page])
	end

	def show
		@advert = Advert.find params[:id]
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

	private

	def advert_params
		params.require(:advert).permit(:name, :description, :image)
	end
end
