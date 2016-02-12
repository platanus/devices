Devices::Engine.routes.draw do
  resources :devices
  root to: "devices#index"
end
