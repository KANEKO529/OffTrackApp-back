Rails.application.routes.draw do

  Rails.logger.debug "API: #{ENV.fetch('CORS_ORIGINS_API', '').split(',')}" # リクエストパラメータ全体を確認


  namespace :api do
    namespace :v1 do
      
      resources :visit_records, path: "visit-records", only: [:index, :create, :destroy, :update,] do
        collection do
          get "plot-stores", to: "visit_records#plot_stores"
          get 'with-store', to: "visit_records#with_store" # 専用エンドポイント
          post :bulk_create # 一括登録用
          post 'create-from-form', to: "visit_records#create_from_form"
        end
      end

      resources :stores, path: "stores", only: [:index, :create, :destroy, :update] do
        collection do
          get "nearby", to: "stores#nearby"
          post :bulk_create # 一括登録用
        end
      end

      resources :users, path: "users", only: [:index, :create, :update, :destroy]

      # resources :visit_records, path: "plot-stores", only: [:plot_stores]
    end
  end
end
