require_relative '../mq_manager'

MqManager.load_config

client = MqManager.start('client',nil,{'server_address' => 'tcp://127.0.0.1:5000'})

response = client.request(ARGV.join(' '))
puts "got response '#{response}'"
