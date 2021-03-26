require 'spec_helper'

RSpec.describe FakeRedis::Commands::TransactionStart do
  describe '#call' do
    let(:store) { FakeRedis::Store.new }

    it 'calls the begin_transaction in the store' do
      expect(store).to receive(:begin_transaction)

      described_class.call(store)
    end
  end
end
