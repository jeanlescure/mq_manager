require_relative '../mq_manager'

def factorial(n)
  (1..n.to_i).inject(:*) || 1
end
def multiply(n,m)
  n.to_i*m.to_i
end

MqManager.load_config

my_worker = MqManager::Worker.new do |req|
  command_n_args = req.split
  send(*command_n_args).to_s
end

server = MqManager.start('server',nil,{'bind_address' => 'tcp://127.0.0.1:5000','worker' => my_worker})

loop do
  #Since the server runs on a thread, 
  #we loop so this script doesn't die
end
