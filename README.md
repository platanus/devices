# Devices

A jump start for writing push notification enabled applications.

## Installation

Include this in your Gemfile:

```ruby
gem "devices"
```

And run bundle:

```
bundle install
```

## How Devices helps you

It creates a set of classes, controllers and services that you can use right away or easily extend to work with notifications. To achieve this, Devices makes the following assumptions:

- You are going to use Amazon's SNS to deliver notifications
- You application could have any number of users per device
- You user could be logged in any number of devices

## Configuring Devices

Devices gives you a generator which allows you to generate the models you need to use push notifications:

```
rails generate devices:install
```

This will create the corresponding configuration files in `config/initializers/devices.rb` and the `Device` model.

After this, don't forget to run the migrations:

```
rake db:migrate
```

## Registering a new device

The generator creates a simple endpoint for device registration:

This will create a `DevicesController` with two inherited methods: `create` and `update`. Both of them expect the following params

|  Param  |   Type   |
|:-------|:--------:|
|   `platform`  |   String |
|   `device_uuid`  |   String |
|   `device_token`  |   String |

In addition to this, `update` expects an `id` param to identify the device you're updating.

The registration process searches the devices by their UUID and user, if no device with this UUID is registered before associated to the user, a new one is created.

However, if there already is an existing user/UUID combination the `device_token` is updated.

This makes the `create` method double up as an `update` method as well: two POST requests to `/devices` with a different `device_token` will create just one device, updating the token in the second request.

A successfull response from either endpoint looks like this:

```json
{
  "device": {
    "platform": "ios",
    "device_uuid": "example device uuid",
    "device_token": "example device token",
    "endpoint_arn": "sns device url"
  }
}
```

You can redefine how devices are registered and updated just by defining these methods in your controller:

```ruby
class MyDevicesController < Devices::DevicesController 
  def create
    super
    # your device registration logic
  end

  def update
    super
    # your device update logic
  end
end
```

To delete a device, the usual DELETE route is enabled in `DevicesController`.

## Accessing the current device

The method `current_device` will return the device with the device UUID that matches the header `X-Device-Token`, that you need to include in the requests in which you intend to use the `current_device` helper. You can customize this in the initializer settings:

```ruby
Devices.device_token_header = "My-Device-Token"
```