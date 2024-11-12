# Multi-threaded Web Server in Ruby

This is a basic implementation of a multi-threaded web server in Ruby, using a thread pool to handle multiple HTTP requests concurrently. The server listens on a specified port and handles incoming requests using worker threads. The design includes resource management with thread pooling, job scheduling, and graceful shutdown.

## Features
- **Thread Pooling**: Manages a fixed number of threads to handle requests concurrently, avoiding the overhead of creating a new thread for each request.
- **Request Handling**: Simulates handling GET requests by returning a response with the requested path.
- **Graceful Shutdown**: Server shuts down cleanly when an interrupt signal (`CTRL+C`) is received.
- **Error Handling**: Handles errors gracefully and closes client connections in case of failure.

## Requirements
- Ruby 2.x or later

## Installation

Ensure that you have Ruby installed on your machine. If not, install Ruby from [the official website](https://www.ruby-lang.org/en/documentation/installation/).

Clone this repository or copy the code into a Ruby file (e.g., `server.rb`).

## Usage

1. Save the script as `server.rb`.
2. Run the server:

   ```bash
   ruby server.rb
   ```

3. The server will start listening on port `3000`. You can change the port by modifying the `server = WebServer.new(3000, 4)` line in the script.

4. The server will handle incoming HTTP GET requests, returning a response like:

   ```
   HTTP/1.1 200 OK
   Content-Type: text/plain
   
   Hello from /path!
   ```

   If a non-GET request is made, the server will respond with a "405 Method Not Allowed" message.

5. To stop the server, press `CTRL+C`. The server will shut down gracefully.

## Code Overview

### `ThreadPool` Class
- **Initialization (`initialize(size)`)**: Initializes a thread pool with a specified size. Creates worker threads that will continuously process tasks from a queue.
- **Scheduling Jobs (`schedule(&block)`)**: Adds a job to the job queue, which will be picked up by a worker thread.
- **Shutdown (`shutdown`)**: Stops all threads in the pool by sending an exit signal to each.

### `WebServer` Class
- **Initialization (`initialize(port, thread_pool_size)`)**: Initializes a TCP server on the specified port and a thread pool with a given size.
- **Start Server (`start`)**: Starts the server and accepts incoming client connections, delegating each connection to a worker thread.
- **Request Handling (`handle_request(client)`)**: Processes incoming requests, responding with an HTTP message. Only GET requests are supported. Any other method receives a "405 Method Not Allowed" response.
- **Error Handling**: Catches exceptions during request processing and ensures that client connections are closed.

### Graceful Shutdown
- The server listens for `CTRL+C` (SIGINT) and shuts down cleanly by calling `server.shutdown`, which stops all threads.

## Customization
- **Thread Pool Size**: You can modify the number of threads in the pool by changing the `thread_pool_size` argument when initializing the `WebServer` instance. The default is `4`.
  
- **Request Timeout**: The current timeout is set to `5` seconds (though not actively used in this implementation, it can be extended for request handling or processing long-running tasks).

## Contributing
Feel free to fork and submit pull requests to improve this server implementation. You can enhance it by adding features like:
- Better request parsing
- Support for different HTTP methods (POST, PUT, etc.)
- Request timeout handling
- Logging and monitoring features
