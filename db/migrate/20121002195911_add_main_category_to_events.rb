class AddMainCategoryToEvents < ActiveRecord::Migration
  def change
    add_column :events, :main_category, :string
  end
end
