Icol::Engine.routes.draw do
  resources :notifications, only: [:index, :show] do
    collection do
      get :index
      put :index
    end
    member do
      get :audit_steps
    end
  end

  resources :notify_transactions
  
  resources :customers do
    collection do
      get :index
      put :index
    end
    member do
      get :audit_logs
      put :approve
    end
  end
  
  resources :validate_steps, only: [:index, :show] do
    collection do
      get :index
      put :index
    end
  end
end
