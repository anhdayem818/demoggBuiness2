Rails.application.routes.draw do
  get 'dashboards/index'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks',
                                    sessions: 'users/sessions', registrations: "users/registrations"
                                  }
  root "dashboards#index"
end
