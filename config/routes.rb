Vocat::Application.routes.draw do


  # Top level course route that the user sees after selecting a course. The first route dynamically redirects to one of the other two routes.
  match "/course/:course_id" => "redirect#index", :creator_url => "/course/:course_id/my/exhibits", :evaluator_url => "/course/:course_id/their/exhibits", :as => "course_root"
  match "/course/:course_id/my/exhibits" => "exhibits#mine", :via => :get, :as => "course_my_exhibits"
  match "/course/:course_id/their/exhibits" => "exhibits#theirs", :via => :get, :as => "course_their_exhibits"

  # Top level route that the user sees after logging in. The first route dynamically redirects to one of the other two routes.
  match "/" => "redirect#index", :admin_url => "/admin", :creator_url => "/my/exhibits", :evaluator_url => "/their/exhibits", :as => "org_root"
  match "/my/exhibits" => "exhibits#mine", :via => :get, :as => "my_exhibits"
  match "/their/exhibits" => "exhibits#theirs", :via => :get, :as => "their_exhibits"

  # Exhibit detail route
  match "creator/:creator_id/project/:project_id/exhibit" => "exhibits#show", :via => :get, :as => "creator_project_exhibit"

  # Course map routes
  match "/course_map" => "course_map#index", :via => :get, :as => "course_map"
  match "/course_map/creator/:creator_id/project/:project_id" => "course_map#show_submission_detail", :via => :get, :as => "course_map_submission_detail"
  match "/course_map/creator/:creator_id" => "course_map#show_creator_detail", :via => :get, :as => "course_map_creator_detail"
  match "/project/:project_id" => "course_map#show_project_detail", :via => :get, :as => "course_map_project_detail"

  # Static routes
  get  "/course/:course_id/feedback" => "static#feedback", :as => "course_feedback"
  get  "/static/form"                => "static#form"


  resources :rubrics, :controller => "admin/rubrics", :only => [:create, :update, :delete]

  # Admin routes
  get "/admin" => "admin/dashboard#index", :as => "admin_root"
  namespace :admin do
	  resources :courses do
		  resources :projects
	  end
	  resources :users

    resources :configuration
    resources :organizations, :path => "org"
    resources :rubrics, :only => [:index, :new, :show, :destroy, :edit]
  end

  devise_for :users, :controllers => {:registrations => "registrations"}

  root :to => 'application#index'



  #resources :organizations, :path => "org" do
  #  resources :courses do
  #    resources :projects
  #    resources :submissions do
  #      resources :attachments
  #    end
  #  end
  #end


end
