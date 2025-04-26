# frozen_string_literal: true

class VERGEClient
  class InvalidMethodError < StandardError
    attr_accessor :message

    def initialize(method_name)
      super()
      @message = "#{method_name} is not a valid method."
    end
  end
end
