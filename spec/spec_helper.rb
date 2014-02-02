require 'rubygems'
require 'bundler/setup'
Bundler.require(:test)

require_relative '../lib/sipwizard'
$LOAD_PATH <<  File.dirname(__FILE__)

RSpec.configure do |config|
  config.before :suite do
    Sipwizard.configure do |sip_config|
      sip_config.api_key = settings['sensitive_data']['SIPSORCERY_API_KEY']
    end
  end

  def settings
    @settings ||= YAML::load_file(File.join(File.dirname(File.expand_path(__FILE__)), 'spec.yml'))
  end
end

VCR.configure do |config|
  config.cassette_library_dir = "spec/vcr"
  config.hook_into :faraday
  config.default_cassette_options = { serialize_with: :psych , record: :none}

  settings['sensitive_data'].each do |k, v|
    config.filter_sensitive_data("<#{k}>"){ |interactive| v }
  end

  config.around_http_request do |request|
    case request.uri
    when Regexp.new(Sipwizard::Connection::API_PATH)
      #endpoint_test = /rest/v0.1/provisioning.svc/cdr/count" => cdr/count
      endpoint_test = URI(request.uri).path.split("/rest/v0.1/provisioning.svc/").last
      vcr_options = { match_requests_on: [:method, :path, :body, :headers, :query], allow_playback_repeats: true }

      VCR.use_cassette("sipsorcery/#{endpoint_test}", vcr_options, &request)
    end
  end
end
