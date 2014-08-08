module MqManager

  class ZmqConnection
    ZMQ_CONN_TYPES = {'server' => :REP, 'client' => :REQ}
    
    def initialize(conn_type, conn_options)
      @conn_type = conn_type
      @@context = ZMQ::Context.new unless defined? @@context
      send("instantiate_#{conn_type}",conn_options)
    end
    
    def close
      @@context.destroy
    end
    
    def instantiate_server(conn_options)
      @conn = Server.new(@@context,conn_options['bind_address'],conn_options['worker'])
    end
    
    def instantiate_client(conn_options)
      @socket = @@context.socket(ZMQ_CONN_TYPES['client'])
      @conn = Client.new(@socket,conn_options['server_address'])
    end
    
    def start_server
      return @conn.start unless @conn_type != 'server'
      raise 'Tried to start server for non-server connection!'
    end
    
    def stop_server
      return @conn.stop unless @conn_type != 'server'
      raise 'Tried to stop server for non-server connection!'
    end
    
    def request(msg)
      return @conn.send_request(msg) unless @conn_type != 'client'
      raise 'Tried to send request from non-client connection!'
    end
    
    def publish(msg,nodes)
    end
    
    def subscribe(node)
    end
    
    
    class Server
      def initialize(context,bind_address,worker)
        @context = context
        @worker = worker
        @thread = nil
        @jobs, @working = 0, 0.0
        start(bind_address)
      end

      def start(bind_address)
        Thread.abort_on_exception = true
        @thread = Thread.new do
          @socket = @context.socket(ZMQ_CONN_TYPES['server'])
          @socket.verbose = true
          @socket.bind(bind_address)
          @socket.linger = 1
          loop do
            process_req(@socket.recv)
            break if Thread.current[:interrupted]
          end
        end
        puts 'server started'
        self
      end

      def stop
        return unless @thread
        @thread[:interrupted] = true
        @thread.join(0.1) unless @thread.stop?
        stats
      end

      def process_req(req)
        # Random hot loop to simulate CPU intensive work
        start = Time.now
        result = @worker.perform(req)
        @jobs += 1
        @working = (Time.now - start).to_f
        @socket.send result
        stats
      end

      private
      def stats
        puts "Processed job ##{@jobs} in %.4f seconds" % @working
        $stdout.flush
      end
    end
    
    
    class Client
      def initialize(socket,server_address)
        @socket = socket
        @server = nil
        # verbose output
        @socket.verbose = true
        connect(server_address)
      end

      def send_request(msg)
        @socket.send(msg)
        @socket.recv
      end

      private
      def connect(server_address)
        @socket.connect(server_address)
        @socket.linger = 1
      end
    end
    
  end

end
