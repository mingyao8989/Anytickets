# encoding: UTF-8
require "ticketnetwork"
namespace :tn do

  namespace :import do

    def get_category hash
      catids = hash.values_at("parent_category_id", "child_category_id", "grandchild_category_id")
      parent = Category.find_by_tnid catids[0]
      child = Category.where(tnid: catids[1], parent_tnid: catids[0]).first
      grandchild = Category.where(tnid: catids[2], parent_tnid: catids[1], grandparent_tnid: catids[0]).first
      grandchild || child || parent
    end

    def set_location item, location_name
      location = Location.find_by_name location_name
      unless location
        location = Location.new
        location.name = location_name
        location.display_name = "#{item.state_province.strip}-#{location_name.strip}"
        location.city = true
        location.save!
      end
      item.location = location unless item.location == location
      item.save!
    end


    desc "Pull categories"
    task :categories => :environment do
      cats = Ticketnetwork.cache(:get_categories_master_list)
      cats[:category].each_with_index do |cat, i|
        catids = cat.values_at :parent_category_id, :child_category_id, :grandchild_category_id
        names = cat.values_at :parent_category_description, :child_category_description, :grandchild_category_description

        parent = nil
        child = Category.roots.where(tnid: catids[0]).first
        3.times do |iteration|
          if child.nil?
            child = Category.create
            child.name = names[iteration]
            child.tnid = catids[iteration]
            child.parent = parent if parent
            child.save!
          end
          parent = child
          child = parent.children.where(tnid: catids[iteration + 1]).first
        end

        puts i if i % 10 == 0
      end
    end

    desc "Update category tree by TN data"
    task :update_tree => :environment do
      Category.find_each do |category|
        category.parent_tnid = category.parent.tnid if category.parent
        category.grandparent_tnid = category.parent.parent.tnid if category.parent && category.parent.parent
        category.save!
      end
    end

    desc "flattens the categories tree- removes categories named ''"
    task :flatten => :environment do
      Category.flatten
    end

    task :pull_categories => [:categories, :update_tree, :flatten]

    desc "Import venues"
    task :venues => :environment do

      venues = Ticketnetwork.cache(:get_venue)

      venues['venue'].each_with_index do |venue, i|
          v = Venue.find_by_tnid(venue['id'])
        if v == nil
          v = Venue.new
          v.tnid           = venue['id']
          v.name           = venue['name']
          v.country        = venue['country']
          v.state_province = venue['state_province']
          v.zipcode        = venue['zip_code']
          v.street1        = venue['street1']
          v.street2        = venue['street2']
        end
        set_location v, venue['city']

      puts i  if i % 10 ==0
      end
    end

    desc "Import performers"
    task :performers => :environment do
      performers = Ticketnetwork.cache(:get_performer_by_category)
      performers['performer'].each_with_index do |performer, i|
        category = get_category performer['category']
        p = Performer.find_by_tnid(performer['id'])
        unless p
          p = Performer.new
          p.tnid = performer['id']
          p.name = performer['description']
          p.category = category
          p.active = false
          p.default_meta_values # This also saves p
        end
        puts i if i % 10 == 0
      end
    end

    desc "Import events"
    task :events => :environment do
      events = Ticketnetwork.cache(:get_events, beginDate: Time.now.midnight.xmlschema)
      events['event'].each_with_index do |event, i|
        category = get_category event
        e = Event.find_by_tnid(event['id'])
        unless e
          e = Event.new
          e.clicks =              event['clicks']
          e.country_tnid =        event['country_id']
          e.date =                event['date']
          e.img_interactive_url = event['interactive_map_url']
          e.img_static_url =      event['map_url']
          e.is_womens =           event['is_womens_event']
          e.name =                event['name']
          e.state_province =      event['state_province']
          e.tnid =                event['id']
          e.venue_configuration = event['venue_configuration']

          e.category = category
          begin
            if e.category.parent.parent
              e.main_category = e.category.parent.parent.name
            else
              e.main_category = e.category.parent.name
            end
          rescue
            puts event
          end
          e.venue = Venue.find_by_tnid(event['venue_id'])
          set_location e, event['city']
          e.default_meta_values
        end

        puts i if i % 10 == 0
      end
      #match events to performers
      event_performers = Ticketnetwork.cache(:get_event_performers)
      event_performers['event_performer'].each_with_index do |event_performer,i|
        event = Event.find_by_tnid(event_performer['event_id'])
        performer = Performer.find_by_tnid(event_performer['performer_id'])
        if event != nil && performer != nil
          event.performers << performer unless event.performers.exists?(id: performer.id)
          event.save!
          puts i if i % 10 == 0
        end
      end

    end



    task :all => [:performers,:venues, :events]



  end
end
