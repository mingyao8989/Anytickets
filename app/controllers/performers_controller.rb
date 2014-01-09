class PerformersController < ApplicationController
  #move page size to constant
  def show
  	@performer = Performer.find(params[:id])
    if params[:category_id]
      not_found if @performer.category.nil? || @performer.category.root.slug != params[:category_id] || !@performer.category.root.visible || !@performer.category.root.active
    end
  	@events = Event
      .joins("RIGHT OUTER JOIN events_performers ON events_performers.event_id = events.id")
        .joins("LEFT OUTER JOIN locations ON events.location_id = locations.id")
          .where('events_performers.performer_id' => @performer.id)
              .order('date ASC')
                .future.active.page(1).per(10)
    if session[:city]
      city = Location.where(display_name: session[:city]).first
      @local_events = Event.future.active.where(location_id: city.id).order(:featured, "priority DESC", "clicks DESC").all.select {|event| event.performers.exists?(id: @performer.id)} if city
    end
    #TODO
  	@category = @performer.category
  	@parent_category = @category.parent if @performer.category
  	@grandparent_category = @parent_category.parent if @parent_category

  	@left_sidebar = liquify Section.find_by_name('home left sidebar').content
  	@right_sidebar = liquify Section.find_by_name('home right sidebar').content

    set_seo_vars(@performer)
  end

  #consider moving this to events index
  def events
  	@performer = Performer.active.find(params[:id])
  	params[:order_by] = "date ASC" if !params[:order_by]
    @events = Event
        .joins("RIGHT OUTER JOIN events_performers ON events_performers.event_id = events.id")
          .joins("LEFT OUTER JOIN venues ON venues.id = events.venue_id")
            .joins("LEFT OUTER JOIN locations ON events.location_id = locations.id")
              .where("events_performers.performer_id" => @performer.id).order(params[:order_by])
                .future.active.page(params[:page]).per(10)

  	respond_to do |format|
  		format.js {render layout: false}
  	end

  end
end
