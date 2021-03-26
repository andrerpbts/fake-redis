module FakeRedis
  module Commands
    class NumEqualTo
      def self.call(store, *args)
        value = args.first

        store.list.values.select { |v| v == value }.length
      end
    end
  end
end
