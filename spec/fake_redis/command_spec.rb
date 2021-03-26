require 'spec_helper'

RSpec.describe FakeRedis::Command do
  describe '#call' do
    let(:store) { FakeRedis::Store.new }

    context 'when giving a real command name' do
      [
        [FakeRedis::Commands::Set, 'set', 'a', '10'],
        [FakeRedis::Commands::Get, 'get', 'a'],
        [FakeRedis::Commands::Unset, 'unset', 'a'],
        [FakeRedis::Commands::TransactionStart, 'begin']
      ].each do |(command_klazz, command, *args)|
        it "calls the #{command_klazz} with correct params" do
          expect(command_klazz)
            .to receive(:call)
            .with(store, *args)

          described_class.call(store, command, *args)
        end
      end
    end

    context 'when calling the command END' do
      subject(:quit) { described_class.call(store, 'end') }

      it 'raises SessionEnded error' do
        expect{ quit }.to raise_error(FakeRedis::SessionEnded)
      end
    end

    context 'when calling an alias command' do
      [
        [FakeRedis::Commands::TransactionStart, 'init'],
        [FakeRedis::Commands::Terminate, 'bye'],
        [FakeRedis::Commands::CommitAllTransactions, 'save'],
      ].each do |(command_klazz, command)|
        it "correctly calls the #{command_klazz}" do
          expect(command_klazz)
            .to receive(:call)

          described_class.call(store, command)
        end
      end
    end

    context 'when calling an inexistent command' do
      subject(:call_command) { described_class.call(store, 'invalid') }

      it 'raises InvalidCommand error' do
        expect{ call_command }
          .to raise_error(FakeRedis::InvalidCommand, /INVALID/)
      end
    end
  end
end
