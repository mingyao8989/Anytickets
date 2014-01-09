# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


#create some collectibles
Collection.destroy_all
Testimonial.destroy_all

Testimonial.create(name: 'Matthew', address: 'Brooklyn,New York, USA', content: 'Thank you very much!', active: true)
Testimonial.create(name: 'Tsah Weiss', address: 'Meitar, Israel', content: 'Great site! found some cool tickets...', active: true)

Collection.create(name: 'collection1')
Collection.create(name: 'collection2')
Collection.create(name: 'Featured Performers')

#create a collection
Performer.first(8).each do |p|
  Listing.new do |l|
    l.collection = Collection.find_by_name('Featured Performers')
    l.collectible = p
    l.save!
  end
end

Performer.first(10).each do |p|
	Listing.new do |l|
		l.collection = Collection.find_by_name('collection1')
		l.collectible = p
		l.save!
	end
end

Category.first(10).each do |c|
	Listing.new do |l|
		l.collection = Collection.find_by_name('collection1')
		l.collectible = c
		l.save!
	end
end

Venue.first(10).each do |v|
	Listing.new do |l|
		l.collection = Collection.find_by_name('collection1')
		l.collectible = v
		l.save!
	end
end

#create a testimonials collection


#create the navbar dropdowns

["Sports Tickets", "Concert Tickets", "Theater Tickets", "Browse by Region"].each do |name|
	collection = Collection.new
  collection.name = name
  collection.save
  events = Event.active.future.all.sample(30)
  events.each do |event|
    listing = Listing.new
    listing.collection = collection
    listing.collectible = event
    listing.save
  end

end
Section.destroy_all

#create an all events collection
Collection.new do |collection|
  collection.name = 'collection4'
  collection.save!
  Event.active.future.all.sample(20).each do |event|
    Listing.new do |listing|
      listing.collection = collection
      listing.collectible = event
      listing.save!
    end
  end
end

#create some page parts
Section.create(name: 'navbar links', content: "Sports Tickets,Concert Tickets,Theater Tickets")
Section.create(name: 'home content', content: '{%carousel /assets/image2(1).jpg|MLB opening day|tickets are now available!|Get tickets|/venues/aami-stadium^/assets/image2(1).jpg|MLB closing day|tickets are now available!|Get tickets now|/venues/aalen-stadium%}
  {% auto_location 4 %}
  {% popular_events %}
  {% performergrid Featured Performers,8 %}
  {% events Sports Tickets,Concert Tickets,Theater Tickets %}')
Section.create(name: 'home left sidebar', content:'<section class="span3">
{% filter %}
{% browse_categories browse categories,Sports Tickets, Concert Tickets, Theater Tickets, Browse by Region %}
{% mailing_list %}
{% follow_us %}
{% like_google_plus %}
{% contact_us %}
</section>')
Section.create(name: 'home right sidebar', content: '<section class="span3">
{% featured featured concerts|collection1|/assets/image2.jpg|/wwe--2/wwe-tickets/wwe-raw-2012-12-03|/theatre%}
{% featured featured theater|collection1|/assets/image1.jpg|/wwe--2/wwe-tickets/wwe-raw-2012-12-03|/theatre%}
{% testimonials collection2 %}
{% quality_assurance /%}
</section>')
Section.new do |s|
  s.name = 'footer'
  s.content = File.read('db/footer.txt')
  s.save!
end
StaticPage.create!(permalink: "homepage", name:"HomePage", content:"placeholder", active:false, include_left_sidebar: false, include_right_sidebar:false)

['AL','AK','AZ','AR','CA','CO','CT','DE','DC','FL','GA','HI','ID','IL','IN',
  'IA','KS','KY','LA','ME','MD','MA','MI','MN','MS','MO','MT','NE','NV','NC',
  'ND','OH','OK','OR','PA','PR','RI','SC','SD','TN','TX','UT','VT','VA','WA',
  'WV','WI','WY'].each do |state|
    unless Location.find_by_name state
      location = Location.new
      location.name = state
      location.city = false
      location.save
    end
end
