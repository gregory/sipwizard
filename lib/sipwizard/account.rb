require 'active_support/core_ext/string/inflections'

module Sipwizard
  class Account < Hashie::Trash
    API_PATH_MAP ={
      count: 'sipaccount/count',
      find:  'sipaccount/get',
      create: 'sipaccount/add',
      update: 'sipaccount/update',
      delete: 'sipaccount/delete'
    }

    string_to_bool = ->(string) { string == "true" }

    property :id,                      from: :ID
    property :domain,                  from: :SIPDomain
    property :username,                from: :SIPUsername, required: true
    property :password,                from: :SIPPassword,required: true
    property :account_code,            from: :AccountCode
    property :avatar_url,              from: :AvatarURL
    property :description,             from: :Description
    property :dont_mangle_enabled,     from: :DontMangleEnabled,    transform_with: ->(b) { string_to_bool.call(b) }
    property :ip_address_acl,          from: :IPAddressACL
    property :in_dial_plan_name,       from: :InDialPlanName
    property :is_incoming_only,        from: :IsIncomingOnly,       transform_with: ->(b) { string_to_bool.call(b) }
    property :is_switch_board_enabled, from: :IsSwitchboardEnabled, transform_with: ->(b) { string_to_bool.call(b) }
    property :is_user_disabled,        from: :IsUserDisabled,       transform_with: ->(b) { string_to_bool.call(b) }
    property :network_id,              from: :NetworkID
    property :out_dial_plan_name,      from: :OutDialPlanName
    property :send_nat_keep_alives,    from: :SendNATKeepAlives,    transform_with: ->(b) { string_to_bool.call(b) }

    alias :dont_mangle? :dont_mangle_enabled
    alias :incoming_only? :is_incoming_only
    alias :switch_board_enabled? :is_switch_board_enabled
    alias :user_disabled? :is_user_disabled
    alias :send_nat_keep_alives? :send_nat_keep_alives

    def self.build_for_request(h)
      account = self.new(h)
      account = Hash[account.map{ |k,v| ["#{k}".camelize, v] }]
      account['ID']                = account.delete('Id')
      account['SIPDomain']         = account.delete('Domain')
      account['SIPUsername']       = account.delete('Username')
      account['SIPPassword']       = account.delete('Password')
      account['IPAddressACL']      = account.delete('IpAddressAcl')
      account['AvatarURL']         = account.delete('AvatarUrl')
      account['NetworkID']         = account.delete('NetworkId')
      account['SendNATKeepAlives'] = account.delete('SendNatKeepAlives')

      account.delete_if{ |_,v| v.nil? } #delete all the keys for which we dont have value
    end

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

    def self.first_by(args)
      relation = self.where(args).count(1)
      result = Connection.new.get(API_PATH_MAP[:find], relation.relation)

      return nil unless result['Success']

      self.new(result['Result'][0])
    end

    def self.first_x_by(args)
      count = args.delete(:count)
      relation = self.where(args).count(count)
      result = Connection.new.get(API_PATH_MAP[:find], relation.relation)

      return nil unless result['Success']

      result['Result'].map{ |r| self.new(r) }
    end

    def self.create(params)
      payload = self.build_for_request(params)
      result = Connection.new.post(API_PATH_MAP[:create], payload)

      raise ArgumentError.new(result["Error"]) unless result['Success']

      result['Result'] #ID
    end

    def self.delete(id)
      result = Connection.new.get(API_PATH_MAP[:delete], {id: id})

      raise ArgumentError.new(result["Error"]) unless result['Success']

      result['Result'] #true | false
    end

    def save
      payload = Account.build_for_request(self.to_hash)
      result = Connection.new.post(API_PATH_MAP[:update], payload)
      raise ArgumentError.new(result["Error"]) unless result['Success']

      result['Result'] #ID
    end

    def delete
      Account.delete(self.id)
    end
  end
end
