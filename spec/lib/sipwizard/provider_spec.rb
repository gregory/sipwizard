require 'spec_helper'

describe Sipwizard::Provider do
  describe '.count' do
    subject{ described_class.count }

    it 'returns a result' do
      expect(subject).to be_instance_of Fixnum
    end
  end

  describe '.find(id)' do
    let(:id){ settings['sensitive_data']['PROVIDER_ID'] }

    subject{ described_class.find(id) }

    it 'returns an provider' do
      subject.should be_instance_of Sipwizard::Provider
      subject.id.should eq id
    end
  end

  describe '.create(params)' do
    let(:params) do
      {
        provider_name: "foo",
        provider_username: "bar",
        provider_password: 'provider_password',
        provider_server: 'provider_server',
        provider_type: 'provider_type',
        register_contact: 'register_contact'
      }
    end

    subject{ described_class.create(params) }

    it 'creates a new provider and return an id' do
      response = subject
      expect(response).not_to be_nil
      expect(response).to be_instance_of String
      expect(response).to match(/(?:\w|-)+/)
    end

    context 'if the username already exists' do
      it 'raise an argument error' do
        expect do
          described_class.create(params)
          described_class.create(params.merge({provider_username: 'bar', provider_password: 'bra'}))
        end.to raise_exception(ArgumentError)
      end
    end
  end

  describe '.save' do
    let(:id){ settings['sensitive_data']['PROVIDER_ID'] }
    let(:account){ described_class.find(id) }

    before{ account.should be_instance_of Sipwizard::Provider }

    subject{ account.save }

    it 'updates the account' do
      account.provider_name = "barbar"
      response = subject
      expect(response).not_to be_nil
      expect(response).to be_instance_of String
      expect(response).to match(/(?:\w|-)+/)
    end
  end

  describe 'delete' do
    let(:id){ settings['sensitive_data']['PROVIDER_ID'] }

    let(:account){ described_class.find(id) }

    before{ account.should be_instance_of Sipwizard::Provider }

    subject{ account.delete }

    it 'delete the account' do
      response = subject
      expect(response).to be_true
    end
  end
end
