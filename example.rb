require_relative 'mq_manager'

MqManager.load_config

my_worker = MqManager::Worker.new do |req|
  "I got '#{req}' as a request!"
end

server = MqManager.start('server',nil,{'bind_address' => 'tcp://127.0.0.1:5000','worker' => my_worker})

client = MqManager.start('client',nil,{'server_address' => 'tcp://127.0.0.1:5000'})

loop do
  response = client.request('my request string')
  puts "got response '#{response}'"
  sleep 2
end
