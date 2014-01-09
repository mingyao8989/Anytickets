class AddBasicInfoAndGeneralInfoAndExtendedInfoToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :basic_info, :text
    add_column :venues, :general_info, :text
    add_column :venues, :extended_info, :text
  end
end
