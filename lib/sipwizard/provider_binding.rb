module Sipwizard
  class ProviderBinding < Hashie::Trash
    API_PATH_MAP={
      count: 'sipproviderbinding/count',
      find: 'sipproviderbinding/get'
    }

    string_to_bool = ->(string) { string == "true" }

    property :id,                          from: :ID
    property :provider_id,                 from: :ProviderID
    property :provider_name,               from: :ProviderName
    property :registration_failur_message, from: :RegistrationFailureMessage
    property :last_register_time,          from: :LastRegisterTime
    property :next_registration_time,      from: :NextRegistrationTime
    property :last_register_attempt,       from: :LastRegisterAttempt
    property :is_registered,               from: :IsRegistered, transform_with: ->(b) { string_to_bool.call(b) }
    property :binding_expiry,              from: :BindingExpiry
    property :binding_uri,                 from: :BindingURI
    property :registrar_sip_socket,        from: :RegistrarSIPSocket
    property :cseq,                        from: :CSeq

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

    def self.find_by_provider_id(id)
      relation = self.where({ ProviderID: id }).count(1)

      result = Connection.new.get(API_PATH_MAP[:find], relation.relation)

      return nil unless result['Success']

      self.new(result['Result'][0])
    end
  end
end
