Dir[File.dirname(__FILE__) + '/sipwizard/*.rb'].each{ |file| require file }

module Sipwizard
  extend self

  attr_accessor :config

  def configure
    @config = Configuration.new.tap{ |configuration| yield(configuration) }
  end
end
