require 'spec_helper'

RSpec.describe 'Basic integration tests' do
  let(:server) { FakeRedis::Server.new }

  context 'when using set/get/unset' do
    before do
      server.resolve('set a 10')
      server.resolve('set b 20')
      server.resolve('unset a 10')
    end

    it 'retrieves data correctly' do
      expect(server.resolve('get a')).to eq('NULL')
      expect(server.resolve('get b')).to eq('20')
    end
  end

  context 'when using numequalto' do
    before do
      server.resolve('set a 10')
      server.resolve('set b 20')
      server.resolve('set c 10')
      server.resolve('set d 10')
    end

    it 'stores and reads data correctly' do
      expect(server.resolve('numequalto 10')).to eq(3)
      expect(server.resolve('numequalto 20')).to eq(1)
    end
  end
end
