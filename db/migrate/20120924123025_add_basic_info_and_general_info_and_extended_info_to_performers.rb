class AddBasicInfoAndGeneralInfoAndExtendedInfoToPerformers < ActiveRecord::Migration
  def change
    add_column :performers, :basic_info, :text
    add_column :performers, :general_info, :text
    add_column :performers, :extended_info, :text
  end
end
