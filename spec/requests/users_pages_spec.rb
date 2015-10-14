require 'spec_helper'

describe "User pages" do
	subject {page}

	describe "signup page" do
		before {visit signup_path}
		let(:submit) { "Create a new user" }
		it { should have_content 'Sign up' }
		it { should have_title 'Sign up' }

		describe "when invalid information" do
		  it "should not create a user" do
		  	expect{click_button submit}.not_to change(User, :count)
		  end
		end

		describe "when valid information" do
		  before {fillUserParams}
		  it "should create a user" do
		  	expect{click_button submit}.to change(User, :count).by(1)
		  end
		end
	end

	describe 'signin page' do
	  before {visit signin_path}

	  it { should have_title 'Sign in' }
	  it { should have_content 'Sign in' }

	  describe 'with invalid information' do
	    before {click_button 'Sign in'}
	    
		  it { should have_title 'Sign in' }
		  it { should have_selector 'div.alert.alert-error' }

		  describe 'after visiting another page' do
		    before {visit signup_path}
			  it { should_not have_selector 'div.alert.alert-error' }
		  end
	  end

	  describe 'with valid information' do
	    let(:user) { FactoryGirl.create :user }
	    before do
	      fill_in "Login", with: user.login
	      fill_in "Password", with: user.password
	      click_button 'Sign in'
	    end

	    it { should have_title user.login }

	    describe 'by signout' do
	      before {click_link 'Sign out'}
	      it { should have_link 'Sign in' }
	    end
	  end

	  describe 'with forgotten password link' do
	    it { should have_link('Forgotten password?', new_password_reset_path) }

	    describe 'when click to "Forgotter password" link' do
	      before {click_link 'Forgotten password?'}
	      it { should have_title 'Reset password' }

	      describe 'when click "Reset password" without email' do
	        before {click_button 'Reset Password'}
	        it { should have_content 'Enter your email' }
	      end

	      describe 'when click "Reset password" with email' do
	      	let(:user) { FactoryGirl.create :user }
	        before do
	        	fill_in 'Email', with: user.email
	        	click_button 'Reset Password'
	        end
	        it { should have_content 'Email sent with password reset instruction.' }

	        describe 'change password page' do
	          before do
	          	user.send_password_reset
	          	visit edit_password_reset_path(user.password_reset_token)
	          end

	          describe 'with empty data' do
	          	before {click_button 'Update Password'}
		          it { should have_selector 'div.alert.alert-error' }
	          end

	          describe 'with data' do
	          	before do
	          		fill_in 'Password', with: 'foobar'
	          		fill_in 'Password confirmation', with: 'foobar'
	          		click_button 'Update Password'
	          	end
		          it { should have_content 'Password has been reset!' }
	          end
	        end
	      end
	    end
	  end
	end

	describe 'edit profile page' do
		let(:user) { FactoryGirl.create :user }
	  before do
	  	visit signin_path
	  	sign_in user
	  	visit edit_user_path user
	  end

	  it { should have_content 'Update your profile' }
	  it { should have_title 'Update user' }
	  it { should have_selector 'div#map' }

	  describe 'with invalid information' do
	    before {click_button 'Save changes'}
	    it { should have_content 'error' }
	  end

	  describe 'with valid information' do
	    before {fillUserParams}
	  end
	end

	describe 'show user page' do
		let(:user) { FactoryGirl.create :user }
	  before do
	  	sign_in user
	  end
	  it { should have_title user.login }
	  it { should have_content user.login }
	  it { should have_link('Edit my profile', edit_user_path(user)) }
	  it { should have_content user.full_name }
	  it { should have_content user.birthday }
	  it { should have_content user.email }
	  it { should have_content user.address }
	  it { should have_content user.city }
	  it { should have_content user.state }
	  it { should have_content user.country }
	  it { should have_content user.zip }

	  describe 'when show another users page' do
	    let(:invalid_user) { FactoryGirl.create :user }
	    before {visit user_path invalid_user}
	  	it { should_not have_content 'Edit my profile' }
	  end
	end
end