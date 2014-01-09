class AddActiveToTestimonials < ActiveRecord::Migration
  def change
    add_column :testimonials, :active, :boolean
  end
end
