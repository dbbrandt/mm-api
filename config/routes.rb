Rails.application.routes.draw do

  resources :goals do
    resources :interactions
  end

  resources :interactions do
    resources :contents
  end

end
