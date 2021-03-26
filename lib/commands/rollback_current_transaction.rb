module FakeRedis
  module Commands
    class RollbackCurrentTransaction
      def self.call(store, *_args)
        store.rollback_transaction
      end
    end
  end
end
