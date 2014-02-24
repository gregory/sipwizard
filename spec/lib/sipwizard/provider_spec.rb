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
    let(:provider){ described_class.find(id) }

    before{ provider.should be_instance_of Sipwizard::Provider }

    subject{ provider.save }

    it 'updates the provider' do
      provider.provider_name = "barbar"
      response = subject
      expect(response).not_to be_nil
      expect(response).to be_instance_of String
      expect(response).to match(/(?:\w|-)+/)
    end
  end

  describe 'delete' do
    let(:id){ settings['sensitive_data']['PROVIDER_ID'] }

    let(:provider){ described_class.find(id) }

    before{ provider.should be_instance_of Sipwizard::Provider }

    subject{ provider.delete }

    it 'delete the provider' do
      response = subject
      expect(response).to be_true
    end
  end

  describe 'binding(cache=true)' do
    let(:id){ settings['sensitive_data']['PROVIDER_ID'] }

    let(:provider){ described_class.find(id) }

    before{ provider.should be_instance_of Sipwizard::Provider }

    subject{ provider.binding }

    it 'return the binding of a provider' do
      Sipwizard::ProviderBinding.should_receive(:find_by_provider_id).once.and_call_original
      expect(subject).to be_instance_of Sipwizard::ProviderBinding
      subject.provider_id.should eq provider.id
    end

    it 'can skip the cache response' do
      Sipwizard::ProviderBinding.should_receive(:find_by_provider_id).twice.and_call_original
      expect(subject).to be_instance_of Sipwizard::ProviderBinding
      provider.binding(false).provider_id.should eq provider.id
    end
  end
end
