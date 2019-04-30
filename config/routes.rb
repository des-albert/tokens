Rails.application.routes.draw do
  get '/login' => 'users#login'
  post '/login' => 'users#save'
#
  get '/tokens/select' => 'tokens#select'
  post '/tokens/select' => 'tokens#activity'
  resources :tokens
  resources :subjects
  resources :recipients
end
