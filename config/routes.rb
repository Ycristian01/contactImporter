Rails.application.routes.draw do
  root "users#index"
  devise_for :users

  resources :users
  resources :contacts
  
  resources :file_contacts do
    collection { post :import }
  end
  get '/failed_contacts' => 'contacts#failed'
end