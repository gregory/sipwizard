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

  describe '.find(id)' do
    let(:id){ settings['sensitive_data']['CUSTOMER_ID'] }

    subject{ described_class.find(id) }

    it 'returns an account' do
      subject.should be_instance_of Sipwizard::Customer
      subject.id.should eq id
    end
  end

  describe '.save' do
    let(:id){ settings['sensitive_data']['CUSTOMER_ID'] }
    let(:customer){ described_class.find(id) }

    before{ customer.should be_instance_of Sipwizard::Customer }

    subject{ customer.save }

    it 'updates the account' do
      customer.pin = "1234"
      response = subject
      expect(response).not_to be_nil
      expect(response).to be_instance_of String
      expect(response).to match(/(?:\w|-)+/)
    end
  end

  describe 'delete' do
    let(:id){ settings['sensitive_data']['CUSTOMER_ID'] }

    let(:customer){ described_class.find(id) }

    before{ customer.should be_instance_of Sipwizard::Customer }

    subject{ customer.delete }

    it 'delete the customer' do
      response = subject
      expect(response).to be_true
    end
  end
end
