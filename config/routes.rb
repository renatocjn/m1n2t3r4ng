Rails.application.routes.draw do
  get 'session/login'

  resources :devices, except: :show
  root "dashboard#services_panel"
  
  resources :monitored_services, except: :show
  resources :users, only: [:show, :edit, :update]
  #get '/services_panel' => "dashboard#services_panel"
  
  get '/signin' => 'session#new'
  post '/signin' => 'session#create'
  
  get '/login' => 'session#new'
  post '/login' => 'session#create'
  
  get '/signoff' => 'session#destroy'
  get '/logoff' => 'session#destroy'
  
  get '/refresh_panel' => "dashboard#refresh_panel"
  post '/' => "dashboard#update_settings"
  get '/force_ping' => "dashboard#force_ping"
  
  post '/567635476:AAEg8S3DkECGVXMnyUwRMnVSY-VEKJjzaaU' => 'application#webhook'
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
