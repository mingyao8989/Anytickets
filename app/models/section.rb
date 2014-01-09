# == Schema Information
#
# Table name: sections
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Section < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true
  attr_accessible :name, :content, :as => [:default, :admin]
end
