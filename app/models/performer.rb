# == Schema Information
#
# Table name: performers
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  tnid          :integer
#  category_id   :integer
#  slug          :string(255)
#  basic_info    :text
#  general_info  :text
#  extended_info :text
#
require "event_performer_shared_methods"

class Performer < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_name, use: :slugged
  include SeoAble
  include EventPerformerSharedMethods
  
  attr_accessible :slug,:name, :active, :basic_info, :general_info, :extended_info, :category_id,
    :collection_ids, :event_ids, :meta_title, :meta_description, :h1, :image_path, :priority,
    :as => [:default, :admin]
  validates_presence_of :name

  has_many :listings,:as => :collectible
  has_many :collections,:through => :listings
  has_and_belongs_to_many :events
  
  belongs_to :category
  liquid_methods :name

  scope :active, where(active: true)
  scope :prioritized, order('priority DESC') 
    
  def slug_name
    "#{name} tickets"
  end

  def image_url
    (self.image_path.nil? || self.image_path == "") ? "no-image.png" : self.image_path
  end


  def should_generate_new_friendly_id?
    new_record?
  end

  comma do 
    slug
    name
    active
    basic_info
    general_info
    extended_info
    meta_title
    meta_description
    h1
    image_path
  end

  # Set default values to h1, meta_title and meta_description
  # def default_performer_values
  #   default_meta_values self
  # end

  def self.create_csv(filename)
    Performer.all.to_comma(:filename => filename)
  end

end
