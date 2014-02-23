module Sipwizard
  class Rate < Hashie::Trash
    API_PATH_MAP={
      count: 'rate/count',
      create: 'rate/add',
      find: 'rate/get'
    }

    property :id,                from: :ID
    property :description,       from: :Description
    property :prefix,            from: :Prefix
    property :rate,              from: :Rate
    property :rate_code,         from: :RateCode
    property :setup_cost,        from: :SetupCost
    property :inserted,          from: :Inserted
    property :increment_seconds, from: :IncrementSeconds

    def self.count(params={})
      response = connection.get(API_PATH_MAP[:count], params)

      response['Success'] ? response['Result'] : -1
    end

    def self.build_for_request(h)
      rate = self.new(h)
      rate = Hash[rate.map{ |k,v| ["#{k}".camelize, v] }]
      rate['ID']                = rate.delete('Id')

      rate.delete_if{ |_,v| v.nil? } #delete all the keys for which we dont have value
    end

    def self.create(params)
      payload = self.build_for_request(params)
      result = connection.post(API_PATH_MAP[:create], payload)

      raise ArgumentError.new(result["Error"]) unless result['Success']

      result['Result'] #ID
    end

    def self.where(params)
      Relation.new.where(params)
    end

    def self.find(id)
      relation = self.where({ ID: id }).count(1)
      result = connection.get(API_PATH_MAP[:find], relation.relation)

      return nil unless result['Success']

      self.new(result['Result'][0])
    end

    private

    def self.connection
      Connection.new(api_type: :accounting)
    end
  end
end
