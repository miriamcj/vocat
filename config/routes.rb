Vocat::Application.routes.draw do


  devise_for :users, :controllers => {:registrations => 'registrations'}

  match '/' => 'portfolio#index', :as => 'portfolio'
  match '/courses/:course_id/exhibits' => 'courses/exhibits#index', :via => :get, :as => 'courses_exhibits'
  match '/courses/:course_id/exhibits/creator/:creator_id' => 'courses/exhibits#creator', :via => :get, :as => 'courses_exhibits_for_creator'
  match '/courses/:course_id/exhibit/creator/:creator_id/project/:project_id' => 'courses/exhibits#creator_and_project', :via => :get, :as => 'courses_exhibit_for_creator_and_project'
  match '/courses/:course_id/exhibits/project/:project_id' => 'courses/exhibits#project', :via => :get, :as => 'courses_exhibits_for_project'

  resources :courses do
    member do
      get 'portfolio'
    end
    resources :projects, :shallow => true
  end



    #resources :projects
    #
    #match 'map' => 'course/map#index', :via => :get, :as => 'course_map'
    #
    #
    #resources :projects

  #
  ## Static routes
  #get  '/course/:course_id/feedback' => 'static#feedback', :as => 'course_feedback'
  #get  '/static/form'                => 'static#form'
  #
  #
  #resources :rubrics, :controller => 'admin/rubrics', :only => [:create, :update, :delete]
  #
  ## Admin routes
  #get '/admin' => 'admin/dashboard#index', :as => 'admin_root'
  #
  #
  #namespace :admin do
	 # resources :users
  #
  #  resources :configuration
  #  resources :organizations, :path => 'org'
  #  resources :rubrics, :only => [:index, :new, :show, :destroy, :edit]
  #end
  #
  #devise_for :users, :controllers => {:registrations => 'registrations'}
  #
  #root :to => 'application#index'



  #resources :organizations, :path => 'org' do
  #  resources :courses do
  #    resources :projects
  #    resources :submissions do
  #      resources :attachments
  #    end
  #  end
  #end


end
