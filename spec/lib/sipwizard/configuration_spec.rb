require 'spec_helper'

describe Sipwizard::Configuration do
  describe '.new' do
    subject{ Sipwizard::Configuration.new(api_key) }

    let(:api_key){ 'foo' }

    it 'has a api_key' do
      subject.api_key.must_equal api_key
    end
  end
end
