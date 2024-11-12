require 'socket'
require 'thread'

class ThreadPool
  def initialize(size)
    @size = size
    @threads = []
    @jobs = Queue.new

    @size.times do
      @threads << Thread.new do
        loop do
          job = @jobs.pop
          job.call
        end
      end
    end
  end

  def schedule(&block)
    @jobs << block
  end

  def shutdown
    @size.times do
      schedule { throw :exit }
    end
    @threads.each(&:join)
  end
end

class WebServer
  def initialize(port, thread_pool_size)
    @server = TCPServer.new(port)
    @thread_pool = ThreadPool.new(thread_pool_size)
    @request_timeout = 5 # seconds
    puts "Server running on port #{port}"
  end

  def start
    loop do
      client = @server.accept
      @thread_pool.schedule { handle_request(client) }
    end
  end

  private

  def handle_request(client)
    request = client.gets
    if request
      method, path, _ = request.split
      if method == 'GET'
        # Simulate request processing
        response = "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\nHello from #{path}!"
        client.puts response
      else
        client.puts "HTTP/1.1 405 Method Not Allowed\r\nContent-Type: text/plain\r\n\r\nMethod Not Allowed"
      end
    end
    client.close
  rescue StandardError => e
    puts "Error handling request: #{e.message}"
    client.close
  end
end

# Start server with 4 threads
server = WebServer.new(3000, 4)
trap("INT") { server.shutdown }
server.start
