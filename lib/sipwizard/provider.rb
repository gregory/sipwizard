module Sipwizard
  class Provider < Hashie::Trash
    API_PATH_MAP = {
      count: 'sipprovider/count'
    }

    string_to_bool = ->(string) { string == "true" }

    property :id,                       from: :ID
    property :provider_name,            from: :ProviderName
    property :provider_username,        from: :ProviderUsername
    property :provider_password,        from: :ProviderPassword
    property :provider_server,          from: :ProviderServer
    property :provider_auth_username,   from: :ProviderAuthUsername
    property :provider_out_bound_proxy, from: :ProviderOutboundProxy
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

    def self.count(params={})
      response = Connection.new.get(API_PATH_MAP[:count], params)

      response['Success'] ? response['Result'] : -1
    end
  end
end
