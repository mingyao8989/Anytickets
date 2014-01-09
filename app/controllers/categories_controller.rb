class CategoriesController < ApplicationController
  def show
  	@category = Category.visible.active.find(params[:id])

    set_seo_vars(@category)

    @sub_categories = @category.visible_children

    @performers = @category.visible_performers

    @collections = @category.owned_collections

    if session[:city]
      city = Location.find_by_display_name session[:city]
      @local_events = Event.future.active.where(location_id: city.id, category_id: @category.id).popular if city
    end
  end
end
