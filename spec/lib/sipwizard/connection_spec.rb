require 'spec_helper'

describe Sipwizard::Connection do
  let(:default_faraday_adapter) { Faraday::Adapter::NetHttp }
  subject{ Sipwizard::Connection.new }

  it 'returns a Faraday::Connection with the nethttp adapter' do
    subject.faraday_connection.must_be_instance_of Faraday::Connection
    subject.faraday_connection.builder.handlers.must_include default_faraday_adapter
  end

  describe 'base_uri' do
    subject{ Sipwizard::Connection.new.base_uri }
    let(:base_uri) { Sipwizard::Connection::BASE_URI }

    it "returns the base_uri of the api" do
      subject.must_equal base_uri
    end
  end
end
