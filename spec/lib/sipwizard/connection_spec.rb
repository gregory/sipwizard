require 'spec_helper'

describe Sipwizard::Connection do
  let(:default_faraday_adapter) { Faraday::Adapter::NetHttp }
  subject{ Sipwizard::Connection.new }

  it 'returns a Faraday::Connection with the nethttp adapter' do
    subject.faraday_connection.must_be_instance_of Faraday::Connection
    subject.faraday_connection.builder.handlers.must_include default_faraday_adapter
  end

  describe '.uri_for_path' do
    let(:path){ 'bar' }
    subject{ Sipwizard::Connection.uri_for_path(path) }

    it "returns the base_uri of the api" do
      subject.must_equal "#{Sipwizard::Connection::API_PATH}#{path}"
    end
  end

  describe 'get(params)' do
    let(:params){ { foo: 'bar' } }
    let(:path){ '/path' }
    let(:uri){ Sipwizard::Connection.uri_for_path(path) }
    let(:faraday_connection) { Minitest::Mock.new }
    let(:connection) do
      Sipwizard::Connection.new.tap do |connection|
        connection.faraday_connection = faraday_connection
      end
    end

    subject { connection.get(path, params) }

    it 'calls connection.get with the right uri' do
      response =  Minitest::Mock.new
      faraday_connection.expect :get, response, [uri, params]
      subject
      faraday_connection.verify
    end
  end
end
