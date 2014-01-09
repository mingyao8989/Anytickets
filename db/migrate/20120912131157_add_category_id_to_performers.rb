class AddCategoryIdToPerformers < ActiveRecord::Migration
  def change
    add_column :performers, :category_id, :integer
  end
end
