class EventsController < ApplicationController

  def show
    require "ticketnetwork"
    
    if params[:performer_id]
      @performer = Performer.find params[:performer_id]
      not_found unless @performer.category
      @performer.category.root.slug == params[:category_id] && @performer.category.root.visible && @performer.category.root.active or not_found
      begin
        @date = DateTime.strptime params[:date], "%Y-%m-%d--%H:%M"
      rescue
        not_found
      end

      @event = Event.joins("INNER JOIN events_performers ON events.id = events_performers.event_id")
                    .where('events_performers.performer_id' => @performer.id)
                    .where("events.date" => @date)
                    .first or not_found
    else
      @event = Event.active.find params[:id]
    end

    begin
      response = Ticketnetwork.make_request :get_tickets, {'eventID' => @event.tnid}
    rescue => e
      logger.error e
    end

    if response.nil?
      @tickets = []
    else
     @tickets = response['ticket_group'].select{|ticket| ticket.kind_of?(Hash)}
    end

    @number_options = Ticketnetwork.get_number_options @tickets
    @ticket_amount = params[:number_of_tickets].nil? ? 1 : params[:number_of_tickets]
    params[:number_of_tickets] = "I'll decide at checkout" if !params[:number_of_tickets]
    params[:min_price] = "No minimum" if !params[:min_price]
    params[:max_price] = "No maximum" if !params[:max_price]
    params[:selected_sections] = "" if !params[:selected_sections]

    if params[:min_price] != "No minimum"
      @tickets = @tickets.select{|ticket| ticket['actual_price'].to_i >= params[:min_price].to_i}
    end
    if params[:max_price] != "No maximum"
      @tickets = @tickets.select{|ticket| ticket['actual_price'].to_i <= params[:max_price].to_i}
    end
    if params[:number_of_tickets] != "I'll decide at checkout"
      @tickets = @tickets.select{|ticket| ticket['valid_splits']['int'].include? params[:number_of_tickets].to_s}
    end
    # communicate with a interactive map
    if params[:selected_sections] != ""
      all_selected_sections = " #{params[:selected_sections].to_s.upcase} "
      @tickets = @tickets.select{|ticket| all_selected_sections.include? " #{ticket['section'].upcase} " }
    end

    if params[:sort]
      case params[:sort]
      when "section"
        @tickets.sort_by!{|ticket| ticket['section']}
      when "row"
        @tickets.sort_by!{|ticket| ticket['row']}
      when "available"
        @tickets.sort_by!{|ticket| ticket['valid_splits']['int'].map(&:to_i).sort.last}
      when "price"
        @tickets.sort_by!{|ticket| ticket['actual_price'].to_f}
      end
    end

    respond_to do |format|
      format.js {render layout: false}
      format.html {render}
    end

  end
end
