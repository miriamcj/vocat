class AssignmentsController < ApplicationController
  load_and_authorize_resource :organization
  load_and_authorize_resource :course, :through => :organization
  load_and_authorize_resource :assignment, :through => :course

  # GET /assignments
  # GET /assignments.json
  def index
    @assignments = @course.assignments

    respond_to do |format|
      format.html # index.html.erb
      #format.json { render json: @assignments }
    end
  end

  # GET /assignments/1
  # GET /assignments/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      #format.json { render json: @assignment }
    end
  end

  # GET /assignments/new
  # GET /assignments/new.json
  def new
    @assignment = Assignment.new

    respond_to do |format|
      format.html # new.html.erb
      #format.json { render json: @assignment }
    end
  end

  # GET /assignments/1/edit
  def edit
  end

  # POST /assignments
  # POST /assignments.json
  def create
    @assignment = @course.assignments.build(params[:assignment])

    respond_to do |format|
      if @assignment.save
        format.html { redirect_to @assignment, notice: 'Assignment was successfully created.' }
        #format.json { render json: @assignment, status: :created, location: @assignment }
      else
        format.html { render action: "new" }
        #format.json { render json: @assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /assignments/1
  # PUT /assignments/1.json
  def update
    respond_to do |format|
      if @assignment.update_attributes(params[:assignment])
        format.html { redirect_to organization_course_assignment_path(@organization, @course, @assignment), notice: 'Assignment was successfully updated.' }
        #format.json { head :no_content }
      else
        format.html { render action: "edit" }
        #format.json { render json: @assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assignments/1
  # DELETE /assignments/1.json
  def destroy
    flash[:notice] = "Assignment deleted."
    @assignment.destroy

    respond_to do |format|
      format.html { redirect_to assignments_url }
      #format.json { head :no_content }
    end
  end
end
