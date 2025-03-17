# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  scope '(:locale)', locale: /en|ru/ do
    root 'posts#index'
    resources :posts do
      resources :comments, only: :create
      resources :likes, only: %i[create destroy]
    end
  end
end
