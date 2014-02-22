require 'spec_helper'

describe Sipwizard::DialPlan do
  describe '.count(params={})' do
    subject{ described_class.count }
    it 'returns a result' do
      expect(subject).to be_instance_of Fixnum
    end
  end

  describe '.find(id)' do
    let(:id){ settings['sensitive_data']['DIALPLAN_ID'] }

    subject{ described_class.find(id) }

    it 'returns an account' do
      subject.should be_instance_of Sipwizard::DialPlan
      subject.id.should eq id
    end
  end

  describe '.create(params)' do
    let(:params) do
      {
        dial_plan_name: "foo",
        dial_plan_script: "sys.Dial(\"music@iptel.org\"); sys.Respond(404, \"No one home\")"
      }
    end

    subject{ described_class.create(params) }

    it 'creates a new dial_plan' do
      response = subject
      expect(response).not_to be_nil
      expect(response).to be_instance_of String
      expect(response).to match(/(?:\w|-)+/)
    end

    context 'if the username already exists' do
      #it 'raise an argument error' do
        #expect do
          #described_class.create(params)
          #described_class.create({username: 'foo', password: 'bra'})
        #end.to raise_exception(ArgumentError)
      #end
    end
  end
end
