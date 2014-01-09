class ChangeColumnNameOnImportCsv < ActiveRecord::Migration
  def up
  	rename_column :import_csvs, :type, :import_type
  end

  def down
  	rename_column :import_csvs, :import_type, :type
  end
end
