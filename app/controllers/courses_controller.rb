class CoursesController < ApplicationController
  load_and_authorize_resource :organization
  load_and_authorize_resource :course, :through => :organization

  # GET /courses
  # GET /courses.json
  def index
    respond_to do |format|
      format.html # index.html.erb
      #format.json { render json: @courses }
    end
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      #format.json { render json: @course }
    end
  end

  # GET /courses/new
  # GET /courses/new.json
  def new
    @course = @organization.courses.build

    respond_to do |format|
      format.html # new.html.erb
      #format.json { render json: @course }
    end
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses
  # POST /courses.json
  def create
    @course = @organization.courses.build(params[:course])

    if current_user.role? :instructor
      @course.students = User.find_all_by_id(params[:students])
      @course.helpers = User.find_all_by_id(params[:helpers])
    end
    if current_user.role? :admin
      @course.instructors = User.find_all_by_id(params[:instructors])
    end

    respond_to do |format|
      if @course.save
        format.html { redirect_to organization_course_path(@organization, @course), notice: 'Course was successfully created.' }
        #format.json { render json: @course, status: :created, location: @course }
      else
        format.html { render action: "new" }
        #format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /courses/1
  # PUT /courses/1.json
  def update
    respond_to do |format|
      # Since associations are updated directly in the database
      # we need to save some info to rollback to if the form is invalid
      start_students = Array.new @course.students
      start_helpers = Array.new @course.helpers
      start_instructors = Array.new @course.instructors

      if current_user.role? :instructor
        @course.students = User.find_all_by_id(params[:students])
        @course.helpers = User.find_all_by_id(params[:helpers])
      end
      if current_user.role? :admin
        @course.instructors = User.find_all_by_id(params[:instructors])
      end

      if @course.update_attributes(params[:course])
        format.html { redirect_to organization_course_path(@organization, @course), notice: 'Course was successfully updated.' }
        #format.json { head :no_content }
      else
        # Form was invalid, rollback association updates
        @course.students = start_students
        @course.helpers = start_helpers
        @course.instructors = start_instructors

        format.html { render action: "edit" }
        #format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    flash[:notice] = "#{@course.name} has been deleted."
    @course.destroy

    respond_to do |format|
      format.html { redirect_to organization_courses_path(@organization) }
      #format.json { head :no_content }
    end
  end
end
