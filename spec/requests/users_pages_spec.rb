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
	  before {visit user_path user}
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
	end
end