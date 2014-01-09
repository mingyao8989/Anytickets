class AddDisplayNameToLocations < ActiveRecord::Migration
  def up
    add_column :locations, :display_name, :string
    Location.find_each do |location|
      event = location.events.first
      if event
        location.display_name = "#{event.state_province.strip}-#{location.name.strip}"
      else
        location.display_name = location.name
      end
      location.save!
    end
  end

  def down
    remove_column :locations, :display_name
  end
end
