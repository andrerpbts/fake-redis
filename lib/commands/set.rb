module FakeRedis
  module Commands
    class Set
      def self.call(store, *args)
        key, value = args

        store.set(key, value)
      end
    end
  end
end
