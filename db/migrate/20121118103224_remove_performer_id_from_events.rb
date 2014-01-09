class RemovePerformerIdFromEvents < ActiveRecord::Migration
  def up
  	remove_column "events","performer_id"
  end

  def down
  	add_column "events","performer_id", :integer
  end
end
