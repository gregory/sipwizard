require 'spec_helper'

describe Sipwizard::Provider do
  describe '.count' do
    subject{ described_class.count }

    it 'returns a result' do
      expect(subject).to be_instance_of Fixnum
    end
  end
end
