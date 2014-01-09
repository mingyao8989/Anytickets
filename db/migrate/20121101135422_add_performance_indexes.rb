class AddPerformanceIndexes < ActiveRecord::Migration
  def up
    add_index :events, :clicks
    add_index :events, :name
    add_index :events, :date
    add_index :venues, :name
    add_index :performers, :name
 end

  def down
    remove_index :events, :clicks
    remove_index :events, :name
    remove_index :events, :date
    remove_index :venues, :name
    remove_index :performers, :name
  end
end
