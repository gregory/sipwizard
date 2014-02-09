require 'spec_helper'

describe Sipwizard::Binding do
  describe '.count' do
    subject{ described_class.count }

    it 'returns the nb of account bindings' do
      expect(subject).to be_instance_of Fixnum
    end
  end
end
