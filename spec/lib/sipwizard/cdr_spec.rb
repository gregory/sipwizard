require 'spec_helper'

describe Sipwizard::Cdr do
  describe '.count' do
    subject{ described_class.count }
    it 'returns a result' do
      expect(subject).to be_instance_of Fixnum
    end
  end

  describe '.find(id)' do
    let(:id){ settings['sensitive_data']['CDR_ID'] }

    subject{ described_class.find(id) }

    it 'returns an account' do
      subject.should be_instance_of Sipwizard::Cdr
      subject.id.should eq id
    end
  end
end
