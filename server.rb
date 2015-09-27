require 'socket'

server = TCPServer.new 2000

def handle_connection(client)
  request = client.gets.chomp
  puts request

  client.puts "HTTP/1.1 200 OK"
  client.puts ""
  client.puts "<h1>Hola Mundo</h1>"

  client.close
end

loop do
	client = server.accept
  Thread.new { handle_connection(client) }
end