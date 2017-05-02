Rails.application.routes.draw do

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  authenticated :user do
    root to: 'movies#index'
  end

  root to: 'visitors#index'
end
