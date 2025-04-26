# frozen_string_literal: true

# Raised when an error occurs with the RPC request.

class VERGEClient
  class RPCError < StandardError
    attr_accessor :message

    def initialize(message)
      super()
      @message = message
    end
  end
end
