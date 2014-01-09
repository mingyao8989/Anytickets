class AddPriorityToPerformers < ActiveRecord::Migration
  def up
    add_column :performers, :priority, :integer
    Performer.find_each do |performer|
      performer.priority = 0
      performer.save
    end
  end

  def down 
    remove_column :performers, :priority
  end
end
