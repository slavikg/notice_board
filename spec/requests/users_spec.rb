require 'spec_helper'

describe "User" do
	before do
		@user = User.new(login: "sdfsdf", full_name: "sddgfgsdf",
					birthday: "20 02 1994", email: "example@gmail.com", address: "sdfsdfd",
					city: "sdfsgsdg", state: "sdgrgsdf", country: "sdfsfaag", zip: 12345,
					password: " ", password_confirmation: " ")
	end
	let(:user) { FactoryGirl.create :user }
	subject {user}

	it { should respond_to :login }
	it { should respond_to :full_name }
	it { should respond_to :birthday }
	it { should respond_to :email }
	it { should respond_to :address }
	it { should respond_to :city }
	it { should respond_to :state }
	it { should respond_to :country }
	it { should respond_to :zip }
	it { should respond_to :password }
	it { should respond_to :password_confirmation }
	it { should respond_to :remember_token }
	it { should respond_to :authenticate }
	it { should respond_to :password_digest }

	it { should be_valid }

	describe "wrong width state" do
		before {user.zip = 123456}
		it { should_not be_valid }
	end

	describe "when email format is invalid" do
		let(:addresses) do
			%w[user@foo,com user_at_foo.org example.user@foo foo@bar_baz.com foo@bar+baz.com]
		end

		it "should be invalid" do
			addresses.each do |address|
				user.email = address
				expect(user).not_to be_valid
			end
		end
	end
	describe "when email format is valid" do
		let(:addresses) do
			%w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
		end

		it "should be valid" do
			addresses.each do |address|
				user.email = address
				expect(user).to be_valid
			end
		end
	end

	# describe "when email/login is already taken" do
	#   before do
	#     user_with_same_email_login = user.dup
	#     user_with_same_email_login.full_name = "qqq"
	#     user_with_same_email_login.email.upcase!
	#     user_with_same_email_login.save
	#   end

	#   it { should_not be_valid }
	# end

	describe "when password is not present" do
		before do
			@user_without_password = User.new(login: "sdfsdf", full_name: "sddgfgsdf",
					birthday: "20 02 1994", email: "example@gmail.com", address: "sdfsdfd",
					city: "sdfsgsdg", state: "sdgrgsdf", country: "sdfsfaag", zip: 12345,
					password: " ", password_confirmation: " ")
		end
		it do
			expect(@user_without_password).not_to be_valid
		end
	end

	describe "when password doesn't match confirmation" do
		before {@user.password_confirmation = "mismatch"}
		it { expect(@user).not_to be_valid }
	end

	describe 'remember token' do
		before {@user.save}
		its(:remember_token) { should_not be_blank }
	end

	describe 'check admin.role == moderator' do
		let(:moderator) { FactoryGirl.create :user, role: "moderator" }
	  let(:ability) { Ability.new moderator }
	  it 'check ability' do
	  	ability.should be_able_to :manage, user.adverts.build
	  	ability.should be_able_to :manage, moderator.adverts.build

	  	ability.should be_able_to :manage, user.comments.build
	  	ability.should be_able_to :manage, moderator.comments.build

	  	ability.should_not be_able_to :modify, user
	  	ability.should be_able_to :update, moderator
	  end
	end

	describe 'authentication' do

		describe 'for non-signed users' do
			let(:user) { FactoryGirl.create :user }

			describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path user
          sign_in user
        end

        describe "after signing in" do
          it "should render the desired protected page" do
            expect(page).to have_title('Update user')
          end
        end
      end

			describe "visiting the edit page" do
				before { visit edit_user_path user }
				it { expect(page).to have_title('Sign in') }
			end

			describe "submitting to the update action" do
				before { patch user_path user }
				specify { expect(response).to redirect_to signin_path }
			end
		end

		describe 'as wrong user' do
		  let(:user) { FactoryGirl.create :user }
		  let(:wrong_user) { FactoryGirl.create(:user, login: "wrong", email: "wrong@gmail.com") }
		  before {sign_in user, no_capybara: true}

		  describe "submitting a GET request to the Users#edit action" do
        before { get edit_user_path(wrong_user) }
        specify { expect(response.body).not_to match('Edit user') }
        specify { expect(response).to redirect_to(root_url) }
      end

      describe "submitting a PATCH request to the Users#update action" do
        before { patch user_path(wrong_user) }
        specify { expect(response).to redirect_to(root_url) }
      end
		end
	end
end