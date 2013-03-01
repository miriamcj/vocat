Vocat::Application.routes.draw do

  match "/org/:organization_id/submissions" => "submissions#index", :via => :get, :as => "submission_overview"

  resources :organizations, :path => "org" do
    resources :courses do
      resources :projects
      resources :submissions do
        resources :attachments
      end
    end
  end

  match "/org/:organization_id/course/:course_id/creator" => "exhibits#index", :via => :get, :as => "creator_course_overview"
  match "/org/:organization_id/course/:course_id/course_map" => "course_map#index", :via => :get, :as => "creator_course_map"
  match "/org/:organization_id/course/:course_id/course_map/creator/:creator_id/project/:project_id" => "course_map#show_submission_detail", :via => :get, :as => "creator_course_map_submission_detail"
  match "/org/:organization_id/course/:course_id/course_map/creator/:creator_id" => "course_map#show_creator_detail", :via => :get, :as => "creator_course_map_creator_detail"
  match "/org/:organization_id/course/:course_id/course_map/project/:project_id" => "course_map#show_project_detail", :via => :get, :as => "creator_course_map_project_detail"


  #deep_actions = [:new, :create, :index]
  #shallow_actions = [:edit, :update, :show, :destroy]
  #
  #
  ## admin gets all routes
  #namespace :admin do
  #  resources :organizations, :path => "org", :only => [] do
  #    resources :courses do
  #      resources :projects, :only => [:new, :create] do
  #        resources :submissions, :only => [:new, :create] do
  #          resources :attachments, :only => [:new, :create]
  #        end
  #      end
  #    end
  #    resources :projects, :only => [:edit, :update, :destroy]
  #    resources :submissions, :only => [:edit, :update, :destroy]
  #  end
  #end
  #
  #namespace :evaluator do
  #  resources :organizations, :path => "org", :only => [] do
  #    resources :courses do
  #      resources :projects, :only => [:new, :create]
  #    end
  #    resources :projects, :only => [:edit, :update, :destroy]
  #  end
  #end
  #
  #namespace :creator do
  #  resources :organizations, :path => "org", :only => [] do
  #    resources :courses, :only => [:show, :index] do
  #      resources :projects, :only => [] do
  #        resources :submissions, :only => [:new, :create] do
  #          resources :attachments, :only => [:new, :create]
  #        end
  #      end
  #    end
  #    resources :submissions, :only => [:edit, :update, :destroy]
  #  end
  #end


  get  "static/form"         => "static#form"

  devise_for :users, :controllers => {:registrations => "registrations"}

  root :to => 'exhibits#index'

end
