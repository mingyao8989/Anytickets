class VenuesController < ApplicationController

  def show
  	@venue = Venue.find(params[:id])
  	@events = Event.active.future.where(:venue_id => @venue.id).page(1).per(10)

  	@left_sidebar = liquify Section.find_by_name('home left sidebar').content
  	@right_sidebar = liquify Section.find_by_name('home right sidebar').content

    set_seo_vars(@venue)
  end

  def events
  	@venue = Venue.find_by_slug(params[:id])
  	params[:order_by] = "name ASC" if !params[:order_by]
    @events = Event.active.future
      .joins("LEFT OUTER JOIN locations ON events.location_id = locations.id")
        .joins("LEFT OUTER JOIN venues ON venues.id = events.venue_id")
          .where(:venue_id => @venue.id)
            .order(params[:order_by]).page(params[:page]).per(10)


  	respond_to do |format|
  		format.js {render layout: false}
  	end

  end

end
