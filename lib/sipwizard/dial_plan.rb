module Sipwizard
  class DialPlan < Hashie::Trash
    API_PATH_MAP= {
      count: 'dialplan/count'
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

  end
end
