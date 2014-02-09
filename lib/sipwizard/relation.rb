module Sipwizard
  class Relation
    attr_reader :relation

    def initialize
      @relation = Hashie::Clash.new
    end

    def where(params)
      @relation.where( hash_to_query(params) )
      self
    end

    def count(nb)
      @relation.merge!({count: nb})
      self
    end

    private

    #Hack to comply with the api spec ... which sucks
    def hash_to_query(h)
      h = Hash[h.map{|k,v| [k, "\"#{v}\""]}]
      Rack::Utils.unescape Rack::Utils.build_query(h)
    end
  end
end
