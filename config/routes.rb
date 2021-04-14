Rails.application.routes.draw do
  root "users#index"
  devise_for :users

  resources :users
  resources :contacts #do
  #   collection { post :import }
  # end
  resources :file_contacts
  get '/failed_contacts' => 'contacts#failed'
end