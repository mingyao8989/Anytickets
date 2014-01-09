require "controller_view_shared_methods"
class ApplicationController < ActionController::Base
  include ControllerViewSharedMethods

  protect_from_forgery

  before_filter :reload_rails_admin, if: :rails_admin_path?
  before_filter :set_variables

  def not_found
    raise ActiveRecord::RecordNotFound, "Page not found"
  end


  def liquify(template, opts={})
    begin
      tmpl = Liquid::Template.parse(template)
      tmpl.render(opts, registers: {controller: self}).html_safe
    rescue => msg
     logger.warn msg
     msg
    end
  end

  def liquid_description(description, liquid_opts={})
    	paragraphs = description.split(/\n\n|\r\n\r\n|\n\r\n\r/).compact
    	header = paragraphs.shift

    	render(partial: 'widgets/description', locals: {
      		paragraphs: paragraphs,
      		header: header,
      		liquid_opts: liquid_opts
    	})
  end

  def set_variables
    #loads footer and navbar links

    @left_sidebar = liquify Section.find_by_name('home left sidebar').content
    @right_sidebar = liquify Section.find_by_name('home right sidebar').content

    @footer = liquify Section.find_by_name('footer').content

    #find the collections for the navbar dropdown as stored in the navbar links section
    header_collection_names = Section.find_by_name('navbar links')

    if header_collection_names
      array = []
      header_collection_names.content.split(',').map(&:strip).each do |name|
        collection = Collection.find_by_name name
        array << collection if collection
      end
      @header_collections =  array
    else
      @header_collections = []
    end
    if params[:city] == ""
      session[:city] = nil
      session[:dont_check_city] = true
    else
      if params[:city] && params[:city] != ""
        session[:city] = params[:city]
      end
      unless session[:dont_check_city]
        begin
          if session[:city].nil? || session[:city] == ""
            location = GeoLocation.find request.remote_ip
            if location[:city] && location[:city] != "" && location[:city] != "(Private Address)"
              city_name = location[:city].strip.downcase.split(' ').map {|word| word.capitalize}.join(' ')
              city = Location.find_by_display_name(city_name) || Location.find_by_name(city_name)
              session[:city] =  city.try(:display_name) || city_name
            end
          end
        rescue Exception => e
          session[:city] = params[:city] if params[:city] && params[:city] != ""
        end
      end
    end
  end

  def set_seo_vars(model)
    @page_h1          = model.h1_text
    set_meta_tags :title => model.meta_title_text,
                  :description => model.meta_description_text
  end


  private

  def reload_rails_admin
    models = %W(Category, Collection, Venue, Section)
    models.each do |m|
      RailsAdmin::Config.reset_model(m)
    end
    RailsAdmin::Config::Actions.reset

    load("#{Rails.root}/config/initializers/rails_admin.rb")
  end

  def rails_admin_path?
    controller_path =~ /admin/ && Rails.env == "development"
  end
end