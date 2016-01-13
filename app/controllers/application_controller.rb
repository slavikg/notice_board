class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception
	include SessionsHelper

	unless Rails.application.config.consider_all_requests_local
		rescue_from ActionController::RoutingError do |exception|
			flash[:error] = exception.message
			redirect_to root_url
		end
	rescue_from ActiveRecord::RecordNotFound do |exception|
		flash[:error] = exception.message
		redirect_to root_url
	end
	rescue_from CanCan::AccessDenied do |exception|
		redirect_to root_url, :alert => exception.message
	end
end
