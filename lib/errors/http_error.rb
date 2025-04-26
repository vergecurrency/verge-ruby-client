# frozen_string_literal: true
# Raised when an HTTP error occurs during an RPC request.
class VERGEClient
  class HTTPError < StandardError
    attr_accessor :object, :message

    def initialize(object)
      super()
      @object = object
      @message = "Expected NET::HTTPOK but got: #{object.class}"
    end
  end
end
