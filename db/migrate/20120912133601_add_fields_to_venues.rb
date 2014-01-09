class AddFieldsToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :city, :string
    add_column :venues, :country, :string
    add_column :venues, :state_province, :string
    add_column :venues, :zipcode, :string
    add_column :venues, :street1, :string
    add_column :venues, :street2, :string
  end
end
