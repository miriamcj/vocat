Vocat::Application.routes.draw do

  get "courses/index"
  get "courses/create"
  get "courses/new"
  get "courses/destroy"
  get "courses/show"
  devise_for :users
  devise_scope :user do
    match '/users/settings' => 'registrations#update_settings', :via => :put
  end

  match 'pages/*page' => 'pages#show', :via => :get

  namespace :api do
    namespace :v1 do
      resources :rubrics, :except => [:new, :edit]
      resources :annotations, :except => [:new, :edit]
      resources :discussion_posts, :except => [:new, :edit]
      resources :evaluations, :except => [:new, :edit]
      resources :submissions, :except => [:index, :new, :edit] do
        collection do
          get 'for_course'
          get 'for_course_and_user'
          get 'for_user'
          get 'for_group'
          get 'for_project'
        end
      end
      resources :scores, :only => [] do
        collection do
          get 'for_project'
        end
      end
      resources :videos, :only => [:destroy, :create, :show]
      resources :groups, :except => [:new, :edit]
      resources :projects, :except => [:new, :edit]
      resources :courses do
        resources :creators do
          collection do
            get 'search'
          end
        end
        resources :evaluators do
          collection do
            get 'search'
          end
        end
      end
    end
  end

  resources :rubrics, :controller => 'courses/manage/rubrics', :only => [:index, :show, :new, :edit, :destroy]

  resources :courses do

    member do
      get 'portfolio'
    end

    scope :module => "courses" do
      namespace "manage" do
        resources :projects
        resources :groups
        resources :rubrics, :only => [:index, :show, :new, :edit, :destroy]
        get '/' => 'courses#edit'
        patch '/' => 'courses#update'
        put '/' => 'courses#update'
      end
    end

    get 'groups/evaluations/(/creator/:creator_id)(/project/:project_id)' => 'courses/evaluations#course_map', :as => 'group_evaluations'
    get 'users/evaluations(/creator/:creator_id)(/project/:project_id)' => 'courses/evaluations#course_map', :as => 'user_evaluations'
    get 'users/creator/:creator_id/project/:project_id' => 'courses/evaluations#user_creator_project_detail', :as => 'user_creator_project_detail'
    get 'users/project/:project_id' => 'courses/evaluations#user_project_detail', :as => 'user_project_detail'
    get 'groups/project/:project_id' => 'courses/evaluations#user_project_detail', :as => 'groups_project_detail'
    get 'view/project/:project_id' => 'courses/evaluations#current_user_project', :as => 'current_user_project'
  end

  namespace :admin do
    resources :courses do
      member do
        get 'evaluators'
        get 'creators'
        get 'export'
        resource :reports, :only => [:index] do
          member do
            get 'roster'
            get 'scores'
          end
        end
      end
    end
    resources :users do
      member do
        get 'courses'
      end
    end
    resources :rubrics
  end

  get '/admin' => 'admin/courses#index', :as => 'admin'

  get '/' => 'dashboard#index', :as => 'dashboard'
  get '/dashboard/evaluator' => 'dashboard#evaluator', :as => 'dashboard_evaluator'
  get '/dashboard/creator' => 'dashboard#creator', :as => 'dashboard_creator'
  get '/dashboard/admin' => 'dashboard#admin', :as => 'dashboard_admin'




#  resources :rubrics, :controller => 'admin/rubrics', :only => [:create, :update, :delete]
#  namespace :admin do
#    resources :rubrics, :only => [:index, :new, :show, :destroy, :edit]
#  end


end
