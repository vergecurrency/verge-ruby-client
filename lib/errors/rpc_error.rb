# frozen_string_literal: true

class VERGEClient
  class RPCError < StandardError
    attr_accessor :message

    def initialize(message)
      super()
      @message = message
    end
  end
end
