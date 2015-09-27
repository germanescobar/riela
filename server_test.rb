require 'minitest/autorun'
require 'net/http'
require_relative 'server'

class TestServer < MiniTest::Test
  def setup
    @server = Server.new(nil, port=4444)
    @server.start
  end

  def teardown
    @server.stop
  end

  def test_that_server_is_running
    assert @server.running?
  end

  def test_that_server_returns_204_if_no_handler
    response = Net::HTTP.get_response URI('http://localhost:4444/')
    assert_equal "204", response.code
  end

  def test_that_handler_is_called
    handler = MiniTest::Mock.new
    handler.expect(:handle, nil, [Request, Response])
    @server.handler = handler

    response = Net::HTTP.get_response URI('http://localhost:4444/')
    assert handler.verify
  end

  def test_that_handler_can_change_status
    handler = MiniTest::Mock.new
    handler.expect(:handle, nil) do |req, res| 
      res.status = "404 Not Found"
    end
    @server.handler = handler

    response = Net::HTTP.get_response URI('http://localhost:4444/')
    assert handler.verify
    assert_equal "404", response.code
  end
end