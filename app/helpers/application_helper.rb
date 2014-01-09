require "controller_view_shared_methods"
module ApplicationHelper
  include ControllerViewSharedMethods


  def markdown(text)
  	markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :hard_wrap => true, :autolink => true)
  	markdown.render(text).html_safe
  end

  def get_location_path city_name
    city = Location.find_by_name city_name || not_found
    location_path city
  end

  
  

  #You will need to replace everything in angle brackets (<,>) above with the appropriate values. “<bid>” is your broker ID (given above), “<sid>” is your site number (also given above), “<tgid>” is the ID of the ticket group, “<evtid>” is the event ID of all the ticket groups on the page, “<price>” is the price you have quoted on your page (note that this value is passed for logging purposes only), and “<treq>” is the number of tickets requested by the customer.
  #“<sessionid>” must be a unique, 5-character alphanumeric random string (e.g., “gs32X”) for every checkout link on the page. Again, each session ID must be unique. Here is sample JavaScript code for generating session IDs client-side:
  def checkout_url(event_id, ticket_group_id, price, amount)
    broker_id = 932
    site_number = 20
    session_id = random_session
    "https://tickettransaction2.com/Checkout.aspx?brokerid=#{broker_id}&sitenumber=#{site_number}&tgid=#{ticket_group_id}&evtid=#{event_id}&price=#{price}&treq=#{amount}&SessionId=#{session_id}"
  end

def us_states
    [
      ['Alabama', 'AL'],
      ['Alaska', 'AK'],
      ['Arizona', 'AZ'],
      ['Arkansas', 'AR'],
      ['California', 'CA'],
      ['Colorado', 'CO'],
      ['Connecticut', 'CT'],
      ['Delaware', 'DE'],
      ['District of Columbia', 'DC'],
      ['Florida', 'FL'],
      ['Georgia', 'GA'],
      ['Hawaii', 'HI'],
      ['Idaho', 'ID'],
      ['Illinois', 'IL'],
      ['Indiana', 'IN'],
      ['Iowa', 'IA'],
      ['Kansas', 'KS'],
      ['Kentucky', 'KY'],
      ['Louisiana', 'LA'],
      ['Maine', 'ME'],
      ['Maryland', 'MD'],
      ['Massachusetts', 'MA'],
      ['Michigan', 'MI'],
      ['Minnesota', 'MN'],
      ['Mississippi', 'MS'],
      ['Missouri', 'MO'],
      ['Montana', 'MT'],
      ['Nebraska', 'NE'],
      ['Nevada', 'NV'],
      ['New Hampshire', 'NH'],
      ['New Jersey', 'NJ'],
      ['New Mexico', 'NM'],
      ['New York', 'NY'],
      ['North Carolina', 'NC'],
      ['North Dakota', 'ND'],
      ['Ohio', 'OH'],
      ['Oklahoma', 'OK'],
      ['Oregon', 'OR'],
      ['Pennsylvania', 'PA'],
      ['Puerto Rico', 'PR'],
      ['Rhode Island', 'RI'],
      ['South Carolina', 'SC'],
      ['South Dakota', 'SD'],
      ['Tennessee', 'TN'],
      ['Texas', 'TX'],
      ['Utah', 'UT'],
      ['Vermont', 'VT'],
      ['Virginia', 'VA'],
      ['Washington', 'WA'],
      ['West Virginia', 'WV'],
      ['Wisconsin', 'WI'],
      ['Wyoming', 'WY']
    ]
end

  def random_session
    charset = %w{ 1 2 3 4 5 6 7 8 9 a b c d e f g h j k m n p q r x y z A C D E F G H J K M N P Q R T V W X Y Z}
    (0...5).map{ charset.to_a[rand(charset.size)] }.join
  end

  def google_analytics(id = nil)
    content_tag(:script, :type => 'text/javascript') do
      "var _gaq = _gaq || [];
      _gaq.push(['_setAccount', '#{id}']);
      _gaq.push(['_trackPageview']);
      (function() {
        var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
        ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
        var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
      })()".html_safe
    end if !id.blank? && Rails.env.production?
  end

end
