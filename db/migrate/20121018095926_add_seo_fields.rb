class AddSeoFields < ActiveRecord::Migration
  def change
  	
      add_column :events, :meta_title, :string
      add_column :events, :meta_description, :text
      add_column :events, :h1, :string
    
      add_column :performers, :meta_title, :string
      add_column :performers, :meta_description, :text
      add_column :performers, :h1, :string
    
      add_column :categories, :meta_title, :string
      add_column :categories, :meta_description, :text
      add_column :categories, :h1, :string

  end
end
