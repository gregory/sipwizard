require 'spec_helper'

describe Sipwizard::Account do
  describe '.count(params={})' do
    subject{ described_class.count }
    it 'returns a result' do
      expect(subject).to be_instance_of Fixnum
    end
  end

  describe '.find(username)' do
    let(:username){ settings['sensitive_data']['SIPUsername'] }

    subject{ described_class.find(username) }

    it 'returns an account' do
      subject.should be_instance_of Sipwizard::Account
    end
  end

  describe '.create(params)' do
    let(:params) do
      {
        username: "foo",
        password: "bar"
      }
    end

    subject{ described_class.create(params) }

    it 'creates a new account' do
      response = subject
      expect(response).not_to be_nil
      expect(response).to be_instance_of String
      expect(response).to match(/(?:\w|-)+/)
    end

    context 'if the username already exists' do
      it 'raise an argument error' do
        expect do
          described_class.create(params)
          described_class.create({username: 'foo', password: 'bra'})
        end.to raise_exception(ArgumentError)
      end
    end
  end
end
