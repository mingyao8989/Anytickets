

class AutoLocationTag < Liquid::Tag
  def initialize(name, params, token)
    @number = params.strip.to_i
    super
  end

  def render(context)
    context.registers[:controller].render_to_string(partial: 'widgets/auto_location', locals: {number: @number})
  end

end

Liquid::Template.register_tag('auto_location',AutoLocationTag)


class FilterTag < Liquid::Tag
  def initialize(name, params, token)
    super
  end

  def render(context)
    context.registers[:controller].render_to_string(partial: 'widgets/filter')
  end

end

Liquid::Template.register_tag('filter',FilterTag)


class PopularEvents < Liquid::Tag
  def initialize(name, params, token)
    @collection = Event.active.future.popular.first(8)
    super
  end

  def render(context)
    context.registers[:controller].render_to_string(partial: 'widgets/popular_events', locals:{
        collection: @collection
      })
  end

end

Liquid::Template.register_tag('popular_events',PopularEvents)

class ImagesTag < Liquid::Tag
  def initialize(name, params, token)
    collections = params.split(',').map(&:strip)
    @collection = Collection.find_by_name(collections[0])
    @grid_size = collections[1].to_i
    super
  end

  def render(context)
    context.registers[:controller].render_to_string(partial: 'widgets/imagegrid', locals:{
        collection: @collection,
        grid_size: @grid_size,
        buffer_type: "buffer"
      }) if @collection
  end
end

Liquid::Template.register_tag('imagegrid', ImagesTag)

class PerformerGrid < Liquid::Tag
  def initialize(name, params, token)
    collections = params.split(',').map(&:strip)
    @collection = Collection.find_by_name(collections[0])
    @grid_size = collections[1].to_i
    super
  end

  def render(context)
    begin
      context.registers[:controller].render_to_string(partial: 'widgets/imagegrid', locals:{
        collection: @collection,
        grid_size: @grid_size,
        buffer_type: "small_buffer"
      }) if @collection
    rescue Exception => e
      Rails.logger.fatal "Exception caught while rendering performergrid:"
      Rails.logger.fatal e.message
      Rails.logger.fatal e.backtrace.join("\n")
    end
  end
end

Liquid::Template.register_tag('performergrid', PerformerGrid)

class EventsTag < Liquid::Tag
  def initialize(name, params, token)
    collections = params.split(',').map(&:strip)
    @collection1 = Collection.find_by_name(collections[0])
    @collection2 = Collection.find_by_name(collections[1])
    @collection3 = Collection.find_by_name(collections[2])
    super
  end

  def render(context)
    context.registers[:controller].render_to_string(partial: 'widgets/events', locals:{
        collection1: @collection1,
        collection2: @collection2,
        collection3: @collection3
      }) if @collection1 && @collection2 && @collection3
  end
end

Liquid::Template.register_tag('events', EventsTag)

class QualityAssuranceTag < Liquid::Tag
  def initialize(name, params, token)
    @link = params
    super
  end

  def render(context)
    context.registers[:controller].render_to_string(partial: 'widgets/quality_assurance', locals:{link:@link})
  end
end

Liquid::Template.register_tag('quality_assurance', QualityAssuranceTag)



class TestimonialsTag < Liquid::Tag
  def initialize(name, params, token)
    super
  end

  def render(context)
    context.registers[:controller].render_to_string(partial: 'widgets/testimonials')
  end
end

Liquid::Template.register_tag('testimonials', TestimonialsTag)


class FeaturedTag < Liquid::Tag
  def initialize(name, params, token)
    args = params.split("|")
    @title = args[0]
    @col = Collection.find_by_name(args[1].strip)
    @image = args[2]
    @image_link = args[3]
    @all_link = args[4]
    super
  end

  def render(context)
    #binding.pry
    context.registers[:controller].render_to_string(partial: 'widgets/featured', locals:{
      collection:@col, title: @title, image: @image, image_link: @image_link, all_link: @all_link}) if @col
  end
end

Liquid::Template.register_tag('featured', FeaturedTag)

class ContactUsTag < Liquid::Tag
  def initialize(name, params, token)
    super
  end

  def render(context)
    context.registers[:controller].render_to_string(partial: 'widgets/contact_us')
  end
end

Liquid::Template.register_tag('contact_us', ContactUsTag)

class LikeGooglePlusTag < Liquid::Tag
  def initialize(name, params, token)
    super
  end

  def render(context)
    context.registers[:controller].render_to_string(partial: 'widgets/like_google_plus')
  end
end

Liquid::Template.register_tag('like_google_plus', LikeGooglePlusTag)

class FollowUsTag < Liquid::Tag
  def initialize(name,params,token)
    super
  end

  def render(context)
    context.registers[:controller].render_to_string(partial: 'widgets/follow_us')
  end
end

Liquid::Template.register_tag('follow_us', FollowUsTag)

class MailingListTag < Liquid::Tag
  def initialize(name, params, token)
    super
  end

  def render(context)
    context.registers[:controller].render_to_string(partial: 'widgets/mailing_list')
  end
end

Liquid::Template.register_tag('mailing_list', MailingListTag)


class BrowseCategoriesTag < Liquid::Tag
  def initialize(name, params, token)
    names = params.split(",").map(&:strip)
    @name = names[0]
    @collections = names[1,names.size].collect {|name| Collection.find_by_name name}.compact
    super
  end

  def render(context)
    context.registers[:controller].render_to_string(partial: 'widgets/browse_categories', locals:{
        collections: @collections,
        title: @name
      }) unless @collections.nil? || @collections.empty?
  end
end

Liquid::Template.register_tag('browse_categories', BrowseCategoriesTag)


class LinkbucketTag < Liquid::Tag
  def initialize(name, collection, token)
  	@col=Collection.find_by_name(collection.strip)
    super
  end

  def render(context)
    context.registers[:controller].render_to_string(partial: 'widgets/linkbucket', locals: {collection: @col})
  end
end

Liquid::Template.register_tag('linkbucket', LinkbucketTag)

class NavlistTag < Liquid::Tag
  def initialize(name, collection, tokens)
    @col = Collection.find_by_name(collection.strip)
    super
  end

  def render(context)
    context.registers[:controller].render_to_string(partial: 'widgets/navlist', locals: {collection: @col}) if @col
  end
end
Liquid::Template.register_tag('navlist',NavlistTag)

class PlainwidgetBlock < Liquid::Block
  def initialize(name, _, token)
    super
  end

  attr_accessor :content

  def render(context)
    content = super
    context.registers[:controller].render_to_string(partial: 'widgets/plainwidget', locals: {
      content: content
    })
  end

end

Liquid::Template.register_tag('plainwidget',PlainwidgetBlock)

class YoutubeTag < Liquid::Tag
  def initialize(name, video_id, tokens)
    @video_id = video_id.strip
    super
  end

  attr_accessor :video_id

  def render(context)
    context.registers[:controller].render_to_string(partial: 'widgets/youtube', locals: {video_id: @video_id})
  end
end

Liquid::Template.register_tag('youtube', YoutubeTag)

Liquid::Template.register_tag('plainwidget',PlainwidgetBlock)

class CarouselTag < Liquid::Tag
  def initialize(name, params, tokens)
    @ex = false
    begin
      @items = []
      items_strings = params.split("^")
      items_strings.each do |item_string|
        args = item_string.split("|")
        @items << {image: args[0], title_bold: args[1], title: args[2], button_text: args[3], link: args[4]}
      end
    rescue Exception
      @ex = true
    end
    super
  end

  def render(context)
    context.registers[:controller].render_to_string(partial: 'widgets/carousel', locals: {items: @items}) unless @ex
  end
end

Liquid::Template.register_tag('carousel', CarouselTag)

