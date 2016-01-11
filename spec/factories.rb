FactoryGirl.define do
	factory :user do
		sequence(:login) {|n| "login_#{n}" }
		sequence(:full_name) {|n| "Person #{n}" }
		birthday "31 08 1994"
		sequence(:email) {|n| "person_#{n}@example.com" }
		address "street"
		city "NY"
		state "NY"
		country "USA"
		zip 12345
		role 'user'
		password "foobar"
		password_confirmation "foobar"
	end

	factory :advert do
		sequence(:name) {|n| "Advert_#{n}"}
		description Faker::Lorem.sentence(100)
		image ""
		tags "tag"
		association :user
	end

	factory :comment do
		comment Faker::Lorem.sentence(30)
		association :user
		association :advert
	end
end