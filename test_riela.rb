require 'riela'


class MyHandler
  def handle(request, response)
    response.status = "200 OK"
    response.body = "<h1>Hola Mundo</h1>"
  end
end

# server = Riela::Server.new(MyHandler.new, port=4000)
# t = server.start
# t.join

Rack::Handler::RServer.run(nil)