Vocat::Application.routes.draw do


  devise_for :users, :controllers => {:registrations => 'registrations'}

  namespace :api do
    namespace :v1 do

      resources :attachments
      resources :annotations
      resources :submission

      resources :course, :only => [:index, :show] do
        resources :submissions, :only =>[:index]
        resources :creator, :only => [] do
          resources :submissions, :only =>[:index]
        end
        resources :projects, :only =>[:index] do
          resources :submissions, :only =>[:index]
        end
      end

      resources :creator, :only => [] do
        resources :submissions, :only =>[:index]
        resources :projects, :only =>[:index]
      end

    end
  end

  resources :courses do

    match 'evaluations' => 'courses/evaluations#course_map', :via => :get, :as => 'evaluations'
    match 'evaluations/creator/:creator_id' => 'courses/evaluations#course_map', :via => :get, :as => 'evaluations_for_creator'
    match 'evaluations/creator/:creator_id/project/:project_id' => 'courses/evaluations#course_map', :via => :get, :as => 'evaluations_for_creator_and_project'
    match 'evaluations/project/:project_id' => 'courses/evaluations#course_map', :via => :get, :as => 'evaluations_for_project'
    match 'creator/:creator_id/project/:project_id' => 'courses/evaluations#creator_and_project', :via => :get, :as => 'creator_project'

    member do
      get 'portfolio'
    end
    scope :module => "courses" do
      resources :projects
      resources :groups
      match 'settings' => 'settings#edit', :via => :get
      match 'settings' => 'settings#update', :via => :put
    end
    resources :rubrics, shallow: true
  end


  get '/admin' => 'admin/dashboard#index', :as => 'admin_root'
  match '/' => 'portfolio#index', :as => 'portfolio'
  match '/course_map_dev' => 'courses/evaluations#course_map_dev', :via => :get




#  resources :rubrics, :controller => 'admin/rubrics', :only => [:create, :update, :delete]
#  namespace :admin do
#    resources :rubrics, :only => [:index, :new, :show, :destroy, :edit]
#  end


end
