class CommentsController < ApplicationController

	def create
		@advert = Advert.find params[:advert_id]
		@comment = @advert.comments.build comment_params
		@comment.user = current_user

		# flash[:success] = 'Your comment added'
		# flash[:notice] = "Comment can't be empty!"

		respond_to do |format|
			if @comment.save
				format.html {redirect_to @advert}
				format.js
			else
				format.html {redirect_to @advert}
			end
		end
	end

	def edit
		@comment = Comment.find params[:id]
		respond_to do |format|
			format.html {redirect_to @comment.advert}
			format.js
		end
	end

	def update
		@comment = Comment.find params[:id]
		respond_to do |format|
			if @comment.update_attributes comment_params
				format.html {redirect_to @comment.advert}
				format.js
			else
				format.html {render @comment.advert}
			end
		end
	end

	def destroy
		@advert = Advert.find params[:advert_id]
		@comment = @advert.comments.find(params[:id])

		@comment.delete if @comment.user == current_user

		respond_to do |format|
			format.html {redirect_to @advert}
			format.js
		end

		# redirect_to @advert
	end

	private

	def comment_params
		params.require(:comment).permit(:comment)
	end
end
