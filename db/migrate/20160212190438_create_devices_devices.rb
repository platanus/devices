class CreateDevicesDevices < ActiveRecord::Migration
  def change
    create_table :devices_devices do |t|
      t.string :uuid
      t.string :device_token
      t.string :platform
      t.text :endpoint_arn

      t.timestamps null: false
    end
  end
end
