require 'spec_helper'

describe Sipwizard::Configuration do
  describe '.new' do
    subject{ Sipwizard::Configuration.new(api_key, connection_params) }

    let(:api_key){ 'foo' }
    let(:connection_params){ 'bar' }

    it 'has a api_key' do
      subject.api_key.should eq api_key
    end

    it 'has a connection_params' do
      subject.connection_params.should eq connection_params
    end
  end
end
