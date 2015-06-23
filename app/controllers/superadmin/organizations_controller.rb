class Superadmin::OrganizationsController < Superadmin::SuperadminController

  load_and_authorize_resource :organization
  respond_to :html

  # GET /admin/organizations
  def index
    @organizations = Organization.all.page(params[:page])
  end

  # GET /admin/organizations/1
  def show
  end

  # GET /admin/organizations/new
  def new
    @organization = Organization.new
  end

  # GET /admin/organizations/1/edit
  def edit
    @organization = Organization.find(params[:id])
  end

  # POST /admin/organizations
  def create
    @admin_organization = Organization.new(organization_params)

    if @admin_organization.save
      redirect_to @admin_organization, notice: 'Organization was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /admin/organizations/1
  def update
    if @organization.update(organization_params)
      redirect_to superadmin_organization_path(@organization), notice: 'Organization was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /admin/organizations/1
  def destroy
    @admin_organization.destroy
    redirect_to admin_organizations_url, notice: 'Organization was successfully destroyed.'
  end

  # private
  #   # Use callbacks to share common setup or constraints between actions.
  #   def set_admin_organization
  #     @admin_organization = Organization.find(params[:id])
  #   end
  #
  #   # Only allow a trusted parameter "white list" through.
  #   def admin_organization_params
  #     params[:admin_organization]
  #   end
end
