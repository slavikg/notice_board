class AnswersController < ApplicationController
	
	authorize_resource

	def create
		@advert = Advert.find params[:advert_id]
		@answer = @advert.answers.build answers_params
		@answer.user = current_user
		@answer.save

		redirect_to advert_url
	end

	def destroy
		@advert = Advert.find params[:advert_id]
		@answer = @question.answers.find(params[:id]).destroy

		redirect_to advert_url
	end

	private

	def answers_params
		params.require(:answer).permit(:comment)
	end
end
