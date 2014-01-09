class SearchController < ApplicationController
  respond_to :html, :json

  def show
  	require 'ticketnetwork'

  	#get data from server
  	@search_term = params[:search_term]
    begin
      response = Ticketnetwork.make_request(:search_events, {'searchTerms' => @search_term})
    rescue => e
      logger.error e
    end

    if response.nil?
      @events = []
    else
    #get events from db
  	event_tnids = Ticketnetwork.get_tnids response
  	params[:order_by] = 'date ASC' if !params[:order_by]
  	@events = Event.future.active
      .joins("LEFT OUTER JOIN venues ON venues.id = events.venue_id")
        .joins("LEFT OUTER JOIN locations ON events.location_id = locations.id")
          .order(params[:order_by]).where(:events => {:tnid => event_tnids })
            .page(params[:page]).per(20)
    end
  end

  def index

  	@events = Event.future.active
  	@events = @events.joins("LEFT OUTER JOIN venues ON venues.id = events.venue_id")
      .joins("LEFT OUTER JOIN locations ON locations.id = events.location_id")
    if params[:main_category] && params[:main_category] != "All Events"
  		@events = @events.where( "events.main_category = ?", params[:main_category])
  	end
    if params[:state] && params[:state] != "All States"
        @events = @events.where state_province: params[:state]
    end
  	if params[:name] && params[:name] != ""
  		@events = @events.where("upper(events.name) LIKE upper( ? ) OR upper(venues.name) LIKE upper( ? )",
  		  "%#{params[:name]}%",
  		  "%#{params[:name]}%")
  	end
  	if params[:date] && params[:date] != ""
	  	begin
	  		@events = @events.date(params[:date])
	  	rescue ArgumentError
		end
  	end
  	params[:order_by] = 'priority DESC' unless params[:order_by] && params[:order_by] != ""
  	@events = @events.order(params[:order_by])
  	@events = @events.page(params[:page]).per(20)
    render "index_page"
  end

  def autocomplete
    term = params[:term].downcase unless params[:term].nil?

    @performers = Performer.order(:name).where("lower(name) like ?", "%#{term}%").limit(5)
    @performers.collect!{ |performer| { :label => performer.name, :url => collectible_link(performer), :type => 'performer'} }

    @categories = Category.visible.order(:name).where("lower(name) like ?", "%#{term}%").limit(5)
    @categories.collect!{ |category| { :label => category.name, :url => collectible_link(category), :type => 'category'} }

    @results = @categories + @performers
#    @results = [{:label => "No results found", :url => "#", :type => 'none'}] if @results.empty?

    respond_to do |format|
      format.json { render :json => @results }
    end
  end
end
