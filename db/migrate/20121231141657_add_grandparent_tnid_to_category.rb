class AddGrandparentTnidToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :grandparent_tnid, :integer
  end
end
