class AddSeoToVenues < ActiveRecord::Migration
  def change
      add_column :venues, :meta_title, :string
      add_column :venues, :meta_description, :text
      add_column :venues, :h1, :string
  end
end
