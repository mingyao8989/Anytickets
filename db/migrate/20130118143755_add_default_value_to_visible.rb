class AddDefaultValueToVisible < ActiveRecord::Migration
  def up
    change_column :categories, :visible, :boolean, default: true

    Category.where(visible: nil).find_each do |cat|
        cat.visible = true
        cat.save
    end
  end

  def down
    change_column :categories, :visible, :boolean, default: true
  end
end
