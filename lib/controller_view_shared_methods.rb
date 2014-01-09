module ControllerViewSharedMethods
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
end