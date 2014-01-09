class AddIndexToEvents < ActiveRecord::Migration
  def up
  	#add_index :events,:slug, unique:true
  end

  def down
  	#remove_index :events,:slug
  end
end
