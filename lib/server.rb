module FakeRedis
  class Server
    def initialize(store: Store.new, name: 'local')
      @store = store
      @running = true
      @name = name
    end

    def resolve(entry)
      command, *args = entry.split

      Command.call(store, command, *args)
    rescue SessionEnded
      @running = false
      'BYE'
    rescue InvalidCommand, NoTransactionError => e
      e.message
    end

    def running?
      @running
    end

    def prompt
      transaction = store.current_transaction
      prompt_transaction = transaction > 0 && " [#{transaction}]" || ""

      "#{name}#{prompt_transaction}> "
    end

    private

    attr_accessor :store, :current_transaction, :name
  end
end
