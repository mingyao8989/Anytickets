  namespace :utils do

    desc "create CSV files"
    task :create_csvs => :environment do
      Event.create_csv "./public/csvs/daily_events.csv"
      Venue.create_csv "./public/csvs/daily_venues.csv"
      Performer.create_csv "./public/csvs/daily_performers.csv"
    end

    desc "update image_path for uploaded images"
    task :update_image_path => :environment do
      entries = Dir.entries "#{Rails.root}/shared/pictures"
      entries.each do |entry|
        next if entry == "." || entry == ".."
        slug = entry.split(".")[0]
        event = Event.find_by_slug slug
        performer = Performer.find_by_slug slug
        found_item = event || performer
        path = "/pictures/#{entry}"
        if found_item && found_item.image_path != path
          found_item.image_path = path
          found_item.save
          puts "Updated path of #{found_item.class.to_s} #{found_item.name}"
        end
      end
    end
    
    desc "Give default meta values to all performers"
    task :update_meta_values => :environment do
      i = 1
      Performer.find_each do |performer| 
        performer.default_meta_values 
        puts i
        puts "performer"
        puts performer.meta_title
        puts performer.h1
        puts performer.meta_description
        i = i + 1
      end
      i = 0
      Event.find_each do |event| 
        event.default_meta_values
        puts "event" 
        puts i
        puts event.meta_title
        puts event.h1
        puts event.meta_description
        i = i + 1
      end
    end

  end
