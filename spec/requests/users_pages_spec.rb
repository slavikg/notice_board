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

	describe 'edit profile page' do
		let(:user) { FactoryGirl.create :user }
	  before {visit edit_user_path user}

	  it { should have_content 'Update your profile' }
	  it { should have_title 'Update user' }

	  describe 'with invalid information' do
	    before {click_button 'Save changes'}
	    it { should have_content 'error' }
	  end

	  describe 'with valid information' do
	    before {fillUserParams}
	  end
	end
end