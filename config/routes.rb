AllSeats::Application.routes.draw do


  get "/collections/:id" => "collections#show", as: :collection

  mount Rich::Engine => '/rich', :as => 'rich'

  get "search/events" => 'search#index', as: :filter
  get "search/free_search" =>'search#show', as: :free_search
  get "search/autocomplete", :to => 'search#autocomplete', :as => :autocomplete

  #match can be get

  get "/performer/events" => 'performers#events', as: :performer_tickets

  get "/venue/events" => 'venues#events', as: :venue_tickets

  get 'static/:permalink', :controller => 'static_pages', :action => 'show', :as => :static_page

  resources :performers, :only => [:show]
  resources :events, :only => [:show]
  resources :venues, :only => [:show]
  resources :locations, :only => [:show, :index]
  resources :contact_us_messages, :only => [:create]

  get "home/home"
  
  devise_for :users

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

#  mount RailsAdminImport::Engine => '/rails_admin_import', as: 'rails_admin_import'


  root :to=>'home#home'

  get "/:id" => "categories#show", as: :category
  get "/:category_id/:id" => "performers#show", as: :long_performer
  get "/:category_id/:performer_id/:date" => "events#show", as: :long_event

  post '/contact_us_messages/new'



  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
