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
end
