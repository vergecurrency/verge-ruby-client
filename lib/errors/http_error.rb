# frozen_string_literal: true

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
