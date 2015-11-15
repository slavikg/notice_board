class CommentsController < ApplicationController

	def create
		@advert = Advert.find params[:advert_id]
		@comment = @advert.comments.build comment_params
		@comment.user = current_user

		if @comment.save
			flash[:success] = 'Your comment added'
		else
			flash[:notice] = "Comment can't be empty!"
		end

		redirect_to @advert
	end

	def destroy
		@advert = Advert.find params[:advert_id]
		@comment = @advert.comments.find(params[:id])

		@comment.delete if @comment.user == current_user

		redirect_to @advert
	end

	private

	def comment_params
		params.require(:comment).permit(:comment)
	end
end
