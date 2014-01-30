Dir[File.dirname(__FILE__) + '/sipwizard/*.rb'].each{ |file| require file }

module Sipwizard
  extend self
end
