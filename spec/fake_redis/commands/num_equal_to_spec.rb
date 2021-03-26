require 'spec_helper'

RSpec.describe FakeRedis::Commands::NumEqualTo do
  describe '#call' do
    let(:store) { FakeRedis::Store.new(foo: 'bar', baz: 'bar') }

    it 'returns the amount times the value appears in the collection' do
      value = described_class.call(store, 'bar')

      expect(value).to eq(2)
    end
  end
end
