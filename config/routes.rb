Rails.application.routes.draw do

  namespace :admin do
    resources :import_files do
      resources :import_rows
      member do
        get :generate
      end
    end
    get '/', to: redirect('/admin/goals')
    resources :goals do
      resources :interactions
    end
    resources :interactions do
     resources :contents
    end

    resources :contents
    resources :import_rows
  end
  
  # mount Fae below your admin namespec
  mount Fae::Engine => '/admin'

  namespace :api do
    resources :bootstrap, only: [:index]

    resources :goals do
      member do
        delete :purge
      end
      resources :interactions do
        member do
          get :check_answer
          post :submit_review
        end
      end
      resources :import_files do
        member do
          post :generate
        end
      end
    end

    # Interactions are only accessible through goals and content through interactions.
    resources :interactions, only: [] do
      resources :contents
    end

    resources :import_files do
      resources :import_rows
    end
  end
end
