class AdvertsController < ApplicationController

	def index		
		@adverts = Advert.all
	end

	def show
		@advert = Advert.find params[:id]
	end
end
