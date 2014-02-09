module Sipwizard
  class Binding < Hashie::Trash
    API_PATH_MAP={
      count: 'sipaccountbinding/count',
      find:  'sipaccountbinding/get'
    }

    property :id,                   from: :ID
    property :contact_udi,          from: :ContactURI
    property :expiry,               from: :Expiry
    property :expiry_time,          from: :ExpiryTime
    property :last_update,          from: :LastUpdate
    property :mangled_contact_uri,  from: :MangledContactURI
    property :proxy_sip_socket,     from: :ProxySIPSocket
    property :registrat_sip_socket, from: :RegistrarSIPSocket
    property :remote_sip_socket,    from: :RemoteSIPSocket
    property :account_id,           from: :SIPAccountID
    property :account_name,         from: :SIPAccountName
    property :user_agent,           from: :UserAgent

    def self.count
      response = Connection.new.get(API_PATH_MAP[:count])

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
  end
end
