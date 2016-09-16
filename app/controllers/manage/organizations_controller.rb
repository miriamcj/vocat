class Manage::OrganizationsController < ApplicationController

  include Concerns::ManageConcerns

  load_and_authorize_resource :organization
  respond_to :html

  # GET manage.domain.com/organizations
  def index
    myvar = params
    @page = params[:page] || 1
    @stats = Statistics::manage_org_stats()
    @organizations = Organization.all.page(params[:page])
  end

  # GET manage.domain.com/organizations/1
  def show
    @stats = Statistics::single_organization_stats(@organization)
  end

  # GET manage.domain.com/organizations/new
  def new
    @organization = Organization.new
  end

  # GET manage.domain.com/organizations/1/edit
  def edit
    @organization = Organization.find(params[:id])
  end

  # POST manage.domain.com/organizations
  def create
    @organization = Organization.new(organization_params)
    handle_logo_upload(@organization)
    if @organization.save
      redirect_to organization_path(@organization), notice: 'Organization was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT manage.domain.com/organizations/1
  def update
    handle_logo_upload(@organization)
    org_params = organization_params
    org_params = org_params.except(:ldap_bind_password) if org_params[:ldap_bind_password].blank?
    if @organization.update(org_params)
      redirect_to edit_organization_path(@organization), notice: 'Organization was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE manage.domain.com/organizations/1
  def destroy
    @organization.destroy
    redirect_to organizations_url, notice: 'Organization was successfully destroyed.'
  end

  private


  def handle_logo_upload(organization)
    if params[:organization][:logo]
      uploaded_io = params[:organization][:logo]
      ext = File.extname(uploaded_io.original_filename)
      filename = "org_logo_#{organization.id}#{ext}"
      organization.logo = filename
      if uploaded_io
        File.open(Rails.root.join('public', 'uploads', filename), 'wb') do |file|
          file.write(uploaded_io.read)
        end

      end
    end
  end


end
