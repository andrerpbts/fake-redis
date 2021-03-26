module FakeRedis
  module Commands
    class Terminate
      def self.call(_store, *_args)
        raise FakeRedis::SessionEnded
      end
    end
  end
end
