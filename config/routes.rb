Rails.application.routes.draw do

  resources :goals do
    resources :interactions
  end

  # Allows only nested requests to contents.
  resources :interactions, only: [] do
    resources :contents
  end

  namespace :admin do
    get '/', to: redirect('/admin/goals')
    resources :goals do
      resources :interactions
    end
    resources :interactions do
     resources :contents
    end

    # Allow only routs to
    resources :contents
  end
  
  # mount Fae below your admin namespec
  mount Fae::Engine => '/admin'

end
