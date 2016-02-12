Rails.application.routes.draw do

  mount Devices::Engine => "/devices"
end
