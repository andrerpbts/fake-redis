require 'spec_helper'

RSpec.describe FakeRedis::Commands::Unset do
  describe '#call' do
    let(:store) { FakeRedis::Store.new(foo: 'bar') }

    it 'stores the key/value in the store' do
      described_class.call(store, 'foo')

      expect(store.list).to eq(foo: nil)
    end
  end
end
