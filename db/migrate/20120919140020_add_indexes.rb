class AddIndexes < ActiveRecord::Migration
  def up
  	add_index :performers, :slug, unique:true
  	add_index :venues, :slug, unique:true
  	add_index :categories, :slug, unique:true
  end

  def down
 	remove_index :performers, :slug
  	remove_index :venues, :slug
  	remove_index :categories, :slug
  end
end
