Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :merchants, only: %i[index show] do
        resources :items, only: :index, module: 'merchants'
      end
      resources :items do
        resource :merchant, only: :show, module: 'items'
      end
    end
  end
end
