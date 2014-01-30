require 'rubygems'
require 'bundler/setup'
Bundler.require(:test)

require_relative '../lib/sipwizard'

require 'minitest/autorun'
require 'minitest/pride'

Turn.config do |c|
  c.format  = :outline
  c.natural = true
end

MiniTest::Spec.before :each do
  Sipwizard.configure do |config|
    config.api_key = 'default_api'
  end
end
