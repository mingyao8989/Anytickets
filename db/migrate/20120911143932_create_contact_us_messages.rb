class CreateContactUsMessages < ActiveRecord::Migration
  def change
    create_table :contact_us_messages do |t|
      t.string :name
      t.string :email
      t.text :content

      t.timestamps
    end
  end
end
