Rails.application.routes.draw do


  resources :users, only:[:create, :new, :edit, :update, :show] do
    resources :races, only:[:create, :edit, :update, :new, :index, :destroy]
    resources :logs, only:[:create, :new, :edit, :update, :destroy]
  end

  resources :sessions, only:[:new, :create, :destroy]

  
  get 'users/new'
  get 'welcome/index'
  root 'welcome#index'
  match 'users/:user_id/log/:period',     to:     'logs#log',           via: 'get'
  match 'users/:user_id/logs/:id/:period',to:     'logs#destroy',       via: 'delete'    
  match '/signup',                        to:     'users#new',          via: 'get'
  match '/signin',                        to:     'sessions#new',       via: 'get'
  match '/signout',                       to:     'sessions#destroy',   via: 'delete'
  match '/newlog/:user_id/:period/:day',  to:     'logs#new',           via: 'get'
  match '/editlog/:user_id/:period/:day', to:     'logs#edit',          via: 'get' 
  match '/pb/:user_id',                   to:     'races#pb',           via: 'get'
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
