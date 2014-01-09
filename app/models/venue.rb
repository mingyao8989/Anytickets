# == Schema Information
#
# Table name: venues
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  tnid           :integer
#  country        :string(255)
#  state_province :string(255)
#  zipcode        :string(255)
#  street1        :string(255)
#  street2        :string(255)
#  slug           :string(255)
#  basic_info     :text
#  general_info   :text
#  extended_info  :text
#

class Venue < ActiveRecord::Base
  extend FriendlyId
  include SeoAble
  friendly_id :name, use: :slugged

  attr_accessible :name, :basic_info, :general_info, :extended_info, :slug, :location_id,
    :country, :state_province, :zipcode, :street1, :street2, :collection_ids, :listing_ids,
    :event_ids, :meta_title, :meta_description, :h1, :as => [:default, :admin]
  has_many :listings, :as => :collectible
  has_many :collections, :through => :listings
  has_many :events
  belongs_to :location

  liquid_methods :name

  comma do
    id
    name
    tnid
    location_id
    country
    state_province
    zipcode
    street1
    street2
    slug
    basic_info
    general_info
    extended_info
    meta_title
    meta_description
    h1
    created_at
    updated_at
  end

  def should_generate_new_friendly_id?
    new_record?
  end

  def self.create_csv(filename)
    Venue.all.to_comma(:filename => filename)
  end

  def image_url
    "no-image.png"
  end

end
