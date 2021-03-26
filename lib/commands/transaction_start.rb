module FakeRedis
  module Commands
    class TransactionStart
      def self.call(store, *_args)
        store.begin_transaction
      end
    end
  end
end
