class StaticPage < ActiveRecord::Base
  attr_accessible :active, :permalink, :name, :content, :title, :meta_description,:include_left_sidebar,:include_right_sidebar, :as => [:default, :admin]

  validates_presence_of :name, :content, :title, :permalink
  validates_uniqueness_of :permalink

  scope :active, where("active = ?", true)

end

# == Schema Information
#
# Table name: pages
#
#  id         :integer         not null, primary key
#  active     :boolean         default(TRUE)
#  permalink  :string(255)
#  name       :string(255)
#  content    :text
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#
