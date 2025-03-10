# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  scope '(:locale)', locale: /en|ru/ do
    root 'posts#index'
    resources :posts do
      scope module: :posts do
        resources :comments, controller: 'comments' do
          get :new, on: :collection
        end
        resources :likes, only: %i[create destroy], controller: :likes
      end
    end
  end

end
