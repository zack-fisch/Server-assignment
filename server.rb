require 'socket'                                    # Require socket from Ruby Standard Library (stdlib)

host = 'localhost'
port = 2000

server = TCPServer.open(host, port)                 # Socket to listen to defined host and port
puts "Server started on #{host}:#{port} ..."        # Output to stdout that server started

loop do                                             # Server runs forever
  client = server.accept                            # Wait for a client to connect. Accept returns a TCPSocket, wait for connections

  lines = []
  while (line = client.gets.chomp) && !line.empty?  # Read the request and collect it until it's empty
    lines << line
  end

  puts lines                                        # Output the full request to stdout

  filename = lines[0].gsub(/GET \//, '').gsub(/\ HTTP.*/, '')

	if File.exists?(filename)                        # If file exists substitute header
		client.puts "HTTP/1.1 200 OK\r\n\r\n"
	  client.puts File.read(filename)
	else                                             # Else tell user file not found
		client.puts "HTTP/1.1 404 Not Found\r\n\r\n"
	  client.puts "File Not Found"
	end  

  client.close                                      # Disconnect from the client
end
