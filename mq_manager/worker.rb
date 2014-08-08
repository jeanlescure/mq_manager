module MqManager
  
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
