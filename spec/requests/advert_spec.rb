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
		describe 'without photo' do
			before do
				advert.update_attributes(image: "")
				advert.save!
				visit advert_path(advert)
			end
			it { should have_css 'img[alt="no image"]' }
		end
	end
end