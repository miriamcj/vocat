require 'subdomain_resolver'

Vocat::Application.routes.draw do
  constraints lambda { |request| SubdomainResolver.is_manage?(request) } do
    scope :module => :manage do
      get '/' => 'organizations#index', :as => 'manage_root'
      resources :organizations do
        get '/semesters' => 'semesters#org_index'
        put '/semesters' => 'semesters#update_all'
      end
      resources :semesters
      resources :superadmins do
        member do
          get 'edit_password'
          patch 'update_password'
        end
      end
    end
  end

  constraints lambda { |request| SubdomainResolver.is_blank?(request) } do
    get '/' => 'root#select', :as => 'select_org'
  end

  constraints lambda{ |request| SubdomainResolver.is_manage?(request) || SubdomainResolver.is_org?(request) } do
    # Allow login on any subdomain
    devise_for :users
    devise_scope :user do
      match '/users/settings' => 'registrations#update_settings', :via => :put
    end
    use_doorkeeper
  end

  constraints lambda{ |request| SubdomainResolver.is_org?(request) } do

    namespace :api, :defaults => {:format => 'json'} do
      namespace :v1 do

        match '/configuration' => 'configuration#index', :via => :get

        post 'token' => 'token#create'
        get 'token' => 'token#show'
        delete 'token' => 'token#destroy'
        patch 'token' => 'token#renew'

        resources :attachments, :only => [:create, :show, :destroy]
        resources :assets, :except => [:new, :edit, :index]
        resources :enrollments, :only => [:create, :destroy]
        resources :users, :only => [:show] do
          collection do
            get 'me'
            get 'search'
            post 'invite'
          end
          resources :enrollments, :only => [:index]
        end
        resources :rubrics, :except => [:new, :edit]
        resources :annotations, :except => [:new, :edit]
        resources :discussion_posts, :except => [:new, :edit]
        resources :evaluations, :except => [:new, :edit]
        resources :submissions, :except => [:index, :new, :edit] do
          collection do
            get 'for_course'
            get 'for_course_and_user'
            get 'for_creator_and_project'
            get 'for_user'
            get 'for_group'
            get 'for_project'
          end
        end
        resources :scores, :only => [] do
          collection do
            get 'my_scores'
            get 'all_scores'
            get 'peer_scores'
            get 'evaluator_scores'
          end
        end
        resources :videos, :only => [:destroy, :create, :show]
        resources :groups, :except => [:new, :edit]
        resources :projects, :except => [:new, :edit] do
          member do
            put 'publish_evaluations'
            put 'unpublish_evaluations'
            get 'statistics'
            get 'compare_scores'
            get 'project_submissions'
          end
        end
        resources :courses, :only => [:index, :update, :show] do
          resources :enrollments, :only => [:index] do
            collection do
              post 'bulk'
            end
          end
          collection do
            get 'for_user'
            get 'search'
          end
        end
        resources :visits, :only => [:create]
      end
    end

    resources :rubrics, :controller => 'courses/manage/rubrics', :only => [:index, :show, :new, :edit, :destroy] do
      member do
        post 'clone'
      end
    end

    resources :course_requests, :only => [:new, :create]

    resources :courses do

      member do
        get 'portfolio'
      end

      scope :module => "courses" do

        resources :assets, :only => [:show]
        resources :submissions, :only => [:show, :destroy] do
          member do
            get 'destroy_confirm'
            get 'reassign'
            post 'do_reassign'
          end
        end
        namespace "export" do
          resources :projects, :only => [] do
            member do
              get 'peer_scores'
              get 'all_scores'
              get 'evaluator_scores'
              get 'self_scores'
            end
          end
        end
        namespace "manage" do
          resources :projects, :except => [:show] do
            member do
              get 'export'
            end
          end
          resources :groups
          resources :rubrics, :only => [:index, :show, :new, :edit, :destroy] do
            member do
              post 'clone'
            end
          end
          get '/enrollment' => 'courses#enrollment'
          get '/' => 'courses#edit'
          patch '/' => 'courses#update'
          put '/' => 'courses#update'
        end
      end
      get 'evaluations/assets/:id' => 'courses/evaluations#course_map', :as => 'asset_evaluations'
      get 'groups/evaluations/(/creator/:creator_id)(/project/:project_id)(/asset/:asset_id)' => 'courses/evaluations#course_map', :as => 'group_evaluations', :defaults => { creator_type: 'group' }
      get 'users/evaluations(/creator/:creator_id)(/project/:project_id)(/asset/:asset_id)' => 'courses/evaluations#course_map', :as => 'user_evaluations', :defaults => { creator_type: 'user' }
      get 'users/creator/:creator_id/project/:project_id' => 'courses/evaluations#user_creator_project_detail', :as => 'user_creator_project_detail'
      get 'groups/creator/:creator_id/project/:project_id' => 'courses/evaluations#group_creator_project_detail', :as => 'group_creator_project_detail'
      get 'users/project/:project_id' => 'courses/evaluations#user_project_detail', :as => 'user_project_detail'
      get 'groups/project/:project_id' => 'courses/evaluations#user_project_detail', :as => 'groups_project_detail'
      get 'users/creator/:creator_id' => 'courses/evaluations#user_creator_detail', :as => 'user_creator_detail'
      get 'groups/creator/:creator_id' => 'courses/evaluations#group_creator_detail', :as => 'user_group_detail'
    end

    namespace :admin do
      resources :assets
      get '/academic_calendar', to: 'semesters#academic_calendar'
      put '/semesters' => 'semesters#update_all'
      resources :semesters
      resources :courses do
        member do
          get 'evaluators'
          get 'assistants'
          get 'creators'
          get 'export'
          resource :reports, :only => [] do
            member do
              get 'course_roster'
              get 'course_scores'
            end
          end
        end
      end
      resources :course_requests, :only => [:index] do
        member do
          put 'approve'
          put 'deny'
        end
      end
      resources :users do
        member do
          get 'courses'
          get 'edit_password'
          patch 'update_password'
        end
      end
      resources :rubrics, :except => [:create, :update] do
        member do
          post 'clone'
          get 'export'
          resource :reports, :only => [] do
            member do
              get 'rubric_scores'
            end
          end
        end
      end
    end

    get '/admin' => 'admin/courses#index', :as => 'admin'
    get '/' => 'root#index', :as => 'root'

    get '/dashboard/evaluator' => 'dashboard#evaluator', :as => 'dashboard_evaluator'
    get '/dashboard/creator' => 'dashboard#creator', :as => 'dashboard_creator'
    get '/dashboard/admin' => 'dashboard#admin', :as => 'dashboard_admin'
    get '/dashboard/courses' => 'dashboard#courses', :as => 'dashboard_courses'

  end

  apipie
  require 'sidekiq/web'
  authenticate :user, lambda { |u| u.role?(:administrator) } do
    mount Sidekiq::Web => '/sidekiq'
  end


end
