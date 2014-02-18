TwittenKitten::Application.routes.draw do
  resources :users do
    resources :statuses
  end

  root :to => 'users#index'
end
