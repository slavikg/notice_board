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
		# advert = current_user.
	end
end
