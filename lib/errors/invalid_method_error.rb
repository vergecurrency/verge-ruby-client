# frozen_string_literal: true

# Raised when an invalid method is invoked.

class VERGEClient
  # Raised when an invalid method is invoked.
  class InvalidMethodError < StandardError
    def initialize(method_name)
      super("#{method_name} is not a valid method.")
    end
  end
end
