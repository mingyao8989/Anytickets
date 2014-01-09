class AddCityToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :city, :boolean
  end
end
