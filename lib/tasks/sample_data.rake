namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do
		User.create!(login: "slavikg", full_name: "Slavik G",
    		birthday: "20 02 1994", email: "example@gmail.com", address: "Wall Street",
    		city: "NY", state: "NY", country: "USA", zip: 12345,
    		password: "foobar", password_confirmation: "foobar")
		30.times do |n|
			User.create!(login: "persone_#{n}", full_name: Faker::Name.name,
    		birthday: "20 02 1994", email: "person#{n}@gmail.com", address: "Medison",
    		city: "NY", state: "NY", country: "USA", zip: 12345,
    		password: "foobar", password_confirmation: "foobar")
		end
		user1 = User.first
		user2 = User.find 2
		i = 1
		25.times do |n|
			advert = user1.adverts.build(name: "Advert_#{i}",
				description: Faker::Lorem.sentence(100), image: '')
			advert.save
			advert = user2.adverts.build(name: "Advert_#{i + 1}",
				description: Faker::Lorem.sentence(100), image: '')
			advert.save
			i += 2
		end
		advert = Advert.first
		10.times do |n|
			comment = advert.comments.build(comment: "#{n+1} comment")
			comment.user = User.find(n + 1)
			comment.save
		end
	end
end																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																				