Rails.application.routes.draw do
  mount Crono::Web, at: "/crono"

  get 'teste/teste'

  root "dashboard#services_panel"
  
  resources :devices, only: [:create, :update, :destroy]
  resources :monitored_services, only: [:create, :update, :destroy] do
    get 'history', on: :member, defaults: {format: :json}, constraints: {format: :json}
    get 'force_ping', on: :member, defaults: {format: :js}, constraints: {format: :js}
    get 'force_ping', on: :collection, defaults: {format: :js}, constraints: {format: :js}
  end
  
  get '/signin' => 'session#new'
  post '/signin' => 'session#create'
  
  get '/login' => 'session#new'
  post '/login' => 'session#create'
  
  get '/signoff' => 'session#destroy'
  get '/logoff' => 'session#destroy'
  
  get '/refresh_panel' => "dashboard#refresh_panel", defaults: {format: :js}, constraints: {format: :js}
  post '/update_settings' => "dashboard#update_settings"
  post '/update_refresh_ratio' => "dashboard#update_refresh_ratio", defaults: {format: :js}, constraints: {format: :js}
  
  telegram_webhook TelegramWebhooksController
end

if Rails.env.development?
  Rails.application.routes.default_url_options[:host] = 'https://monitoring-renatoneto69.c9users.io'
else
  Rails.application.routes.default_url_options[:host] = ENV['SERVER_HOSTNAME']
end
