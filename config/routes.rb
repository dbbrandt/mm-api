Rails.application.routes.draw do

  resources :goals do
    resources :interactions
  end

  resources :interactions do
    resources :contents
  end

  namespace :admin do
    resources :contents
    resources :interactions
    resources :goals do
      resource :interactions
    end
  end
  # mount Fae below your admin namespec
  mount Fae::Engine => '/admin'

end
