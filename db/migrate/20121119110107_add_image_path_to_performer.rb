class AddImagePathToPerformer < ActiveRecord::Migration
  def change
    add_column :performers, :image_path, :string
  end
end
