class Admin::RubricsController < Admin::AdminController

  load_and_authorize_resource :rubric, :through => :the_current_organization
  before_action :org_validate_rubric
  respond_to :html

  # GET /admin/rubrics
  def index
    search = {
        :name => params[:name],
        :public => params[:public],
    }
    @rubrics = @current_organization.rubrics.search(search).page params[:page]
  end

  # GET /admin/rubrics/new
  def new
    respond_with @rubric
  end

  # GET /admin/rubrics/1
  def show
    respond_with @rubric
  end

  # GET /admin/rubrics/1/export
  def export

  end

  # GET /admin/rubrics/1/edit
  def edit
    # Editing happens via API endpoint
    respond_with @rubric
  end

  # POST /admin/rubrics/1/clone
  def clone
    new_rubric = @rubric.clone()
    current_user.rubrics << new_rubric
    new_rubric.save()
    redirect_to :action => 'edit', :id => new_rubric.id
  end

  # DELETE /admin/rubrics/1
  def destroy
    @rubric.destroy()
    respond_with :admin, @rubric
  end


end
