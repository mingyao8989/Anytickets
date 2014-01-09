class CreateImportCsvs < ActiveRecord::Migration
  def change
    create_table :import_csvs do |t|
      t.text :output
      t.string :type
      t.attachment :csv

      t.timestamps
    end
  end
end
