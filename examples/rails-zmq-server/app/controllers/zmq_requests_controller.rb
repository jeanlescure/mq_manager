class ZmqRequestsController < ApplicationController
  def show
    @requests = ZmqRequest.where('id > -1')
  end
end
