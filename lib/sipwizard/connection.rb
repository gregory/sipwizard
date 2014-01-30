require 'faraday'

module Sipwizard
  class Connection
    BASE_URI = 'https://www.sipsorcery.com'
    API_PATH = '/rest/v0.1/provisioning.svc'

    attr_accessor :faraday_connection

    def initialize(faraday_adapter=Faraday.default_adapter)
      @faraday_connection = Faraday.new(url: self.base_uri) do |faraday|
        faraday.request :url_encoded #for post/put params
        faraday.response :logger
        faraday.adapter faraday_adapter
      end
    end

    def base_uri
      BASE_URI
    end
  end
end
