Vocat::Application.routes.draw do

  match "/org/:organization_id/submissions" => "submissions#index", :via => :get, :as => "submission_overview"

  resources :organizations, :path => "org" do
    resources :courses do
      resources :projects do#, :shallow => true, :shallow_path => "/org/:organization_id/courses/:course_id", :name_prefix => "organization_course_" do
        resources :submissions do
          resources :attachments
        end
      end
    end
  end

  devise_for :users, :controllers => {:registrations => "registrations"}

  root :to => 'organizations#index' # The organization id is set by ApplicationController::after_sign_in_path_for()

end
