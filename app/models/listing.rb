# == Schema Information
#
# Table name: listings
#
#  id               :integer          not null, primary key
#  collection_id    :integer
#  collectible_id   :integer
#  collectible_type :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Listing < ActiveRecord::Base
  attr_accessible :collectible_id, :collectible_type, :collection_id, :as => [:default, :admin]
  belongs_to :collection
  belongs_to :collectible, :polymorphic=>true
end
