Rails.application.routes.draw do
  root to: 'auth#index'
  get 'auth/generate_tokens', as: 'generate_tokens'
  get '/cognito', to: 'auth#callback'
  post 'auth/api'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
