require 'spec_helper'

RSpec.describe FakeRedis::Commands::RollbackCurrentTransaction do
  describe '#call' do
    let(:store) { FakeRedis::Store.new }

    it 'calls the rollback_transaction in the store' do
      expect(store).to receive(:rollback_transaction)

      described_class.call(store)
    end
  end
end
