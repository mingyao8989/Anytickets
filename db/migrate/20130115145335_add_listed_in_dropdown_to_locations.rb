class AddListedInDropdownToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :listed_in_dropdown, :boolean, default: false
  end
end
