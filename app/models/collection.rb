# == Schema Information
#
# Table name: collections
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Collection < ActiveRecord::Base

  attr_accessible :name, :listing_ids, :testimonial_ids, :category_ids, :venue_ids, :performer_ids, :event_ids,
    :location_ids, :category_id, :slug,:as => [:default, :admin]
  has_many :listings
  has_many :performers, :through => :listings, :source => :collectible, :source_type => 'Performer'
  has_many :venues, :through => :listings, :source => :collectible, :source_type => 'Venue'
  has_many :categories, :through => :listings, :source => :collectible, :source_type => 'Category'
  has_many :events, :through => :listings, :source => :collectible, :source_type => 'Event'
  has_many :locations, :through => :listings, :source => :collectible, :source_type => 'Location'
  belongs_to :category
  # has_many :collections, :through => :listings, :source => :collectible, :source_type => 'Collection'
  # has_many :listings,:as => :collectible
  # has_many :collections,:through => :listings

  validates :name, uniqueness: true

  extend FriendlyId
  friendly_id :name, use: :slugged

  liquid_methods :name, :performers, :venues, :categories, :items, :testimonials

  def items
  	filtered = (self.categories + self.performers + self.events).select {|item| item.active}
    filtered + self.locations + self.venues
  end

  def should_generate_new_friendly_id?
    new_record?
  end
  # def get_collections
  #   Collection.joins("INNER JOIN listings ON listings.collectible_id = collections.id")
  #     .where("listings.collection_id" => self.id, "listings.collectible_type"=>"Collection").all
  # end

  # def get_listings
  #   Listing.where(collection_id: self.id).all
  # end
end
