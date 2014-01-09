# encoding: UTF-8

require 'savon'
require 'active_support/core_ext'
require 'json'

module Ticketnetwork
  WEBSITE_CONFIG_ID = 13559
  WSDL_DOCUMENT = "http://tnwebservices.ticketnetwork.com/tnwebservice/v3.2/WSDL/tnwebservice.xml"
  WSDL_ENDPOINT = "http://tnwebservices.ticketnetwork.com/tnwebservice/v3.2/tnwebservice.asmx"
  CACHEDIR = File.join("#{Rails.root}/", 'tncache')

  class <<self
    def client
      @__client__ ||= Savon::Client.new do
        wsdl.document = WSDL_DOCUMENT
        wsdl.endpoint = WSDL_ENDPOINT
      end
    end

    def get_number_options tickets
      if tickets.empty?
        []
      else
        number_options = []
        tickets.each do |ticket|
          if ticket.kind_of?(Array) || ticket['valid_splits'].kind_of?(Array)
            next
          else
            if ticket['valid_splits']['int'].kind_of?(Array)
            current = ticket['valid_splits']['int']
            else
            current = [ticket['valid_splits']['int']]
            end
          end
          number_options = number_options + current
        end
        number_options.uniq.map(&:to_i).select {|number| number <= 15}.sort
      end
    end

    def get_tnids response
      if response.nil?
        events_array = []
      else
        events_array = response['event']
      end
      event_tnids = []
      events_array.each do |tn_event|
        event_tnids << tn_event['id'] unless tn_event.kind_of?(Array)
      end
      event_tnids
    end

    def request(method, soap_body={})
      soap_body['websiteConfigID'] = WEBSITE_CONFIG_ID
      request = Request.create(method, soap_body)
      parser = Parser.new(method)
      json = parser.parse(request.response)

      unless json.is_utf8?
        begin
          cleaned = json.dup.force_encoding('UTF-8')
          unless cleaned.valid_encoding?
            cleaned = cleaned.encode('UTF-8', 'US-ASCII')
          end
          json = cleaned
        rescue EncodingError
          json.encode!('UTF-8', invalid: :replace, undef: :replace)
        end
      end

      json
    end

    def cachepath(method)
      File.join(CACHEDIR, [method, 'json'].join('.'))
    end

    def cache(method, soap_body={})
      return JSON.load(File.read(cachepath(method))).with_indifferent_access if cache_exists?(method)

      response = request method, soap_body

      File.open(cachepath(method), 'w:UTF-8') do |file|
        file.puts response
      end

      if response != '[]'
        JSON.load(response).with_indifferent_access
      else
        nil
      end
    end

    def make_request(method, soap_body)
      return cache(method, soap_body) unless Rails.env.production?
      response = request method, soap_body
      if response != '[]'
        JSON.load(response).with_indifferent_access
      else
        nil
      end
    end


    def cache_exists?(method)
      path = cachepath(method)
      if Rails.env.production?
        File.exists?(path) && File.mtime(path) > 0.99.days.ago
      else
        File.exists?(path)
      end
    end
  end

  class Request
    class <<self
      def create(method, soap_body={})
        new(method, soap_body).tap(&:make_request!)
      end
    end

    def initialize(method, soap_body={})
      @method = method
      @soap_body = soap_body
    end

    attr_reader :method, :soap_body
    attr_accessor :response

    def make_request!
      self.response = Ticketnetwork.client.request(method) {soap.body = soap_body}
      self
    end
  end

  class Parser
    def initialize(method)
      @method = method.to_s
    end

    attr_reader :method

    def response_key
      "#{method}_response".to_sym
    end

    def result_key
      "#{method}_result".to_sym
    end

    def collection_key
      method.sub(/^get_/, '').singularize
    end

    def parse(hash)
      results = hash[response_key][result_key]
      if results
        results.to_json.force_encoding('UTF-8')
      else
        [].to_json
      end
    rescue
      [].to_json
    end
  end
end

