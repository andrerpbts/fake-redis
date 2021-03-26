require 'spec_helper'

RSpec.describe FakeRedis::Commands::CommitAllTransactions do
  describe '#call' do
    let(:store) { FakeRedis::Store.new }

    it 'calls the commit_transactions in the store' do
      expect(store).to receive(:commit_transactions)

      described_class.call(store)
    end
  end
end
