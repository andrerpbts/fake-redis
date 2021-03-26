require 'spec_helper'

RSpec.describe FakeRedis::Commands::Get do
  describe '#call' do
    let(:store) { FakeRedis::Store.new(foo: 'bar') }

    it 'retrieves the value from the store' do
      value = described_class.call(store, 'foo')

      expect(value).to eq('bar')
    end
  end
end
