module Riela
  class Server
    attr_accessor :handler

    def initialize(handler, port=2000)
      @handler = handler
      @server = TCPServer.new port
      @running = false
    end

    def start
      @running = true
      Thread.new do
        while @running do
          conn = @server.accept
          handle_connection(conn) if conn
        end
      end
    end

    def stop
      @running = false
      @server.close
    end

    def running?
      @running
    end

    def handle_connection(conn)
      request = Riela::Request.new(conn)
      response = Riela::Response.new

      if @handler.respond_to?(:handle)
        @handler.handle(request, response)
      end

      conn.puts "HTTP/1.1 #{response.status}"
      response.headers.each do |header, value|
        conn.puts "#{header}: #{value}"
      end
      conn.puts
      conn.puts response.body if response.body

      conn.close    
    end
  end
end