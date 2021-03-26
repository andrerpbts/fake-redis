module FakeRedis
  module Commands
    class Unset
      def self.call(store, *args)
        key = args.first

        store.set(key, nil)
      end
    end
  end
end
