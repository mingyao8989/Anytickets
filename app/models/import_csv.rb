class ImportCsv < ActiveRecord::Base
  attr_accessible :import_type, :csv, :as => [:default, :admin]
  has_attached_file :csv
  #validates :import_type, inclusion: {in: %w(events performers venues categories)}
  validates_presence_of :import_type
  validates_attachment_presence :csv
  validates_attachment_content_type :csv, content_type: "text/csv"
  after_save :process_csv

  def array_with_header_row_to_hash array
      array[1..array.length].map do |entry|
        raise "When calling array_with_header_row_to_hash, the array elements should be Arrays" unless entry.is_a?(Array)
        hash = {}
        entry.each_with_index do |element,i|
          hash[array.first[i]] = element
        end
        hash
      end
  end

  def string_to_bool string
  	string == "true"
  end

  def process_csv
  	self.output = ""
  	case self.import_type
  	when "events"
  		process_events
  	when "performers"
  		process_performers
  	when "categories"
  		process_categories
  	when "venues"
  		process_venues
  	when "listings"
  		process_listings
  	when "testimonials"
  		process_testimonials
  	end
  	update_column :output, self.output
  end

  def get_csv
  	require 'csv'
  	csv_file = self.csv.path
  	array_with_header_row_to_hash(CSV.open(csv_file).entries)
  end

  def process_events
    #TODO this can be made more readable
  	get_csv.each do |entry|
  		begin
  			if entry['Id'].nil?
  				self.output = self.output + "There is no Id column.\n"
  				break
  			end
  			#update event fields
  			if entry['Id'] == ""
  				event = Event.new
  			else
  				event = Event.find(entry["Id"].to_i)
  			end

				event.clicks = entry["Clicks"].to_i                       unless entry["Clicks"].nil?
				event.date = entry["Date"]                                unless entry["Date"].nil?
				event.tnid = entry["Tnid"]                                unless entry["Tnid"].nil?
				event.is_womens = string_to_bool entry["Is womens"]       unless entry["Is womens"].nil?
				event.img_static_url = entry["Img static url"]            unless entry["Img static url"].nil?
				event.img_interactive_url = entry["Img interactive url"]  unless entry["Img interactive url"].nil?
				event.name = entry["Name"]                                unless entry["Name"].nil?
				event.state_province = entry["State province"]            unless entry["State province"].nil?
				event.venue_configuration = entry["Venue configuratiom"]  unless entry["Venue configuratiom"].nil?
				event.country_tnid = entry["Country tnid"].to_i           unless entry["Country tnid"].nil?
				event.slug = entry["Slug"]                                unless entry["Slug"].nil?
				event.featured = string_to_bool entry["Featured"]         unless entry["Featured"].nil?
				event.description = entry["Description"]                  unless entry["Description"].nil?
				event.meta_title = entry["Meta title"]                    unless entry["Meta title"].nil?
				event.meta_description = entry["Meta description"]        unless entry["Meta description"].nil?
				event.h1 = entry["H1"]                                    unless entry["H1"].nil?
        event.image_path = entry["Image path"]                    unless entry["Image path"].nil?
        event.active = entry["Active"]                            unless entry["Active"].nil? 
  			#update event's category

  			unless entry["Id [Category]"].nil?
  				unless entry["Id [Category]"] == ""
  					event.category = Category.find entry["Id [Category]"].to_i
  				end
  				event.main_category = event.category.name
  				if event.category.parent
  					event.main_category = event.category.parent.name
  					if event.category.parent.parent
  						event.main_category = event.category.parent.parent.name
  					end
  				end
  			end

  			unless entry["Slug [Category]"].nil?
  				unless entry["Slug [Category]"] == ""
  					event.category = Category.find_by_slug entry["Slug [Category]"]
  				end
  				event.main_category = event.category.name
  				if event.category.parent
  					event.main_category = event.category.parent.name
  					if event.category.parent.parent
  						event.main_category = event.category.parent.parent.name
  					end
  				end
  			end

  			#update venue fields

  			unless entry["Id [Venue]"].nil?
  				unless entry["Id [Venue]"] == ""
  					event.venue = Venue.find entry["Id [Venue]"].to_i
  				end
  			end

  			unless entry["Slug [Venue]"].nil?
  				unless entry["Slug [Venue]"] == ""
  					event.venue = Venue.find_by_slug entry["Slug [Venue]"]
  				end
  			end

  			#update performer fields

  			

  			#edit associated collections
  			update_collections entry, event

  			#finished updating fields
  			event.save
  		rescue Exception => e
  			self.output = "#{self.output}#{e.message}\n#{e.backtrace}\n\n"
  		end
  	end
  end

  def process_performers
  	get_csv.each do |entry|
  		begin
  			if entry['Id'].nil?
  				self.output = self.output + "There is no Id column.\n"
  				break
  			end

  			performer = if entry["Id"] == ""
  				Performer.new
  			else
  				Performer.find entry["Id"].to_i
  			end

  			#performer fields
  			performer.name = entry["Name"]                         unless entry["Name"].nil?
  			performer.tnid = entry["Tnid"]                         unless entry["Tnid"].nil?
  			performer.slug = entry["Slug"]                         unless entry["Slug"].nil?
  			performer.basic_info = entry["Basic info"]             unless entry["Basic info"].nil?
  			performer.general_info = entry["General info"]         unless entry["General info"].nil?
  			performer.extended_info = entry["Extended info"]       unless entry["Extended info"].nil?
  			performer.meta_title = entry["Meta title"]             unless entry["Metat title"].nil?
  			performer.meta_description = entry["Meta description"] unless entry["Meta description"].nil?
  			performer.h1 = entry["H1"]                             unless entry["H1"].nil?
        performer.image_path = entry["Image path"]                     unless entry["Image path"].nil?


  			#category fields
  			performer.category = Category.find entry["Id [Category]"].to_i      unless entry["Id [Category]"].nil?
  			performer.category = Category.find_by_slug entry["Slug [Category]"] unless entry["Slug [Category]"].nil?

  			#collection fields
  			update_collections entry, performer
  			performer.save


  		rescue Exception => e
  			self.output = "#{self.output}#{e.message}\n#{e.backtrace}\n\n"
  		end
  	end
  end

  def process_venues
  	get_csv.each do |entry|
  		begin
  			if entry['Id'].nil?
  				self.output = self.output + "There is no Id column.\n"
  				break
  			end

  			venue = if entry["Id"] == ""
  				Venue.new
  			else
  				Venue.find entry["Id"].to_i
  			end

  			#performer fields
  			venue.name = entry["Name"]                         unless entry["Name"].nil?
  			venue.tnid = entry["Tnid"]                         unless entry["Tnid"].nil?
  			venue.slug = entry["Slug"]                         unless entry["Slug"].nil?
  			venue.basic_info = entry["Basic info"]             unless entry["Basic info"].nil?
  			venue.general_info = entry["General info"]         unless entry["General info"].nil?
  			venue.extended_info = entry["Extended info"]       unless entry["Extended info"].nil?
  			venue.meta_title = entry["Meta title"]             unless entry["Metat title"].nil?
  			venue.meta_description = entry["Meta description"] unless entry["Meta description"].nil?
  			venue.h1 = entry["H1"]                             unless entry["H1"].nil?
  			venue.country = entry["Country"]                   unless entry["Country"].nil?
  			venue.state_province = entry["State province"]     unless entry["State province"].nil?
  			venue.zipcode = entry["Zipcode"]                   unless entry["Zipcode"].nil?
  			venue.street1 = entry["Street1"]                   unless entry["Street1"].nil?
  			venue.street2 = entry["Street2"]                   unless entry["Street2"].nil?

  			update_collections entry, venue
  			venue.save
  		rescue Exception => e
  			self.output = "#{self.output}#{e.message}\n#{e.backtrace}\n\n"
  		end
  	end
  end

  def process_categories
  	get_csv.each do |entry|
  		begin
  			if entry['Id'].nil?
  				self.output = self.output + "There is no Id column.\n"
  				break
  			end

  			category = if entry["Id"] == ""
  				Category.new
  			else
  				Category.find entry["Id"].to_i
  			end

  			#performer fields
  			category.name = entry["Name"] unless entry["Name"].nil?
  			category.tnid = entry["Tnid"] unless entry["Tnid"].nil?
  			category.slug = entry["Slug"] unless entry["Slug"].nil?
  			category.meta_title = entry["Meta title"] unless entry["Meta title"].nil?
        category.meta_description = entry["Meta description"] unless entry["Meta description"].nil?
        category.h1 = entry["H1"] unless entry["H1"].nil?
        category.description = entry["Description"] unless entry["Description"].nil?
        category.image_path = entry["Image path"] unless entry["Image path"].nil?
        category.visible = string_to_bool entry["Visible"] unless entry["Visible"].nil?


        #messing with ancestry is disabled for now.
  			#category.parent = entry["Parent"] unless entry["Parent"].nil?

  			update_collections entry, category
  			category.save
  		rescue Exception => e
  			self.output = "#{self.output}#{e.message}\n#{e.backtrace}\n\n"
  		end
  	end
  end

  def process_listings
  	get_csv.each do |entry|
  		begin
  			if entry['Id'].nil?
  				self.output = self.output + "There is no Id column.\n"
  				break
  			end

  			if entry["Id"] == ""
  			 listing = 	Listing.new
  			else
  				listing = Listing.find entry["Id"].to_i
  			end

  			if listing.nil?
  				self.output = self.output + "Listing #{entry["Id"]} not found.\n"
  				break
  			end

  			#performer fields
  			collectible = eval(entry["Collectible type"]).find entry["Collectible"]
  			collection = Collection.find_by_name entry["Name [Collection]"]
  			unless collection
  				collection = Collection.new
  				collection.name = entry["Name [Collection]"]
  				collection.save
  			end
  			listing.collectible = collectible
  			listing.collection = collection
  			listing.save
  		rescue Exception => e
  			self.output = "#{self.output}#{e.message}\n#{e.backtrace}\n\n"
  		end
  	end
  end

  def process_testimonials
  	get_csv.each do |entry|
  		begin
  			if entry['Id'].nil?
  				self.output = self.output + "There is no Id column.\n"
  				break
  			end

  			testimonial = if entry["Id"] == ""
  				Testimonial.new
  			else
  				Testimonial.find entry["Id"].to_i
  			end

  			if testimonial.nil?
  				self.output = self.output + "Testimonial #{entry["Id"]} not found.\n"
  				break
  			end

  			testimonial.name = entry["Name"]       unless entry["Name"].nil?
  			testimonial.address = entry["Address"] unless entry["Address"].nil?
  			testimonial.content = entry["Content"] unless entry["Content"].nil?

  			update_collections entry, testimonial

  		rescue Exception => e
  			self.output = "#{self.output}#{e.message}\n#{e.backtrace}\n\n"
  		end
  	end
  end

  def update_collections entry, collectible
  	collectible.save
  	if entry["Name [Collection"] && entry["Name [Collection"] != nil
  		names = entry["Name [Collection"].split ","
  		names.each do |name|
  			collection = Collection.find_by_name name
  			collection = Collection.new unless collection
  			if Listing.where(:collection_id => collection.id, :collectible_id => collectible.id, :collectible_type => collectible.class.to_s).all.empty?
  				listing = Listing.new
  				listing.collection = collection
  				listing.collectible = collectible
  				listing.save
  			end
  		end
  	end
  end

  def update_collections entry, collectible
  	collectible.save

  	if entry["Name [Collections]"] && entry["Name [Collections]"] != ""
  		names = entry["Name [Collections]"].split ","
  		names.each do |name|
  			collection = Collection.find_by_name name
  			unless collection
  				collection = Collection.new
  				collection.name = name
  				collection.save
  			end

  			if Listing.where(:collection_id => collection.id, :collectible_id => collectible.id, :collectible_type => collectible.class.to_s).all.empty?
  				listing = Listing.new
  				listing.collection = collection
  				listing.collectible = collectible
  				listing.save
  			end
  		end
  	end
  end
end
