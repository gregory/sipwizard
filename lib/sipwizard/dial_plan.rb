module Sipwizard
  class DialPlan < Hashie::Trash
    API_PATH_MAP= {
      count: 'dialplan/count',
      find: 'dialplan/get',
      create: 'dialplan/add'
    }

    string_to_bool = ->(string) { string == "true" }

    property :id,                      from: :ID
    property :dial_plan_name,          from: :DialPlanName
    property :trace_email_address,     from: :TraceEmailAddress
    property :dial_plan_script,        from: :DialPlanScript
    property :script_type_description, from: :ScriptTypeDescription
    property :accept_non_invite,       from: :AcceptNonInvite, transform_with: ->(b) { string_to_bool.call(b) }

    alias :accept_non_invite? :accept_non_invite

    def self.build_for_request(h)
      dial_plan = self.new(h)
      dial_plan = Hash[dial_plan.map{ |k,v| ["#{k}".camelize, v] }]
      dial_plan['ID'] = dial_plan.delete('Id')

      dial_plan.delete_if{ |_,v| v.nil? } #delete all the keys for which we dont have value
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

    def self.create(params)
      payload = self.build_for_request(params)
      result = Connection.new.post(API_PATH_MAP[:create], payload)

      raise ArgumentError.new(result["Error"]) unless result['Success']

      result['Result'] #ID
    end
  end
end
