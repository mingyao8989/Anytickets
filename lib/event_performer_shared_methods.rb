module EventPerformerSharedMethods
  def default_meta_values
    if self.class == Performer
      if self.meta_title.nil? || self.meta_title == ""
        if self.category && self.category.root.name == "SPORTS"
          self.meta_title = "#{self.name} Tickets for Home and Away Games, at AnyTickets.com"
        elsif self.category && self.category.name == "BROADWAY"
          self.meta_title = "#{self.name} Tickets on Broadway, at AnyTickets.com"
        elsif self.category && (self.category.name == "LAS VEGAS" || (self.category.parent && self.category.parent.name == "LAS VEGAS"))
          self.meta_title = "#{self.name} Tickets in Las Vegas, at AnyTickets.com"
        elsif self.category && (self.category.name == "CONCERTS" || self.category.root.name == "CONCERTS")
          self.meta_title = "#{self.name} Tickets, In Concert and On Tour, at AnyTickets.com"
        elsif self.category && self.category.root.name == "THEATRE"
          self.meta_title = "#{self.name} Tickets at AnyTickets.com" # TODO: complete this
        else
          self.meta_title = "#{self.name} Tickets at AnyTickets.com"
        end
      end
    else
      if self.meta_title.nil? || self.meta_title == ""
        if self.venue
          venue_string = "at #{self.venue.name}"
        else
          venue_string =""
        end
        if self.performers.count != 0
          performers_string = self.performers.map {|performer| performer.name}.join(" and ").truncate(100)
          self.meta_title = "Tickets for #{performers_string} #{venue_string}"
        else
          self.meta_title =  "Tickets for #{self.name} #{venue_string}"
        end
      end
    end
      
    if self.h1.nil? || self.h1 == ""
      if self.category && self.category.root.name == "SPORTS"
        self.h1 = "#{Time.now.year.to_s} #{self.name} schedule and tickets"
      else
        self.h1 = "#{Time.now.year.to_s} #{self.name} tickets and tour schedule"
      end
    end

    if self.meta_description.nil? || self.meta_description == ""
      self.meta_description = "Order your #{self.name} Tickets today! Anytickets offers the best seats and prices. View tour dates, pricing, and available seating today!"
    end


    self.save
  end
end
