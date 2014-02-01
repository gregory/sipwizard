require 'spec_helper'

describe Sipwizard do
  subject{ Sipwizard }

  describe '.configure' do
    let(:api_key){ 'johndoe_key' }

    before do
      subject.configure do |config|
        config.api_key = api_key
      end
    end

    it 'has set the api_key' do
      subject.config.api_key.should eq api_key
    end
  end
end
