class RequestsController < ApplicationController
  def send_req
    @response = ''
    if !params[:req].nil?
      MqManager.start('client',nil,{'server_address' => MqManager.config['server_address']})
      @response = MqManager.conns['client'].request(params[:req])
    end
  end
end
