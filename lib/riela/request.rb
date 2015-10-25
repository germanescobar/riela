module Riela
  class Request
    attr_reader :method, :path, :version, :headers, :body, :server_name, :server_port, :remote_addr, :remote_port

    def initialize(conn)
      # request line
      @method, @path, @version = conn.gets.chomp.split(" ")

      local_address = conn.local_address
      @server_name = local_address.getnameinfo[0]
      @server_port = local_address.ip_port.to_s

      remote_address = conn.remote_address
      @remote_addr = remote_address.ip_address
      @remote_port = remote_address.ip_port.to_s

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
end