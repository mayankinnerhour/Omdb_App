Rails.application.routes.draw do

  namespace :api do
    scope :v1 do
      mount_devise_token_auth_for 'User', at: 'auth'
    end
  end
  resources :movies do
    put :add_to_favorite, on: :member
    resources :reviews
  end
end
