require 'rbczmq'
require 'inflecto' unless "".methods.grep(/^camelize$/).length > 0
Dir["#{File.expand_path File.dirname(__FILE__)}/mq_manager/*.rb"].each {|file| require file }

module MqManager

  @@config = nil
  
  #TODO: add publisher and subscriber
  @@conns = {
    'server' => nil,
    'client' => nil
  }
  
  def self.load_config(config_hash = nil)
    cfg_h = ConfigHandler.new
    @@config = (config_hash.nil?) ? cfg_h.load_config : config_hash
  end
  def self.config
    @@config
  end
  def self.conns
    @@conns
  end
  def self.start(conn_type, mq_type=nil, conn_options = {})
    mq_type = @@config['mq_type'] if mq_type.nil?
    @@conns[conn_type] = ConnectionHandler.new
    @@conns[conn_type].open(conn_type, mq_type, conn_options)
  end
  
  class Worker
    def initialize(&proc_block)
      if proc_block
        @proc = proc_block 
      else
        @proc = Proc.new do |req|
          puts req
          'Block not defined.'
        end
      end
    end
    def perform(arg)
      @proc.call(arg)
    end
  end
  
end
