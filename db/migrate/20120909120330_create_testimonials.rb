class CreateTestimonials < ActiveRecord::Migration
  def change
    create_table :testimonials do |t|
      t.string :name
      t.string :address
      t.text :content

      t.timestamps
    end
  end
end
