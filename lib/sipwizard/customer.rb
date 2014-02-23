module Sipwizard
  class Customer < Hashie::Trash
    API_PATH_MAP={
      count: 'customeraccount/count'
    }


    def self.count(params={})
      response = connection.get(API_PATH_MAP[:count], params)

      response['Success'] ? response['Result'] : -1
    end

    private

    def self.connection
      Connection.new(api_type: :accounting)
    end
  end
end
