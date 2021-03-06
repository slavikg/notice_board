require 'spec_helper'

describe 'Comments' do
	# let(:user) { FactoryGirl.create :user }
	# let!(:comment) { FactoryGirl.create :comment }
	# before {sign_in comment.user}
	subject {page}

	describe 'advert show' do

		describe 'user_without_comment' do
			let(:advert_without_comments) { FactoryGirl.create :advert }
			before {visit advert_path advert_without_comments}

			it { should have_content 'Please sign in for read and create comment' }
			it 'after sign in' do
				sign_in advert_without_comments.user
				visit advert_path advert_without_comments
				should have_content 'No comments'
			end
		end

		describe 'add comment with sign user' do
			# let(:user_for_sign_in) { FactoryGirl.create :user }
			let!(:comment) { FactoryGirl.create :comment }
			before do
				sign_in comment.user
				visit advert_path comment.advert
			end

			describe 'with empty data' do
				it do
					expect{click_button 'Create comment'}.to change(Comment, :count).by(0)
					# should have_content "Comment can't be empty!"
				end
			end

			describe 'with data' do
				before {fill_in 'Comment', with: comment.comment}

				it do
					expect{click_button 'Create comment'}.to change(Comment, :count).by(1)
					should_not have_content 'No comments'
					should have_content 'Comments'
				end

				describe 'check content' do
					before {click_button 'Create comment'}

					# it {should have_content 'Your comment added'}
					it {should have_content comment.comment}
					it {should have_content comment.user.full_name}
				end

				describe 'delete comment' do

				  it 'with correct user' do
				  	expect{click_link 'Delete comment'}.to change(Comment, :count).by(-1)
				  	should have_content 'No comments'
						should_not have_content 'Comments'
				  end

				  describe 'with incorrect user' do
				    let(:incorrect_user) { FactoryGirl.create :user }
				    before do
				    	sign_in incorrect_user
				    	visit advert_path comment.advert
				    end

				    it { should_not have_link 'Delete comment' }
				  end
				end

				# it 'edit comment' do
				# 	Capybara.automatic_reload = false
				# 	find("#comment_#{comment.id}").click_link 'Edit comment'
				# 	fill_in 'Comment', with: 'Edited comment'
				# 	click_button 'Edit comment'
				# 	save_and_open_page
				# 	# comment.comment == 'Edited comment'
				# 	# should have_content 'Edited comment'
				# end
			end

			describe 'comment with textile content' do
			  before do
			  	fill_in 'Comment', with: '*strong*'
			  	click_button 'Create comment'
			  end
			  it { should have_selector 'strong', text: 'strong' }
			end
		end

	end
end