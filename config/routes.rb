Vocat::Application.routes.draw do


  devise_for :users, :controllers => {:registrations => 'registrations'}

  match '/' => 'portfolio#index', :as => 'portfolio'
  match '/courses/:course_id/evaluations' => 'courses/evaluations#course_map', :via => :get, :as => 'courses_evaluations'
  match '/courses/:course_id/evaluations/creator/:creator_id' => 'courses/evaluations#course_map', :via => :get, :as => 'courses_evaluations_for_creator'
  match '/courses/:course_id/evaluations/creator/:creator_id/project/:project_id' => 'courses/evaluations#course_map', :via => :get, :as => 'courses_evaluations_for_creator_and_project'
  match '/courses/:course_id/evaluations/project/:project_id' => 'courses/evaluations#course_map', :via => :get, :as => 'courses_evaluations_for_project'

  match '/courses/:course_id/creator/:creator_id/project/:project_id' => 'courses/evaluations#creator_and_project', :via => :get, :as => 'course_creator_project'

  resources :user, :only => ['read'] do
      resources :submissions
  end

  resources :course, :only => ['read'] do
    resources :submissions
  end



  resources :courses do
    member do
      get 'portfolio'
    end
    resources :projects, :shallow => true
  end

  resources :rubrics, :controller => 'admin/rubrics', :only => [:create, :update, :delete]
  get '/admin' => 'admin/dashboard#index', :as => 'admin_root'
  namespace :admin do
    resources :rubrics, :only => [:index, :new, :show, :destroy, :edit]
  end


end
