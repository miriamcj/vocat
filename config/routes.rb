Vocat::Application.routes.draw do


  devise_for :users, :controllers => {:registrations => 'registrations'}

  match 'pages/*page' => 'pages#show', :via => :get

  namespace :api do
    namespace :v1 do

      # Singular because a user only has one portfolio
      resources :portfolio, :only => [:index] do
        collection do
          get 'unsubmitted'
        end
      end

      resources :attachments
      resources :annotations
      resources :discussion_posts
      resources :evaluations
      resources :courses do
        resources :submissions, :only => [:index]
        resources :evaluations, :only => [:index]
      end
      resources :creator
      resources :project



      #resources :attachment, :only => [] do
      #  resources :annotations, :only => [:index, :show, :create, :destroy]
      #end
      #
      #resources :submissions do
      #  resources :attachments, :only => [:create, :destroy, :show]
      #  resources :discussion_posts, :shallow => true
      #end
      #
      #resources :course, :only => [:index, :show] do
      #  resources :submissions, :only =>[:index]
      #  resources :creator, :only => [] do
      #    resources :submissions, :only =>[:index]
      #    resources :project, :only =>[:index] do
	     #     resources :submissions, :only =>[:index]
	     #   end
      #  end
      #  resources :projects, :only =>[:index] do
      #    resources :submissions, :only =>[:index]
      #  end
      #end
      #
      #resources :creator, :only => [] do
      #  resources :submissions, :only =>[:index]
      #  resources :projects, :only =>[:index]
      #end

    end
  end

  resources :courses do

    member do
      get 'portfolio'
    end

    scope :module => "courses" do
      namespace "manage" do
        resources :projects
        resources :groups
        resources :rubrics, shallow: true
        match 'settings' => 'settings#edit', :via => :get
        match 'settings' => 'settings#update', :via => :put
      end
    end
    resources :rubrics, shallow: true

    match 'evaluations(/creator/:creator_id)(/project/:project_id)' => 'courses/evaluations#course_map', :via => :get, :as => 'evaluations'
    match 'view/creator/:creator_id' => 'courses/evaluations#creator', :via => :get, :as => 'creator'
    match 'view/project/:project_id' => 'courses/evaluations#project', :via => :get, :as => 'project'
    match 'view/creator/:creator_id/project/:project_id' => 'courses/evaluations#creator_and_project', :via => :get, :as => 'creator_and_project'

  end


  get '/admin' => 'admin/dashboard#index', :as => 'admin_root'
  match '/' => 'portfolio#index', :as => 'portfolio'
  match '/course_map_dev' => 'courses/evaluations#course_map_dev', :via => :get

  match '/form_dev' => 'courses/evaluations#form_dev', :via => :get




#  resources :rubrics, :controller => 'admin/rubrics', :only => [:create, :update, :delete]
#  namespace :admin do
#    resources :rubrics, :only => [:index, :new, :show, :destroy, :edit]
#  end


end
