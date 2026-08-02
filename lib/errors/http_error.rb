# frozen_string_literal: true

# Raised when an HTTP error occurs during an RPC request.

class VERGEClient
  # Raised when an HTTP error occurs during an RPC request.
  class HTTPError < StandardError
    attr_reader :response

    def initialize(object)
      @response = object
      status = object.respond_to?(:code) ? " (HTTP #{object.code})" : ''
      super("Unexpected RPC response: #{object.class}#{status}")
    end
  end
end
