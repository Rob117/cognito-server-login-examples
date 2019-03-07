Rails.application.routes.draw do
  root to: 'auth#index'
  get 'auth/generate_tokens', as: 'generate_tokens'
  get '/cognito', to: 'auth#callback'
  post 'auth/api'
  get 'auth/decode', to: 'auth#decode_token'
end
