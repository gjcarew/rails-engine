Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :merchants, only: %i[index show] do
        resources :items, only: :index, module: 'merchants'
        collection do
          get 'find'
          get 'find_all'
        end
      end
      resources :items do
        resource :merchant, only: :show, module: 'items'
        collection do
          get 'find'
          get 'find_all'
        end
      end
    end
  end
end
