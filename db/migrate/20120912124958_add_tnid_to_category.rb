class AddTnidToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :tnid, :integer
    add_column :performers, :tnid, :integer
    add_column :venues, :tnid, :integer
  end
end
