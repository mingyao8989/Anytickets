# == Schema Information
#
# Table name: categories
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  ancestry       :string(255)
#  tnid           :integer
#  ancestry_depth :integer          default(0)
#  slug           :string(255)
#

class Category < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged
  include SeoAble


  attr_accessible :slug, :name, :parent_id, :collection_ids, :event_ids, :performer_ids, :meta_title,
    :meta_description, :h1, :description, :visible, :active, :image_path, :owned_collections_ids, :as => [:default, :admin]
  has_many :listings, :as => :collectible
  has_many :collections, :through => :listings
  has_many :owned_collections, class_name: 'Collection', foreign_key: 'category_id'

  has_many :performers
  has_many :events
  has_ancestry :cache_depth => true

  validates :name, :presence => true

  liquid_methods :name

  scope :visible, where(visible: true)
  scope :active, where(active: true)
  scope :feaured, where(feaured: true)
  scope :popular, order("clicks")


  def image_url
    if self.image_path and ! self.image_path.empty?
      self.image_path
    else
      "no-image.png"
    end
  end

  def grandparent
    if self.parent
      self.parent.parent
    else
      nil
    end
  end

  # ==== Unused ====
  # def all_performers
  #   Performer.active.where(category_id: self.subtree_ids)
  # end

  # ==== Unused ====
  # def all_events
  #   Event.future.active.where(category_id: self.subtree_ids)
  # end

  # ==== Unused =====
  # def all_events_alphabetical_hash
  #   Event.alphabetical_hash(self.all_events)
  # end

  def get_featured(array)
    featured = nil
    featured_array = array.find_all {|item| item.featured}
    if featured_array.empty?
      (array.sort_by {|item| item.clicks}).last
    else
      featured_array.sample
    end
  end

  def should_generate_new_friendly_id?
    new_record?
  end

  # Collects all visible children of this category and visible children of all non-visible children of this category.
  def visible_children
    arr = []
    self.children.each do |child|
      if child.visible && child.active
        arr << child
      else
        arr = arr + child.visible_children if child.active
      end
    end
    arr
  end

  # Collectes the performers of this category (if it is visible) and each visible child.
  def visible_performers
    arr = self.performers.select {|performer| performer.active}
    if self.visible
      self.children.each {|child|   arr = arr + child.visible_performers if !child.visible && child.active}
    else
      self.children.each {|child| arr = arr + child.visible_performers if child.active}
    end
    arr
  end

  def self.flatten
    self.all.each do |category|
      if category.name == "-"
        parent = category.parent
        category.performers.each do |performer|
          performer.category = parent
          performer.save
        end
        category.events.each do |event|
          event.category = parent
          event.save
        end
        category.destroy
      end
    end
  end

end
