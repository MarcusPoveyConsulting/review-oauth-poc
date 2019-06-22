Rails.application.routes.draw do
  get 'welcome/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :oauthapp

  get 'oauth2/authorise'
  get 'oauth2/connect' => 'oauth2#connectform'
  post 'oauth2/connect' 
  get 'oauth2/token'

  get 'demoapi/user'

  root 'welcome#index'
end
