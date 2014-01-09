class AddActiveToPerformers < ActiveRecord::Migration
  def change
    add_column :performers, :active, :boolean, default: true
  end
end
