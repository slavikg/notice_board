class AddTagsToAdverts < ActiveRecord::Migration
  def change
  	add_column :adverts, :tags, :text
  end
end
