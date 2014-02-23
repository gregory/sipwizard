require 'spec_helper'

describe Sipwizard::Rate do
  describe '.count(params={})' do
    subject{ described_class.count }
    it 'returns a result' do
      expect(subject).to be_instance_of Fixnum
    end
  end

  describe '.create(params)' do
    let(:params) do
      {
        description: "foo",
        prefix: "777",
        rate: 2.0,
        setup_cost: 0,
        increment_seconds: 1
      }
    end

    subject{ described_class.create(params) }

    it 'creates a new rate' do
      response = subject
      expect(response).not_to be_nil
      expect(response).to be_instance_of String
      expect(response).to match(/(?:\w|-)+/)
    end

    context 'if the prefix already exists' do
      it 'raise an argument error' do
        expect do
          described_class.create(params)
          described_class.create({description: 'bar', prefix: "777", rate: 1.0, setup_cost: 0, increment_seconds: 1})
        end.to raise_exception(ArgumentError)
      end
    end
  end

  describe '.find(id)' do
    let(:id){ settings['sensitive_data']['RATE_ID'] }

    subject{ described_class.find(id) }

    it 'returns an account' do
      subject.should be_instance_of Sipwizard::Rate
      subject.id.should eq id
    end
  end

  describe '.save' do
    let(:id){ settings['sensitive_data']['RATE_ID'] }
    let(:rate){ described_class.find(id) }

    before{ rate.should be_instance_of Sipwizard::Rate }

    subject{ rate.save }

    it 'updates the rate' do
      rate.prefix = "1234"
      response = subject
      expect(response).not_to be_nil
      expect(response).to be_instance_of String
      expect(response).to match(/(?:\w|-)+/)
    end
  end
end
