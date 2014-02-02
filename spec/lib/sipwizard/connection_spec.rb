require 'spec_helper'

describe Sipwizard::Connection do
  let(:default_faraday_adapter) { Faraday::Adapter::NetHttp }
  subject{ described_class.new }

  it 'returns a Faraday::Connection with the nethttp adapter' do
    subject.faraday_connection.should be_instance_of Faraday::Connection
    subject.faraday_connection.builder.handlers.should include(default_faraday_adapter)
  end

  describe '#get(params)' do
    subject{ described_class.new.get('cdr/count') }

    context 'when the api key is valid' do
      it 'doesnt complain' do
        expect(subject["Error"]).to be_nil
        expect(subject["Success"]).to be_true
      end
    end

    context 'when the api key is invalid' do
      let(:connection){ described_class.new }
      subject{ connection.get('cdr/count') }
      before do
        connection.faraday_connection.headers['apikey'] = 'bar'
      end

      it 'returns an error' do
        expect(subject["Error"]).not_to be_nil
        expect(subject["Success"]).to be_false
      end
    end
  end
end
