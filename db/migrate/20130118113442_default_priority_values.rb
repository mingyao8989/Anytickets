class DefaultPriorityValues < ActiveRecord::Migration
  def up
    change_column :events, :priority, :integer, :default => 0
    change_column :performers, :priority, :integer, :default => 0
  
    [Event, Performer].each do |model|
      model.where(priority: nil).find_each do |item|
        item.priority ||= 0
        item.save
      end
    end
  end

  def down
    change_column :events, :priority, :integer, :default => nil
    change_column :performers, :priority, :integer, :default => nil
  end
end
