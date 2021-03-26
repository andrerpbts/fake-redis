module FakeRedis
  class Command
    AVAILABLE_COMMANDS = {
      'SET' => Commands::Set,
      'GET' => Commands::Get,
      'UNSET' => Commands::Unset,
      'NUMEQUALTO' => Commands::NumEqualTo,
      'BEGIN' => Commands::TransactionStart,
      'COMMIT' => Commands::CommitAllTransactions,
      'ROLLBACK' => Commands::RollbackCurrentTransaction,
      'END' => Commands::Terminate
    }.freeze

    COMMAND_ALIASES = {
      'BEGIN' => %w[INIT],
      'COMMIT' => %w[SAVE],
      'END' => %w[EXIT BYE QUIT],
      'ROLLBACK' => %w[STOP UNDO]
    }.freeze

    def self.call(store, command, *args)
      command = alias_for(command.to_s.upcase)
      command_klazz = AVAILABLE_COMMANDS[command]

      if command_klazz
        command_klazz.call(store, *args)
      else
        raise InvalidCommand, "Unrecognized command: #{command}"
      end
    end

    private

    def self.alias_for(command)
      @aliases ||= COMMAND_ALIASES.invert.inject({}) do |result, (aliases, real_command)|
        aliases.each { |a| result[a] = real_command }

        result
      end

      @aliases.fetch(command, command)
    end
  end
end
