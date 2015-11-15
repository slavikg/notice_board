require 'spec_helper'

describe 'Page Adverts' do

	subject {page}

	describe 'Index' do
		before {visit adverts_path}

		it { should have_title 'Adverts' }
		it { should have_content 'No adverts' }

		describe 'author advert' do
		  let!(:advert) { FactoryGirl.create :advert }
		  before {visit adverts_path}
		  it { should have_content advert.name }
		  it { should have_content "Author: #{advert.user.full_name}" }
		end
	end

	describe 'Show' do
		let(:advert) { FactoryGirl.create :advert }
		let(:user) { advert.user }
		before do
			visit advert_path(advert)
		end
		it { should have_title advert.name }
		# it { should have_css 'img[alt="image"]' }
		it { should have_content advert.name }
		it { should have_content advert.description }
		it { should have_content "Author: #{advert.user.full_name}" }
		it { should have_link(advert.user.full_name, user_path(advert.user)) }

		describe 'without photo' do
			before do
				advert.update_attributes(image: "")
				advert.save!
				visit advert_path(advert)
			end

			it { should have_css 'img[alt="no image"]' }
		end

		describe 'delete advert' do
			# CanCan
		  # it { should_not have_link 'Delete advert' }

		  describe 'with sign user' do
		    before do
		    	sign_in user
		    	visit advert_path advert
		    end
		    
			  it { should have_link 'Delete advert' }
			  describe 'after delete' do
			    it { expect{click_link 'Delete advert'}.to change(Advert, :count).by(-1) }
			  end
		  end
		end
	end

	describe 'New' do
	  before {visit new_advert_path}

	  describe 'non-signin user' do
		  it {should have_content 'Please Sign in'}
	  end

	  describe 'with sign user' do
	  	let(:user) { FactoryGirl.create :user }
	    before {sign_in user}

		  it {should have_title 'New advert'}

		  describe 'create advert with empty data' do
		    before {click_button 'Create Advert'}

		    it { should have_selector 'div.alert.alert-error' }
		  end

		  describe 'create advert with full data' do
		  	let(:advert) { FactoryGirl.create :advert }
		    before do
		    	fill_in 'Name', with: advert.name
		    	fill_in 'Description', with: advert.description
		    	click_button 'Create Advert'
		    end

		    it { should have_title advert.name }
		  end
	  end
	end

	describe 'Edit' do
		let!(:advert) { FactoryGirl.create :advert }
	  before do
	  	sign_in advert.user
	  	visit edit_advert_path advert
	  end

	  it { should have_title 'Edit Advert' }

	  describe 'update parameters' do
	  	before do
	  		visit edit_advert_path advert
	    	fill_in 'Description', with: Faker::Lorem.sentence(100)
	    	click_button 'Edit Advert'
	    end
		  it { should have_content 'Advert update success!' }
	  end
	end
end