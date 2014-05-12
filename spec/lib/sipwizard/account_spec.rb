require 'spec_helper'

describe Sipwizard::Account do
  describe '.count(params={})' do
    subject{ described_class.count }
    it 'returns a result' do
      expect(subject).to be_instance_of Fixnum
    end
  end

  describe '.find(id)' do
    let(:id){ settings['sensitive_data']['ID'] }

    subject{ described_class.find(id) }

    it 'returns an account' do
      subject.should be_instance_of Sipwizard::Account
      subject.id.should eq id
    end
  end

  describe '.first_by(args)' do
    let(:id){ settings['sensitive_data']['ID'] }

    subject{ described_class.first_by({ 'ID' => id }) }

    it 'returns an account' do
      subject.should be_instance_of Sipwizard::Account
      subject.id.should eq id
    end
  end

  #TOOD: add more specs
  describe '.first_x_by(args)' do
    let(:id){ settings['sensitive_data']['ID'] }
    let(:count){ 1 }

    subject{ described_class.first_x_by({ 'ID' => id, count: 1 }) }

    it 'returns an account' do
      subject.should be_instance_of Array
      account = subject.first
      account.should be_instance_of Sipwizard::Account
      account.id.should eq id
    end
  end

  describe '.create(params)' do
    let(:params) do
      {
        username: "foo",
        password: "bar"
      }
    end

    subject{ described_class.create(params) }

    it 'creates a new account' do
      response = subject
      expect(response).not_to be_nil
      expect(response).to be_instance_of String
      expect(response).to match(/(?:\w|-)+/)
    end

    context 'if the username already exists' do
      it 'raise an argument error' do
        expect do
          described_class.create(params)
          described_class.create({username: 'foo', password: 'bra'})
        end.to raise_exception(ArgumentError)
      end
    end
  end

  describe '.save' do
    let(:id){ settings['sensitive_data']['ID'] }
    let(:account){ described_class.find(id) }

    before{ account.should be_instance_of Sipwizard::Account }

    subject{ account.save }

    it 'updates the account' do
      account.avatar_url = "foo"
      response = subject
      expect(response).not_to be_nil
      expect(response).to be_instance_of String
      expect(response).to match(/(?:\w|-)+/)
    end
  end

  describe 'delete' do
    let(:id){ settings['sensitive_data']['ID'] }

    let(:account){ described_class.find(id) }

    before{ account.should be_instance_of Sipwizard::Account }

    subject{ account.delete }

    it 'delete the account' do
      response = subject
      expect(response).to be_true
    end
  end
end
