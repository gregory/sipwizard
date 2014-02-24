module Sipwizard
  class Provider < Hashie::Trash
    API_PATH_MAP = {
      count: 'sipprovider/count',
      find: 'sipprovider/get',
      create: 'sipprovider/add',
      update: 'sipprovider/update',
      delete: 'sipprovider/delete'
    }

    string_to_bool = ->(string) { string == "true" }

    property :id,                       from: :ID
    property :provider_name,            from: :ProviderName
    property :provider_username,        from: :ProviderUsername
    property :provider_password,        from: :ProviderPassword
    property :provider_server,          from: :ProviderServer
    property :provider_auth_username,   from: :ProviderAuthUsername
    property :provider_outbound_proxy,  from: :ProviderOutboundProxy
    property :provider_type,            from: :ProviderType
    property :provider_from,            from: :ProviderFrom
    property :custom_headers,           from: :CustomHeaders
    property :register_contact,         from: :RegisterContact
    property :register_expiry,          from: :RegisterExpiry
    property :register_server,          from: :RegisterServer
    property :register_realm,           from: :RegisterRealm
    property :register_enabled,         from: :RegisterEnabled, transform_with: ->(b) { string_to_bool.call(b) }
    property :gv_callback_number,       from: :GVCallbackNumber
    property :gv_callback_pattern,      from: :GVCallbackPattern
    property :gv_callback_type,         from: :GVCallbackType

    alias :register_enabled? :register_enabled

    def self.count(params={})
      response = Connection.new.get(API_PATH_MAP[:count], params)

      response['Success'] ? response['Result'] : -1
    end

    def self.where(params)
      Relation.new.where(params)
    end

    def self.find(id)
      relation = self.where({ ID: id }).count(1)

      result = Connection.new.get(API_PATH_MAP[:find], relation.relation)

      return nil unless result['Success']

      self.new(result['Result'][0])
    end

    def self.build_for_request(h)
      provider = self.new(h)
      provider = Hash[provider.map{ |k,v| ["#{k}".camelize, v] }]
      provider['ID']                = provider.delete('Id')
      provider['GVCallbackType']    = provider.delete('GvCallbackType')
      provider['GVCallbackNumber']    = provider.delete('GvCallbackType')
      provider['GVCallbackPattern']    = provider.delete('GvCallbackPattern')

      provider.delete_if{ |_,v| v.nil? } #delete all the keys for which we dont have value
    end

    def self.create(params)
      payload = self.build_for_request(params)
      result = Connection.new.post(API_PATH_MAP[:create], payload)

      raise ArgumentError.new(result["Error"]) unless result['Success']

      result['Result'] #ID
    end

    def save
      payload = Provider.build_for_request(self.to_hash)
      result = Connection.new.post(API_PATH_MAP[:update], payload)
      raise ArgumentError.new(result["Error"]) unless result['Success']

      result['Result'] #ID
    end

    def binding(cache=true)
      return @binding if @binding && cache
      @binding = ProviderBinding.find_by_provider_id(self.id)
    end

    def self.delete(id)
      result = Connection.new.get(API_PATH_MAP[:delete], {id: id})

      raise ArgumentError.new(result["Error"]) unless result['Success']

      result['Result'] #true | false
    end

    def delete
      Provider.delete(self.id)
    end
  end
end
