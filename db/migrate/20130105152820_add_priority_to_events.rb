class AddPriorityToEvents < ActiveRecord::Migration
  def up
    add_column :events, :priority, :integer
    Event.find_each do |event|
      event.priority = 0
      event.save
    end
  end

  def down
    remove_column :events, :priority
  end
end
