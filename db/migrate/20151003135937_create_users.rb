class CreateUsers < ActiveRecord::Migration
	def change
		create_table :users do |t|
			t.string :login
			t.string :full_name
			t.string :birthday
			t.string :email
			t.string :address
			t.string :city
			t.string :state
			t.string :country
			t.integer :zip
			t.string :remember_token
			t.string :password_digest
			t.timestamps
		end
		add_index :users, :login, unique: true
		add_index :users, :remember_token
	end
end
