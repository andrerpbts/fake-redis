require 'spec_helper'

RSpec.describe FakeRedis::Commands::Terminate do
  describe '#call' do
    let(:store) { FakeRedis::Store.new }

    it 'raises SessionEnded error' do
      expect{ described_class.call(store) }
        .to raise_error(FakeRedis::SessionEnded)
    end
  end
end
