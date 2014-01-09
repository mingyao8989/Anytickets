class LocationsController < ApplicationController

  def index
    @cities = Location.where(city: true).order(:name).all
    @venues = Venue.all
  end

  def show
    @location = Location.find params[:id]
    if @location.city
    	events = Event.active.future.where(:location_id => @location.id)
    else
    	events = Event.active.future.where(:state_province => @location.name)
    end
    @events_hash = Event.alphabetical_hash events
  end

end
