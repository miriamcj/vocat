Vocat::Application.routes.draw do


  # Top level course route that the user sees after selecting a course. The first route dynamically redirects to one of the other two routes.
  match "/org/:organization_id/course/:course_id" => "redirect#index", :creator_url => "/org/:organization_id/course/:course_id/my/exhibits", :evaluator_url => "/org/:organization_id/course/:course_id/their/exhibits", :as => "course_root"
  match "/org/:organization_id/course/:course_id/my/exhibits" => "exhibits#mine", :via => :get, :as => "org_course_my_exhibits"
  match "/org/:organization_id/course/:course_id/their/exhibits" => "exhibits#theirs", :via => :get, :as => "org_course_their_exhibits"

  # Top level route that the user sees after logging in. The first route dynamically redirects to one of the other two routes.
  match "/org/:organization_id" => "redirect#index", :admin_url => "/admin", :creator_url => "/org/:organization_id/my/exhibits", :evaluator_url => "/org/:organization_id/their/exhibits", :as => "org_root"
  match "/org/:organization_id/my/exhibits" => "exhibits#mine", :via => :get, :as => "org_my_exhibits"
  match "/org/:organization_id/their/exhibits" => "exhibits#theirs", :via => :get, :as => "org_their_exhibits"

  # Exhibit detail route
  match "/org/:organization_id/course/:course_id/creator/:creator_id/project/:project_id/exhibit" => "exhibits#show", :via => :get, :as => "org_course_creator_project_exhibit"

  # Course map routes
  match "/org/:organization_id/course/:course_id/course_map" => "course_map#index", :via => :get, :as => "course_map"
  match "/org/:organization_id/course/:course_id/course_map/creator/:creator_id/project/:project_id" => "course_map#show_submission_detail", :via => :get, :as => "course_map_submission_detail"
  match "/org/:organization_id/course/:course_id/course_map/creator/:creator_id" => "course_map#show_creator_detail", :via => :get, :as => "course_map_creator_detail"
  match "/org/:organization_id/course/:course_id/course_map/project/:project_id" => "course_map#show_project_detail", :via => :get, :as => "course_map_project_detail"

  # Static routes
  get  "/org/:organization_id/course/:course_id/feedback" => "static#feedback", :as => "org_course_feedback"
  get  "static/form"                => "static#form"

  get "/admin" => "admin#index", :as => "admin_root"

  resources :rubrics, :only => [:create, :update, :delete]

  # Admin routes
  scope "admin", :as => "admin" do
    resources :configuration
    resources :users
    resources :organizations, :path => "org"
    resources :rubrics, :only => [:index, :new, :show, :destroy, :edit]
    resources :courses do
	    resources :projects
    end
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
