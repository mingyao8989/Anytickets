class AddSlugToPerformers < ActiveRecord::Migration
  def change
    add_column :performers, :slug, :string
  end
end
