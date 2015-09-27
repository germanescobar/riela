require 'socket'

class Request
  attr_reader :method, :path, :version

  def initialize(conn)
    # request line
    @method, @path, @version = conn.gets.chomp.split(" ")

    # headers
    @headers = {}
    while (line = conn.gets) && line !~ /^\s*$/
      header = line.chomp.split(':', 2)
      @headers[header[0].upcase] = header[1].strip
    end

    # body
    if @headers["CONTENT-LENGTH"]
      content_length = @headers["CONTENT-LENGTH"].to_i
      @body = conn.gets(content_length)
    end
  end
end

class Response
  attr_reader :headers
  attr_accessor :status, :body

  def initialize
    @status = "204 No Content"
    @headers = { "Connection" => "close" }
    @body = nil
  end
end

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
    request = Request.new(conn)
    response = Response.new

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

class MyHandler
  def handle(request, response)
    
  end
end

# t = Server.new(MyHandler.new).start
# t = server.start
# sleep 5
# puts "Stopping yeah"
# server.stop

# t.join