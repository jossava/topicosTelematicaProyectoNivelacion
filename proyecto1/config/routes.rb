Rails.application.routes.draw do
  resources :categories
  resources :articles do
    resources :comments, only: [:create, :destroy, :update]
  end

  devise_for :users
=begin
  	get "/articles" index
  	post "/articles" create
  	delete "/articles/:id" destroy
  	get "/articles/:id" show
  	get "/articles/new" new 
  	get "/articles/:id/edit" edit
  	patch "/articles/:id" update
  	put "/articles/:id" update

    get "/articles", to: "articles#index"
    post "/articles", to: "articles#create"
    delete "/articles/:id", to: "articles#destroy"
    get "/articles/:id", to: "articles#show"
    get "/articles/new", to: "articles#new"
    get "/articles/:id/edit", to: "articles#edit"
    patch "/articles/:id", to: "articles#update"
    put "/articles/:id", to: "articles#update"
=end
  root 'welcome#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
