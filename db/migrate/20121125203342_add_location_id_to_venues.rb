class AddLocationIdToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :location_id, :integer
  end
end
