class AddCategoryIdToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :category_id, :integer
  end
end
