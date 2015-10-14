namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do
		User.create!(login: "slavikg", full_name: "Slavik G",
    		birthday: "20 02 1994", email: "example@gmail.com", address: "Wall Street",
    		city: "NY", state: "NY", country: "USA", zip: 12345,
    		password: "foobar", password_confirmation: "foobar")
		4.times do |n|
			User.create!(login: "persone_#{n}", full_name: "Person #{n}",
    		birthday: "20 02 1994", email: "person#{n}@gmail.com", address: "Medison",
    		city: "NY", state: "NY", country: "USA", zip: 12345,
    		password: "foobar", password_confirmation: "foobar")
		end
	end
end																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																				