require 'spec_helper'

RSpec.describe Admin::CoursesController, type: :controller do

  login_admin

  before(:each) do
    @request.host = "#{subject.current_user.organization.subdomain}.vocat.dev"
  end

  # This should return the minimal set of attributes required to create a valid
  # Admin::Organization. As you add validations to Admin::Organization, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    c = FactoryGirl.build(:course)
    c.attributes
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # Admin::OrganizationsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all org courses as @courses" do
      course = Course.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:courses).to_a).to eq([course])
    end
  end
  #
  # describe "GET #show" do
  #   it "assigns the requested admin_organization as @admin_organization" do
  #     organization = Admin::Organization.create! valid_attributes
  #     get :show, {:id => organization.to_param}, valid_session
  #     expect(assigns(:admin_organization)).to eq(organization)
  #   end
  # end
  #
  # describe "GET #new" do
  #   it "assigns a new admin_organization as @admin_organization" do
  #     get :new, {}, valid_session
  #     expect(assigns(:admin_organization)).to be_a_new(Admin::Organization)
  #   end
  # end
  #
  # describe "GET #edit" do
  #   it "assigns the requested admin_organization as @admin_organization" do
  #     organization = Admin::Organization.create! valid_attributes
  #     get :edit, {:id => organization.to_param}, valid_session
  #     expect(assigns(:admin_organization)).to eq(organization)
  #   end
  # end
  #
  # describe "POST #create" do
  #   context "with valid params" do
  #     it "creates a new Admin::Organization" do
  #       expect {
  #         post :create, {:admin_organization => valid_attributes}, valid_session
  #       }.to change(Admin::Organization, :count).by(1)
  #     end
  #
  #     it "assigns a newly created admin_organization as @admin_organization" do
  #       post :create, {:admin_organization => valid_attributes}, valid_session
  #       expect(assigns(:admin_organization)).to be_a(Admin::Organization)
  #       expect(assigns(:admin_organization)).to be_persisted
  #     end
  #
  #     it "redirects to the created admin_organization" do
  #       post :create, {:admin_organization => valid_attributes}, valid_session
  #       expect(response).to redirect_to(Admin::Organization.last)
  #     end
  #   end
  #
  #   context "with invalid params" do
  #     it "assigns a newly created but unsaved admin_organization as @admin_organization" do
  #       post :create, {:admin_organization => invalid_attributes}, valid_session
  #       expect(assigns(:admin_organization)).to be_a_new(Admin::Organization)
  #     end
  #
  #     it "re-renders the 'new' template" do
  #       post :create, {:admin_organization => invalid_attributes}, valid_session
  #       expect(response).to render_template("new")
  #     end
  #   end
  # end
  #
  # describe "PUT #update" do
  #   context "with valid params" do
  #     let(:new_attributes) {
  #       skip("Add a hash of attributes valid for your model")
  #     }
  #
  #     it "updates the requested admin_organization" do
  #       organization = Admin::Organization.create! valid_attributes
  #       put :update, {:id => organization.to_param, :admin_organization => new_attributes}, valid_session
  #       organization.reload
  #       skip("Add assertions for updated state")
  #     end
  #
  #     it "assigns the requested admin_organization as @admin_organization" do
  #       organization = Admin::Organization.create! valid_attributes
  #       put :update, {:id => organization.to_param, :admin_organization => valid_attributes}, valid_session
  #       expect(assigns(:admin_organization)).to eq(organization)
  #     end
  #
  #     it "redirects to the admin_organization" do
  #       organization = Admin::Organization.create! valid_attributes
  #       put :update, {:id => organization.to_param, :admin_organization => valid_attributes}, valid_session
  #       expect(response).to redirect_to(organization)
  #     end
  #   end
  #
  #   context "with invalid params" do
  #     it "assigns the admin_organization as @admin_organization" do
  #       organization = Admin::Organization.create! valid_attributes
  #       put :update, {:id => organization.to_param, :admin_organization => invalid_attributes}, valid_session
  #       expect(assigns(:admin_organization)).to eq(organization)
  #     end
  #
  #     it "re-renders the 'edit' template" do
  #       organization = Admin::Organization.create! valid_attributes
  #       put :update, {:id => organization.to_param, :admin_organization => invalid_attributes}, valid_session
  #       expect(response).to render_template("edit")
  #     end
  #   end
  # end
  #
  # describe "DELETE #destroy" do
  #   it "destroys the requested admin_organization" do
  #     organization = Admin::Organization.create! valid_attributes
  #     expect {
  #       delete :destroy, {:id => organization.to_param}, valid_session
  #     }.to change(Admin::Organization, :count).by(-1)
  #   end
  #
  #   it "redirects to the admin_organizations list" do
  #     organization = Admin::Organization.create! valid_attributes
  #     delete :destroy, {:id => organization.to_param}, valid_session
  #     expect(response).to redirect_to(admin_organizations_url)
  #   end
  # end

end
