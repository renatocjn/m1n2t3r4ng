Rails.application.routes.draw do
  root "dashboard#services_panel"
  
  resources :devices, only: [:create, :update, :destroy]
  resources :monitored_services, only: [:create, :update, :destroy]
  
  get '/signin' => 'session#new'
  post '/signin' => 'session#create'
  
  get '/login' => 'session#new'
  post '/login' => 'session#create'
  
  get '/signoff' => 'session#destroy'
  get '/logoff' => 'session#destroy'
  
  get '/refresh_panel' => "dashboard#refresh_panel"
  get '/force_ping(/:id)' => "dashboard#force_ping"
  post '/' => "dashboard#update_settings"
  
  telegram_webhook TelegramWebhooksController
end

if Rails.env.development?
  Rails.application.routes.default_url_options[:host] = 'https://monitoring-renatoneto69.c9users.io'
else
  Rails.application.routes.default_url_options[:host] = ENV['SERVER_HOSTNAME']
end