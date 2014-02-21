module Sipwizard
  class DialPlan < Hashie::Trash
    API_PATH_MAP= {
      count: 'dialplan/count',
      find: 'dialplan/get'
    }

    string_to_bool = ->(string) { string == "true" }

    property :id,                      from: :ID
    property :dialplan_name,           from: :DialPlanName
    property :trace_email_address,     from: :TraceEmailAddress
    property :dialplan_script,         from: :DialPlanScript
    property :script_type_description, from: :ScriptTypeDescription
    property :accept_non_invite,       from: :AcceptNonInvite, transform_with: ->(b) { string_to_bool.call(b) }

    alias :accept_non_invite? :accept_non_invite

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

  end
end
