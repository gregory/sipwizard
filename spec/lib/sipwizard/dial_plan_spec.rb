require 'spec_helper'

describe Sipwizard::DialPlan do
  describe '.count(params={})' do
    subject{ described_class.count }
    it 'returns a result' do
      expect(subject).to be_instance_of Fixnum
    end
  end

  describe '.find(id)' do
    let(:id){ settings['sensitive_data']['DIALPLAN_ID'] }

    subject{ described_class.find(id) }

    it 'returns an account' do
      subject.should be_instance_of Sipwizard::DialPlan
      subject.id.should eq id
    end
  end
end
