module Sipwizard
  class Cdr < Hashie::Trash
    API_PATH_MAP={
      count: 'cdr/count',
      find:  'cdr/get'
    }

    property :account_code, from: :AccountCode
    property :answered_reason,      from: :AnsweredReason
    property :answered_status,      from: :AnsweredStatus
    property :answered_time,        from: :AnsweredTime
    property :balance,              from: :Balance
    property :bridge_id,            from: :BridgeId
    property :call_direction,       from: :CallDirection
    property :call_id,              from: :CallId
    property :cost,                 from: :Cost
    property :created,              from: :Created
    property :dial_plan_context_id, from: :DialPlanContextID
    property :dst,                  from: :Dst
    property :dst_host,             from: :DstHost
    property :dst_uri,              from: :DstURI
    property :duration,             from: :Duration
    property :from_header,          from: :FromHeader
    property :from_name,            from: :FromName
    property :from_user,            from: :FromUser
    property :hungup_reason,        from: :HungupReason
    property :hungup_time,          from: :HungupTime
    property :id,                   from: :ID
    property :in_progress_reason,   from: :InProgressReason
    property :in_progress_status,   from: :InProgressStatus
    property :in_progress_time,     from: :InProgressTime
    property :increment_seconds,    from: :IncrementSeconds
    property :inserted,             from: :Inserted
    property :local_socket,         from: :LocalSocket
    property :rate,                 from: :Rate
    property :remote_socket,        from: :RemoteSocket
    property :ring_duration,        from: :RingDuration
    property :setup_cost,           from: :SetupCost

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
