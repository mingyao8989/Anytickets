class EventPerformerJoin < ActiveRecord::Migration
  def up
  	create_table 'events_performers', id: false do |t|
  		t.column 'event_id', :integer
  		t.column 'performer_id', :integer
  	end
  end

  def down
  	drop_table "events_performers"
  end
end
