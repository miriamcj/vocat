Vocat::Application.routes.draw do

  deep_actions = [:new, :create, :index]
  shallow_actions = [:edit, :update, :show, :destroy]

  # admin gets all routes
  namespace :admin do
    resources :organizations, :path => "org", :only => [] do
      resources :courses do
        resources :projects, :only => [:new, :create] do
          resources :submissions, :only => [:new, :create] do
            resources :attachments, :only => [:new, :create]
          end
        end
      end
      resources :projects, :only => [:edit, :update, :destroy]
      resources :submissions, :only => [:edit, :update, :destroy]
    end
  end

  namespace :evaluator do
    resources :organizations, :path => "org", :only => [] do
      resources :courses do
        resources :projects, :only => [:new, :create]
      end
      resources :projects, :only => [:edit, :update, :destroy]
    end
  end

  namespace :creator do
    resources :organizations, :path => "org", :only => [] do
      resources :courses, :only => [:show, :index] do
        resources :projects, :only => [] do
          resources :submissions, :only => [:new, :create] do
            resources :attachments, :only => [:new, :create]
          end
        end
      end
      resources :submissions, :only => [:edit, :update, :destroy]
    end
  end


  devise_for :users, :controllers => {:registrations => "registrations"}

  # The root is really determined in ApplicationController::after_sign_in_path_for
  root :to => 'organizations#index'

end
