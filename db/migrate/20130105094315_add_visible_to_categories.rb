class AddVisibleToCategories < ActiveRecord::Migration
  def up
    add_column :categories, :visible, :boolean
    Category.find_each do |category|
      category.visible = true
      category.save!
    end
  end

  def down
    remove_column :categories, :visible
    
  end
  
end
