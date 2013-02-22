Vocat::Application.routes.draw do

  resources :organizations, :path => "org" do
    resources :courses do
      resources :assignments do#, :shallow => true, :shallow_path => "/org/:organization_id/courses/:course_id", :name_prefix => "organization_course_" do
        resources :submissions do
          resources :attachments
        end
      end
    end
  end

  devise_for :users, :controllers => {:registrations => "registrations"}

  root :to => 'organizations#index' # The organization id is set by ApplicationController::after_sign_in_path_for()

end
