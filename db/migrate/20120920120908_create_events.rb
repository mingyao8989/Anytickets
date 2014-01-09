class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :category_id
      t.string :city
      t.integer :clicks
      t.datetime :date
      t.integer :tnid
      t.boolean :is_womens
      t.string :img_static_url
      t.string :img_interactive_url
      t.string :name
      t.string :state_province
      t.integer :venue_id
      t.integer :venue_configuration
      t.integer :country_tnid
      t.string :slug
      
      
      t.timestamps
    end
  end
end
