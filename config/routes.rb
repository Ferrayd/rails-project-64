# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  resources :posts
  root 'posts#index'
  resources :posts do
    resources :comments, only: [:create]
  end
  resources :posts do
    resources :likes, only: %i[create destroy], controller: :likes
  end
end
