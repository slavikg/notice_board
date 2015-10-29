require 'spec_helper'

describe 'Page Adverts' do

	subject {page}

	describe 'Index' do
		before {visit adverts_path}
		it { should have_title 'Adverts' }
	end

	describe 'Show' do
		let(:advert) { FactoryGirl.create :advert }
		let(:user) { advert.user }
		before do
			visit advert_path(advert)
		end
		it { should have_title advert.name }
		it { should have_css 'img[alt="image"]' }
		it { should have_content advert.name }
		it { should have_content advert.description }

		describe 'without photo' do
			before do
				advert.update_attributes(image: "")
				advert.save!
				visit advert_path(advert)
			end
			it { should have_css 'img[alt="no image"]' }
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
	  end
	end
end