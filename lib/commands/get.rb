module FakeRedis
  module Commands
    class Get
      def self.call(store, *args)
        key = args.first

        store.get(key)
      end
    end
  end
end
