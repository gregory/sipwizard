module Sipwizard
  class Customer < Hashie::Trash
    API_PATH_MAP={
      count:  'customeraccount/count',
      create: 'customeraccount/add',
      find:   'customeraccount/get',
      update: 'customeraccount/update',
      delete: 'customeraccount/delete'
    }

    property :id,             from: :ID
    property :account_code,   from: :AccountCode
    property :credit,         from: :Credit
    property :account_name,   from: :AccountName
    property :account_number, from: :AccountNumber
    property :pin,            from: :PIN
    property :inserted,       from: :Inserted

    def self.count(params={})
      response = connection.get(API_PATH_MAP[:count], params)

      response['Success'] ? response['Result'] : -1
    end

    def self.build_for_request(h)
      customer = self.new(h)
      customer = Hash[customer.map{ |k,v| ["#{k}".camelize, v] }]
      customer['ID']                = customer.delete('Id')
      customer['PIN']               = customer.delete('Pin')

      customer.delete_if{ |_,v| v.nil? } #delete all the keys for which we dont have value
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

    def save
      payload = Customer.build_for_request(self.to_hash)
      result = Connection.new(api_type: :accounting).post(API_PATH_MAP[:update], payload)
      raise ArgumentError.new(result["Error"]) unless result['Success']

      result['Result'] #ID
    end

    def self.delete(id)
      result = connection.get(API_PATH_MAP[:delete], {id: id})

      raise ArgumentError.new(result["Error"]) unless result['Success']

      result['Result'] #true | false
    end

    def delete
      Customer.delete(self.id)
    end
    private

    def self.connection
      Connection.new(api_type: :accounting)
    end
  end
end
