module FakeRedis
  class InvalidCommand < StandardError; end
  class NoTransactionError < StandardError; end
  class SessionEnded < StandardError; end
end
