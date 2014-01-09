module EventHelper

  def tickets_path event, options = {}
    if event.performers.count == 0 \
          || event.performers.first.category.nil? \
          || !event.performers.first.category.root.visible \
          || !event.performers.first.category.root.active
      event_path event, options
    else
    	performer = event.performers.first
      options[:date] = event.url_date
      options[:performer_id] = performer.slug
      options[:category_id] = performer.category.root.slug
      long_event_path options
    end
  end

  def to_array_with_ranges(array)
		array = [array] unless array.kind_of?(Array)
    array.sort_by!{|n| n.to_i}
		new_array = []
		i = 0
		while i < array.length do
			j = i
			while array[i + 1].to_i == (array[i].to_i + 1) do
				i = i + 1
			end
			if j == i
				new_array << array[i]
				i = i + 1
				next
			end
		  new_array << "#{array[j]}-#{array[i]}"
		  i = i + 1
    end
    new_array
  end
end
