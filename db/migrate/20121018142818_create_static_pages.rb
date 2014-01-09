class CreateStaticPages < ActiveRecord::Migration
  def up
    create_table :static_pages do |t|
      t.boolean :active, :default => true
      t.string :permalink
      t.string :name
      t.text :content
      t.string :title
      t.text :meta_description
      t.timestamps
    end
  end

  def self.down
    drop_table :static_pages
  end

end

