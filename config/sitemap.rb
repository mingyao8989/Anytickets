# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://allseats.com"

SitemapGenerator::Sitemap.create do
  def collectible_link(item, performer = nil)
    #no url in STRING
    case item.class.to_s
    when "Category"
        category_path item
    when "Event"
      if performer && performer.category && performer.category.root.visible \
          && performer.category.root.active
        long_event_path(category_id: performer.category.root.slug, performer_id: performer.slug, date: item.url_date)
      else
        if item.performers.count == 0 || item.performers.first.category.nil? \
            || !item.performers.first.category.visible || !item.performers.first.category.active
          event_path item
        else
          performer = item.performers.first
          long_event_path(category_id: performer.category.root.slug, date: item.url_date, performer_id: performer.slug)
        end
      end
    when "Performer"
      if item.category && item.category.visible && item.category.active
        long_performer_path id: item.slug, category_id: item.category.root.slug
      else
        performer_path item
      end
    when "Venue"
      venue_path item
    when "Location"
      location_path item
    when "Collection"
      collection_path item
    end
  end


  Performer.active.find_each do |performer|
    add collectible_link(performer)
  end

  Category.visible.active.find_each do |category|
    add collectible_link(category)
  end

  Venue.find_each do |venue|
    add collectible_link(venue)
  end

  Event.active.future.find_each do |event|
    add collectible_link(event)
  end

  Location.find_each do |location|
    add location_path(location)
  end

  StaticPage.find_each do |static_page|
    add static_page_path(permalink: static_page.permalink)
  end

  Collection.find_each do |collection|
    add collection_path(collection)
  end

  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
end
