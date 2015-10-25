module Riela
  class Response
    attr_accessor :status, :headers, :body

    def initialize
      @status = "204 No Content"
      @headers = { "Connection" => "close" }
      @body = nil
    end
  end
end