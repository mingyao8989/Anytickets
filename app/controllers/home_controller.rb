class HomeController < ApplicationController
  
  def home
		@page = StaticPage.find_by_permalink("homepage")
		set_meta_tags(:title => @page.title, :description => @page.meta_description) unless @page.nil?
    @content = liquify Section.find_by_name('home content').content
  end
  
end
