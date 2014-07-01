Topstack::Application.routes.draw do

  resources :absorb, except: :destroy

  #omniauth
  match '/auth/:provider/callback', to: 'session#create', via: [:get, :post]
  get 'sign_out' => 'session#destroy', :as => 'sign_out'

  #http://guides.rubyonrails.org/routing.html#route-globbing-and-wildcard-segments
  get '/*top/*tags/*time_range', to: 'absorb#index'
  get '/*top/*unknown_filter', to: 'absorb#index'
  get '/*top', to: 'absorb#index'

  root 'home#index'
end
