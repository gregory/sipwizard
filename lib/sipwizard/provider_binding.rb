module Sipwizard
  class ProviderBinding < Hashie::Trash
    API_PATH_MAP={
      count: 'sipproviderbinding/count'
    }

    def self.count(params={})
      response = Connection.new.get(API_PATH_MAP[:count], params)

      response['Success'] ? response['Result'] : -1
    end
  end
end
