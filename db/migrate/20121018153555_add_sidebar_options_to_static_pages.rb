class AddSidebarOptionsToStaticPages < ActiveRecord::Migration
  def change
    add_column :static_pages, :include_left_sidebar, :boolean, :default => true
    add_column :static_pages, :include_right_sidebar, :boolean, :default => true
  end
end
