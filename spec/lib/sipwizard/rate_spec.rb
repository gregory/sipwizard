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
end
