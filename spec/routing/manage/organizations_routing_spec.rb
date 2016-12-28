require "spec_helper"

RSpec.describe Manage::OrganizationsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "http://manage.vocat.dev/organizations").to route_to("manage/organizations#index")
    end

    it "routes to #new" do
      expect(:get => "http://manage.vocat.dev/organizations/new").to route_to("manage/organizations#new")
    end

    it "routes to #show" do
      expect(:get => "http://manage.vocat.dev/organizations/1").to route_to("manage/organizations#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "http://manage.vocat.dev/organizations/1/edit").to route_to("manage/organizations#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "http://manage.vocat.dev/organizations").to route_to("manage/organizations#create")
    end

    it "routes to #update" do
      expect(:put => "http://manage.vocat.dev/organizations/1").to route_to("manage/organizations#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "http://manage.vocat.dev/organizations/1").to route_to("manage/organizations#destroy", :id => "1")
    end

  end
end
