class CreateAdverts < ActiveRecord::Migration
  def change
    create_table :adverts do |t|
      t.string :name
      t.text :description
      t.string :image
      t.integer :user_id

      t.timestamps
    end
  end
end
