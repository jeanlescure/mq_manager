module MqManager
  
  class ConnectionHandler
    def open(conn_type, mq_type, conn_options = {})
      klass = (mq_type.methods.grep(/^camelize$/).length > 0) ? "#{mq_type}_connection".camelize : Inflecto.camelize("#{mq_type}_connection")
      puts klass
      @connection = MqManager.const_get(klass).new(conn_type, conn_options)
    end
    
    def request(msg)
      @connection.request(msg)
    end
    
    def publish(msg,nodes)
    end
    
    def subscribe(node)
    end
  end
  
end
