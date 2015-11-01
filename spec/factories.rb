FactoryGirl.define do
	factory :user do
		sequence(:login) {|n| "person_login_#{n}" }
		sequence(:full_name) {|n| "Person #{n}" }
		birthday "31 08 1994"
		sequence(:email) {|n| "person_#{n}@example.com" }
		address "street"
		city "NY"
		state "NY"
		country "USA"
		zip 12345
		password "foobar"
		password_confirmation "foobar"
	end

	factory :advert do
		sequence(:name) {|n| "Advert_#{n}"}
		description Faker::Lorem.sentence(100)
		image "/image.jpg"
		association :user
	end
end