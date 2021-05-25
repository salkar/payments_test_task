# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :payment_transactions, only: %i[index create], format: "json"
    end
  end
end
