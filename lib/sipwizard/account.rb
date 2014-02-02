module Sipwizard
  class Account < Hashie::Trash
    API_PATH_MAP ={
      count: 'sipaccount/count',
      find:  'sipaccount/get'
    }

    string_to_bool = ->(string) { string == "true" }

    property :ID
    property :SIPDomain
    property :SIPUsername, required: true
    property :SIPPassword,required: true
    property :account_code,            from: :AccountCode
    property :avatar_url,              from: :AvatarURL
    property :description,             from: :Description
    property :dont_mangle_enabled,     from: :DontMangleEnabled,    transform_with: ->(b) { string_to_bool.call(b) }
    property :IP_address_acl,          from: :IPAddressACL
    property :in_dial_plan_name,       from: :InDialPlanName
    property :is_incoming_only,        from: :IsIncomingOnly,       transform_with: ->(b) { string_to_bool.call(b) }
    property :is_switch_board_enabled, from: :IsSwitchboardEnabled, transform_with: ->(b) { string_to_bool.call(b) }
    property :is_user_disabled,        from: :IsUserDisabled,       transform_with: ->(b) { string_to_bool.call(b) }
    property :network_id,              from: :NetworkID
    property :out_dial_plan_name,      from: :OutDialPlanName
    property :send_nat_keep_alives,    from: :SendNATKeepAlives,    transform_with: ->(b) { string_to_bool.call(b) }

    alias :id :ID
    alias :username :SIPUsername
    alias :password :SIPPassword
    alias :domain   :SIPDomain
    alias :dont_mangle? :dont_mangle_enabled
    alias :incoming_only? :is_incoming_only
    alias :switch_board_enabled? :is_switch_board_enabled
    alias :user_disabled? :is_user_disabled
    alias :send_nat_keep_alives? :send_nat_keep_alives

    def self.count(params={})
      response = Connection.new.get(API_PATH_MAP[:count], params)

      response['Success'] ? response['Result'] : -1
    end

    def self.where(params)
      Relation.new.where(params)
    end

    def self.find(sip_username)
      relation = self.where({ SIPUsername: sip_username }).count(1)
      result = Connection.new.get(API_PATH_MAP[:find], relation.relation)

      return nil unless result['Success']

      self.new(result['Result'][0])
    end

    class Relation
      attr_reader :relation

      def initialize
        @relation = Hashie::Clash.new
      end

      def where(params)
        @relation.where(params)
        self
      end

      def count(nb)
        @relation.merge!({count: nb})
        self
      end
    end
  end
end
