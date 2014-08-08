def factorial(n)
  (1..n.to_i).inject(:*) || 1
end
def multiply(n,m)
  n.to_i*m.to_i
end

MqManager.load_config

my_worker = MqManager::Worker.new do |req|
  zr = ZmqRequest.new
  zr.request = req
  zr.save
  command_n_args = req.split
  send(*command_n_args).to_s
end

MqManager.start('server',nil,{'bind_address' => MqManager.config['server_address'],'worker' => my_worker})
