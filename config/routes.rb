Rails.application.routes.draw do

  resources :goals do
    resources :interactions
    resources :import_files
  end

  # Allows only nested requests to contents.
  resources :interactions, only: [] do
    resources :contents
  end

  # Allows only nested requests to import_rows
  resources :import_files, only: [] do
    resources :import_rows
  end



  namespace :admin do
    resources :import_files
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
