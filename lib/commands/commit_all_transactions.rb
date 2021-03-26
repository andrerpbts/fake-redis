module FakeRedis
  module Commands
    class CommitAllTransactions
      def self.call(store, *_args)
        store.commit_transactions
      end
    end
  end
end
