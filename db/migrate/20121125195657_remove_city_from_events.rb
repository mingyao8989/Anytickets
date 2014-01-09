class RemoveCityFromEvents < ActiveRecord::Migration
  def up
    remove_column :events, :city
  end

  def down
    add_column :events, :city, :integer
  end
end
