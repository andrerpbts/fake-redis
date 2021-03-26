require 'spec_helper'

RSpec.describe 'Transactional integration tests' do
  let(:server) { FakeRedis::Server.new }

  context 'when doing several rollbacks' do
    it 'retrieves data correctly' do
      expect(server.resolve('begin')).to eq('TRANSACTION INITIATED')
      expect(server.resolve('set a 10')).to eq('OK')
      expect(server.resolve('get a')).to eq('10')
      expect(server.resolve('begin')).to eq('TRANSACTION INITIATED')
      expect(server.resolve('set a 20')).to eq('OK')
      expect(server.resolve('get a')).to eq('20')
      expect(server.resolve('rollback')).to eq('TRANSACTION REVERTED')
      expect(server.resolve('get a')).to eq('10')
      expect(server.resolve('rollback')).to eq('TRANSACTION REVERTED')
      expect(server.resolve('get a')).to eq('NULL')
      expect(server.resolve('end')).to eq('BYE')
    end
  end

  context 'when doing a rollback after a commit' do
    it 'retrieves data correctly' do
      expect(server.resolve('begin')).to eq('TRANSACTION INITIATED')
      expect(server.resolve('set a 30')).to eq('OK')
      expect(server.resolve('begin')).to eq('TRANSACTION INITIATED')
      expect(server.resolve('set a 40')).to eq('OK')
      expect(server.resolve('commit')).to eq('SAVED')
      expect(server.resolve('get a')).to eq('40')
      expect(server.resolve('rollback')).to eq('NO TRANSACTION')
      expect(server.resolve('end')).to eq('BYE')
    end
  end

  context 'when unsetting a key in a reverted transaction' do
    it 'retrieves data correctly' do
      expect(server.resolve('set a 50')).to eq('OK')
      expect(server.resolve('begin')).to eq('TRANSACTION INITIATED')
      expect(server.resolve('get a')).to eq('50')
      expect(server.resolve('set a 60')).to eq('OK')
      expect(server.resolve('begin')).to eq('TRANSACTION INITIATED')
      expect(server.resolve('unset a')).to eq('OK')
      expect(server.resolve('get a')).to eq('NULL')
      expect(server.resolve('rollback')).to eq('TRANSACTION REVERTED')
      expect(server.resolve('get a')).to eq('60')
      expect(server.resolve('commit')).to eq('SAVED')
      expect(server.resolve('get a')).to eq('60')
      expect(server.resolve('end')).to eq('BYE')
    end
  end

  context 'when using numequalto with transaction' do
    it 'retrieves data correctly' do
      expect(server.resolve('set a 10')).to eq('OK')
      expect(server.resolve('begin')).to eq('TRANSACTION INITIATED')
      expect(server.resolve('numequalto 10')).to eq(1)
      expect(server.resolve('begin')).to eq('TRANSACTION INITIATED')
      expect(server.resolve('unset a')).to eq('OK')
      expect(server.resolve('numequalto 10')).to eq(0)
      expect(server.resolve('rollback')).to eq('TRANSACTION REVERTED')
      expect(server.resolve('numequalto 10')).to eq(1)
      expect(server.resolve('commit')).to eq('SAVED')
      expect(server.resolve('end')).to eq('BYE')
    end
  end
end
