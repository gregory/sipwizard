require 'faraday'
require 'faraday_middleware'

module Sipwizard
  class Connection
    BASE_REST_API= "https://www.sipsorcery.com/rest/v0.1"
    API_PATHS ={
      provisioning: "#{BASE_REST_API}/provisioning.svc",
      accounting: "#{BASE_REST_API}/accounting.svc",
    }

    attr_accessor :faraday_connection

    def initialize(options={})
      faraday_adapter = options.fetch(:adapter){ Faraday.default_adapter }
      api_type        = options.fetch(:api_type){ :provisioning }
      @faraday_connection = Faraday.new(API_PATHS[api_type]) do |faraday|
        faraday.request :url_encoded #for post/put params

        faraday.response :logger
        faraday.response :raise_error
        faraday.response :json, content_type: /\bjson\z/

        faraday.adapter faraday_adapter
      end

      @faraday_connection.headers['apikey'] = Sipwizard.config.api_key
    end


    # Public make a get request to the api
    #
    # path   - The path of the api
    # params - The query parameters (default: {}):
    #
    # Examples
    #
    #   get('cdr/count')
    #
    #   get('cdr/count', { where: 'FromName="John Doe"'})
    #
    # Returns Faraday::Response
    def get(path, params={})
      self.faraday_connection.get(path, params).body
    end

    def post(path, params)
      self.faraday_connection.headers['Content-Type'] ='application/json; charset=utf-8'
      payload = params.to_json
      self.faraday_connection.post(path, payload).body
    end
  end
end
