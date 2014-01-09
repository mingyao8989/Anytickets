class AddParentTnidToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :parent_tnid, :integer
  end
end
