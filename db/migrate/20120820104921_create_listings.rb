class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.integer :collection_id
      t.integer :collectible_id
      t.string :collectible_type

      t.timestamps
    end
  end
end
