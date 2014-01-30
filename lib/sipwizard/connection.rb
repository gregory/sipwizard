require 'faraday'
require 'faraday_middleware'

module Sipwizard
  class Connection
    API_PATH = 'https://www.sipsorcery.com/rest/v0.1/provisioning.svc'

    attr_accessor :faraday_connection

    def initialize(faraday_adapter=Faraday.default_adapter)
      @faraday_connection = Faraday.new do |faraday|
        faraday.request :url_encoded #for post/put params
        faraday.response :logger
        faraday.response :json, content_type: /\bjson\z/
        faraday.adapter faraday_adapter
      end

      @faraday_connection.headers['apikey'] = Sipwizard.config.api_key
    end

    def self.uri_for_path(path)
      "#{API_PATH}#{path}"
    end

    def get(path, params={})
      self.faraday_connection.get(Connection.uri_for_path(path), params)
    end
  end
end
