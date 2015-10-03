FactoryGirl.define do
	factory :user do
		login "slavikg"
		full_name "Slavik G"
		birthday "31 08 1994"
		email "example@gmail.com"
		address "street"
		city "NY"
		state "NY"
		country "USA"
		zip 12345
		password "foobar"
		password_confirmation "foobar"
	end
end