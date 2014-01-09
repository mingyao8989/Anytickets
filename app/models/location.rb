class Location < ActiveRecord::Base
  attr_accessible :name, :city, :slug, :listing_ids, :collection_ids, :venue_ids, :listed_in_dropdown, :display_name, :as => [:default, :admin]
  has_many :listings,:as => :collectible
  has_many :collections,:through => :listings
  has_many :events
  has_many :venues
  before_save :default_display_name

  extend FriendlyId
  friendly_id :name, use: :slugged

  def default_display_name
    display_name ||= name
  end


  def should_generate_new_friendly_id?
    new_record?
  end


  def self.cities_list
    self.where(city: true, listed_in_dropdown: true).order(:name).pluck(:display_name)
  end


end
