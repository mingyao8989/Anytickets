# == Schema Information
#
# Table name: testimonials
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  address    :string(255)
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Testimonial < ActiveRecord::Base
  attr_accessible :address, :content, :name, :active, :as => [:default, :admin]


  liquid_methods :name, :address, :content

end
