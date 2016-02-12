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

This will create the corresponding configuration files in `config/initializers/devices.rb` and two models: `Device` and `DeviceUser`.

`DeviceUser` has a reference to `User`, if you'd rather work with `AdminUser` or another model, add this to the initializer:

```ruby
Devices.user_class = AdminUser
```

To create the `Notification` model use the following command:

```
rails generate devices:model Notification
```

This will create both the model and controller for `Notification`, as well as a `NotificationService` in the `app/services` directory (it will be created if it doesn't exist). If you prefer to have all your model's controller automatically mounted under an `/api/` directory and URL you can add this to the initializer:

```ruby
Devices.default_controller_path = "api"
```

By default it will be blank and the generated controllers will be at the same level of your application's controllers.

After this, don't forget to run the migrations:

```
rake db:migrate
```

The last step is setting your environmental variables, by default Devices expects two variables: `ENV['AWS_KEY_ID']` and `ENV['AWS_ACCESS_KEY']`

You can configure these names setting the following options in the initializer:

```ruby
Devices.aws_key_id_name = "MY_AWS_KEY_ID_VARIABLE"
Devices.aws_access_key_name = "MY_AWS_ACCESS_KEY_VARIABLE"
```

## Registering a new device

You can call this generator to create a simple endpoint for device registration:

```
rails generate devices:device_controller
```

This will create a `DevicesController` with two inherited methods: `create` and `update`. Both of them expect the following params

|  Param  |   Type   |
|:-------|:--------:|
|   `user_id` |   Integer |
|   `platform`  |   String |
|   `device_uuid`  |   String |
|   `device_token`  |   String |

In addition to this, `update` expects an `id` param to identify the device you're updating.

The registration process searches the devices by their UUID and user, if no device with this UUID is registered before associated to the user, a new one is created. However, if there already is an existing user/UUID combination the `device_token` is updated.

This makes the `create` method double up as an `update` method as well: two POST requests to `/devices/create` with a different `device_token` will create just one device, updating the token in the second request.

A successfull response from either endpoint looks like this:

```json
{
  "api_token": "3fd7b57b-8740-4038-937c-a5d947c748a1"
}
```

You can redefine how devices are registered and updated just by defining these methods in the controller (don't forget to handle the API Token response!):

```ruby
class DevicesController
  def create
    # your device registration logic
  end

  def update
    # your device update logic
  end
end
```

To delete a device, the usual DELETE route is enabled in the `DevicesController`.

## Accessing the current device

The method `current_device` will return the device with the API token that matches the header `X-Device-Token`, that you need to include in the requests which you intend to use the `current_device` helper. You can customize this in the initializer settings:

```ruby
Devices.device_token_header = "My-Device-Token"
```

## Sending Notifications

Let's send a notification. We're asuming you have some devices registered already. It begins with `NotificationService`:

```ruby
class OrdersController
  def create
    @order = create_order
    ns = NotificationService.new
    ns.build_notification(order) # define an as_notification method
    ns.send_by_user(current_user)
    ns.send_by_device(current_device)
    ns.send_by_user_and_device(current_user, current_device)
  end
end

```
