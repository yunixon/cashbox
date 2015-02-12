require 'spec_helper'

describe BankAccount do
  context "association" do
    it { should belong_to(:organization) }
    it { should have_many(:transactions).dependent(:destroy)}
  end

  context "validation" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:currency) }
    it { should ensure_inclusion_of(:currency).in_array(%w(USD RUB)) }

    context 'custom' do
      it_behaves_like "has money ceiling", 'balance' do
        let(:max)    { Transaction::AMOUNT_MAX }
        let!(:model) { build :bank_account, balance: amount }
      end
    end
  end
end
