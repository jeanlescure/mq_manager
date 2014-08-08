class CreateZmqRequests < ActiveRecord::Migration
  def change
    create_table :zmq_requests do |t|
      t.string :request

      t.timestamps
    end
  end
end
