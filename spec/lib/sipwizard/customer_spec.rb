require 'spec_helper'

describe Sipwizard::Customer do
  describe '.count(params={})' do
    subject{ described_class.count }
    it 'returns a result' do
      expect(subject).to be_instance_of Fixnum
    end
  end

  describe '.create(params)' do
    let(:params) do
      {
        account_name: "foo",
        credit: 4.0
      }
    end

    subject{ described_class.create(params) }

    it 'creates a new account' do
      response = subject
      expect(response).not_to be_nil
      expect(response).to be_instance_of String
      expect(response).to match(/(?:\w|-)+/)
    end

    context 'if the account_name already exists' do
      it 'raise an argument error' do
        expect do
          described_class.create(params)
          described_class.create({account_name: 'foo', credit: 3.0})
        end.to raise_exception(ArgumentError)
      end
    end
  end
end
