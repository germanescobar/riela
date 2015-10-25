require 'rack'
require 'rack/rewindable_input'
require 'rack/handler'
require 'stringio'

module Rack
  module Handler
    def self.default(options={})
      Rack::Handler::RServer
    end

    class RServer
      DEFAULT_ENV = {
        'rack.version' => Rack::VERSION,
        'rack.url_scheme' => 'http',
        'rack.errors' => $stderr,
        'rack.multithread' => false,
        'rack.multiprocess' => false,
        'rack.run_once' => false
      }

      def initialize(app, options={})
        @app = app
        @options = options
      end

      def self.run(app, options={})
        new(app, options).run
      end

      def run
        @thread = Riela::Server.new(self).start
        @thread.join
      end

      def handle(request, response)
        env = {}.merge!(DEFAULT_ENV)

        env['rack.input'] = Rack::RewindableInput.new(StringIO.new(request.body || ""))

        env['SERVER_NAME'] = request.server_name
        env['SERVER_PORT'] = request.server_port
        env['SERVER_PROTOCOL'] = "HTTP/1.1"

        env['REMOTE_ADDR'] = request.remote_addr
        env['REMOTE_PORT'] = request.remote_port

        env['REQUEST_METHOD'] = request.method
        env['PATH_INFO'] = request.path
        env['QUERY_STRING'] = ""

        request.headers.each do |name, value|
          env["HTTP_#{name.upcase}"] = value
        end

        status, headers, body = @app.call(env)
        response.status = status
        response.headers = headers
        response.body = body
      end
    end
  end
end