# == Schema Information
#
# Table name: events
#
#  id                  :integer          not null, primary key
#  category_id         :integer
#  clicks              :integer
#  date                :datetime
#  tnid                :integer
#  is_womens           :boolean
#  img_static_url      :string(255)
#  img_interactive_url :string(255)
#  name                :string(255)
#  state_province      :string(255)
#  venue_id            :integer
#  venue_configuration :integer
#  country_tnid        :integer
#  slug                :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  performer_id        :integer
#  featured            :boolean
#  description         :text
#  main_category       :string(255)
#
require "event_performer_shared_methods"

class Event < ActiveRecord::Base
  extend FriendlyId
  include SeoAble
  include EventPerformerSharedMethods
  friendly_id :slug_name, use: :slugged


  attr_accessible :slug,:category_id, :location_id, :clicks, :country_tnid, :date, :img_interactive_url,
    :img_static_url, :is_womens, :name, :state_province, :venue_configuration, :venue_id, :performer_ids,
    :description, :collection_ids, :event_ids, :meta_title, :meta_description, :h1, :id, :featured, :listing_ids,
    :image_path, :active, :priority, :as => [:default, :admin]
  validates :date, presence:true
  validates :name, presence:true
  validates :tnid, presence:true


  belongs_to :category
  belongs_to :venue
  belongs_to :location
  has_and_belongs_to_many :performers

  has_many :listings,:as => :collectible
  has_many :collections,:through => :listings

  scope :popular, order(:featured, 'priority DESC, clicks DESC')
  scope :date, lambda {|d| where('date > ?', Date.parse(d).to_time).where('date < ?', (Date.parse(d) + 1).to_time)} #TODO needs to be named for_date
  scope :future, lambda { where("date >= ?", Time.zone.now) }
  scope :active, lambda { where(active: true) }

  comma do
    id
    clicks
    date
    tnid
    is_womens
    img_static_url
    img_interactive_url
    name
    state_province
    venue_configuration
    country_tnid
    slug
    created_at
    updated_at
    featured
    description
    image_path
    main_category
    meta_title
    meta_description
    h1
  end

  # returns this event's image path if it exists,
  # or one of the performers' images if they have any
  # or else the default image
  def image_url
    if self.image_path.nil? || self.image_path == ""
      performers_with_images = self.performers.select do |performer|
        performer.active && performer.image_path != nil && performer.image_path != ""
      end
      if performers_with_images.empty?
        "no-image.png"
      else
        performers_with_images.first.image_path
      end
    else
      self.image_path
    end
  end

  # day no. - short month name - hour
  def shorter_date
    self.date.strftime "%-d %b, %Y"
  end

  def short_date
    self.date.strftime "%-d %b, %l:%M %p"
  end

  def medium_date
    self.date.strftime "%a, %-d %b, %l:%M %p"
  end

  def long_date
    self.date.strftime "%a, %-d %b, %l:%M %p, %Y"
  end

  def url_date
    self.date.strftime "%Y-%m-%d--%H:%M"
  end

  def slug_name
    "#{name} #{date.to_date.to_s if date}"
  end

  # return a hash with the alphabet as keys and events sorted by first letter
  def self.alphabetical_hash(events)
    hash = Hash.new([])
    events.each do |event|
      if event.name[0].match(/\A[0-9]+\Z/)
        hash['numbers'] = hash['numbers'] + [event]
      else
        hash[event.name[0].downcase] = hash[event.name[0].downcase] + [event]
      end
    end
    hash
  end

  def self.create_csv(filename)
    Event.all.to_comma(:filename => filename)
  end

  def should_generate_new_friendly_id?
    new_record?
  end

  # def default_event_values
  #   default_meta_values self
  # end

end
