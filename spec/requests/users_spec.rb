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
end