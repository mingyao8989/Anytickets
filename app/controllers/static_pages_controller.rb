class StaticPagesController < ApplicationController

  def show
    if params[:permalink]
      @page = StaticPage.active.find_by_permalink(params[:permalink]) || not_found
    else
      @page = StaticPage.active.find(params[:id])
    end
    @left_sidebar = liquify Section.find_by_name('home left sidebar').content if @page.include_left_sidebar
    @right_sidebar = liquify Section.find_by_name('home right sidebar').content if @page.include_right_sidebar

    set_meta_tags :title => @page.title,
                  :description => @page.meta_description
  end
end
