Vocat::Application.routes.draw do

  resources :organizations, :path => "org" do
    resources :courses do
      resources :submissions do
        resources :attachments
      end
      resources :assignments
      resources :assignment_types
    end
  end

  devise_for :users

  root :to => 'courses#index' # The organization id is set by ApplicationController::after_sign_in_path_for()

end
