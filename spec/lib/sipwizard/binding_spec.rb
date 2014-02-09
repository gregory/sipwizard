require 'spec_helper'

describe Sipwizard::Binding do
  describe '.count' do
    subject{ described_class.count }

    it 'returns the nb of account bindings' do
      expect(subject).to be_instance_of Fixnum
    end
  end

  describe '.find(id)' do
    let(:id){ settings['sensitive_data']['ACCOUNT_BINDING_ID'] }

    subject{ described_class.find(id) }

    it 'returns an account binding' do
      subject.should be_instance_of Sipwizard::Binding
      subject.id.should eq id
    end
  end
end
