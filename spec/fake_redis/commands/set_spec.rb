require 'spec_helper'

RSpec.describe FakeRedis::Commands::Set do
  describe '#call' do
    let(:store) { FakeRedis::Store.new }

    it 'clears the key/value from the store' do
      described_class.call(store, 'foo', 'bar')

      expect(store.list).to eq(foo: 'bar')
    end
  end
end
