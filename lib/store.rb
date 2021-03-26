module FakeRedis
  class Store
    attr_reader :current_transaction

    def initialize(initial_data = {})
      @data = [initial_data]
      @current_transaction = 0
    end

    def list
      @data.reduce(&:merge).freeze
    end

    def get(key)
      list[key.to_s.to_sym] || 'NULL'
    end

    def set(key, value)
      current_data[key.to_s.to_sym] = value

      'OK'
    end

    def begin_transaction
      @current_transaction += 1
      @data << {}

      'TRANSACTION INITIATED'
    end

    def commit_transactions
      raise NoTransactionError, 'NO TRANSACTION' if current_transaction.zero?

      @current_transaction = 0
      @data = [list]

      'SAVED'
    end

    def rollback_transaction
      raise NoTransactionError, 'NO TRANSACTION' if current_transaction.zero?

      @current_transaction -= 1
      @data.pop

      'TRANSACTION REVERTED'
    end

    private

    def current_data
      @data[current_transaction]
    end
  end
end
