require 'spec_helper'

RSpec.describe FakeRedis::Server do
  describe '#resolve' do
    let(:store) { FakeRedis::Store.new }
    let(:server) { described_class.new(store: store) }

    context 'when passing a valid command to it' do
      it 'delegates to the command class to handle the request' do
        entry = 'numequalto 10'

        expect(FakeRedis::Command)
          .to receive(:call)
          .with(
            store,
            'numequalto',
            '10'
          )

        server.resolve(entry)
      end
    end

    context 'when passing an invalid' do
      it 'returns that the command does not exist' do
        entry = 'invalid 123'

        expect(server.resolve(entry)).to eq('Unrecognized command: INVALID')
      end
    end

    context 'when interrupting the server' do
      it 'stops it from running' do
        entry = 'exit'

        expect(server.resolve(entry)).to eq('BYE')
        expect(server).not_to be_running
      end
    end

    context 'when doing commit/rollback without an open transaction' do
      it 'returns that server does not have transaction' do
        %w[commit rollback].each do |entry|
          expect(server.resolve(entry)).to eq('NO TRANSACTION')
        end
      end
    end
  end

  describe '#prompt' do
    context 'when not telling it a name' do
      let(:server) { described_class.new }

      it { expect(server.prompt).to eq ('local> ') }
    end

    context 'when giving it a name' do
      let(:server) { described_class.new(name: 'teaserface') }

      it { expect(server.prompt).to eq ('teaserface> ') }
    end

    context 'when there are open transactions' do
      let(:server) { described_class.new(name: 'teaserface') }

      before do
        3.times { server.resolve('begin') }
      end

      it { expect(server.prompt).to eq ('teaserface [3]> ') }
    end
  end
end
