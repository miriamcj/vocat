Vocat::Application.routes.draw do

	devise_for :users
	devise_scope :user do
		match '/users/settings' => 'registrations#update_settings', :via => :put
	end

  match 'pages/*page' => 'pages#show', :via => :get

  namespace :api do
    namespace :v1 do

      resources :rubrics, :except => [:new, :edit]
      resources :attachments, :except => [:new, :edit]
      resources :annotations, :except => [:new, :edit]
      resources :discussion_posts, :except => [:new, :edit]
      resources :evaluations, :except => [:new, :edit]
      resources :submissions, :only => [:index]
      resources :videos, :only => [:destroy, :create, :show]

      resources :courses do

        resources :submissions, :shallow => true, :except => [:new, :edit] do
        end

        resources :users, :only => [:index, :show] do
	        resources :submissions, :only => [:index]
	        resources :projects, :only => [] do
		        resources :submissions, :only => [:index]
	        end
        end

        resources :groups, :shallow => true,:except => [:new, :edit]
				resources :groups, :only => [] do
					resources :submissions, :only => [:index]
					resources :projects, :only => [] do
						resources :submissions, :only => [:index]
					end
				end

        resources :projects, :shallow => true, :except => [:new, :edit]
        resources :projects, :only => [] do
          resources :evaluations, :only => [:index]
	        resources :scores, :only => [:index]
        end
      end
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
        resources :rubrics, :only => [:index, :show, :new, :edit, :destroy]
        match 'settings' => 'settings#edit', :via => :get
        match 'settings' => 'settings#update', :via => :put
      end
    end

    match 'groups/evaluations/(/creator/:creator_id)(/project/:project_id)' => 'courses/evaluations#course_map', :via => :get, :as => 'group_evaluations'
    match 'users/evaluations(/creator/:creator_id)(/project/:project_id)' => 'courses/evaluations#course_map', :via => :get, :as => 'user_evaluations'

    match 'users/creator/:creator_id/project/:project_id' => 'courses/evaluations#user_creator_project_detail', :via => :get, :as => 'user_creator_project_detail'
    match 'users/project/:project_id' => 'courses/evaluations#user_project_detail', :via => :get, :as => 'user_project_detail'
    match 'groups/project/:project_id' => 'courses/evaluations#user_project_detail', :via => :get, :as => 'groups_project_detail'
    match 'view/project/:project_id' => 'courses/evaluations#current_user_project', :via => :get, :as => 'current_user_project'

  end

  resources :rubrics, :controller => 'courses/manage/rubrics', :only => [:index, :show, :new, :edit, :destroy]

  get '/admin' => 'admin/dashboard#index', :as => 'admin_root'
  match '/' => 'dashboard#index', :as => 'dashboard'
  match '/dashboard/evaluator' => 'dashboard#evaluator', :as => 'dashboard_evaluator'
  match '/dashboard/creator' => 'dashboard#creator', :as => 'dashboard_creator'
  match '/dashboard/admin' => 'dashboard#admin', :as => 'dashboard_admin'




#  resources :rubrics, :controller => 'admin/rubrics', :only => [:create, :update, :delete]
#  namespace :admin do
#    resources :rubrics, :only => [:index, :new, :show, :destroy, :edit]
#  end


end
