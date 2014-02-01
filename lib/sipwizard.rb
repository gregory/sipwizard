require 'rack'
require 'hashie'
Dir[File.dirname(__FILE__) + '/sipwizard/*.rb'].each{ |file| require file }

module Sipwizard
  HTTP_STATUS_CODES = Rack::Utils::HTTP_STATUS_CODES.invert
  extend self

  attr_accessor :config

  def configure
    @config = Configuration.new.tap{ |configuration| yield(configuration) }
  end
end
