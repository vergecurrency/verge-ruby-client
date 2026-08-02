# frozen_string_literal: true

# Raised when an error occurs with the RPC request.

class VERGEClient
  # Raised when an error occurs with the RPC request.
  class RPCError < StandardError
    attr_reader :code, :data

    def initialize(error)
      error = { 'message' => error } unless error.is_a?(Hash)
      @code = error['code']
      @data = error['data']
      super(error['message'] || 'Unknown RPC error')
    end
  end
end
