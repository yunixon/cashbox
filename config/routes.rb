Cashbox::Application.routes.draw do
  devise_for :users
  as :user do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    put 'users' => 'devise/registrations#update', :as => 'user_registration'
  end

  # You can have the root of your site routed with "root"
  root 'home#show'

  resources :organizations do
    member do
      put :switch
    end
  end
  resources :bank_accounts, except: [:show, :index] do
    put :hide, on: :member
    post :sort, on: :collection
  end
  resources :categories
  resources :transactions,  only: [:create, :edit, :update, :destroy] do
    post :transfer, action: :create_transfer, on: :collection
  end
  resources :members, only: [:index, :edit, :update]
end
