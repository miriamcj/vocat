class BaseCoursesController < ApplicationController
  load_and_authorize_resource :organization
  load_and_authorize_resource :course, :through => :organization

  def index
    @courses = determine_courses
    @projects = Project.where(:course_id => @courses)
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @course = @organization.courses.build

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
  end

  def create
    @course = @organization.courses.build(params[:course])

    if current_user.role? :evaluator
      @course.creators = User.find_all_by_id(params[:creators])
      @course.assistants = User.find_all_by_id(params[:assistants])
    end
    if current_user.role? :admin
      @course.evaluators = User.find_all_by_id(params[:evaluators])
    end

    respond_to do |format|
      if @course.save
        format.html { redirect_to organization_course_path(@organization, @course), notice: 'Course was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    respond_to do |format|
      # Since associations are updated directly in the database
      # we need to save some info to rollback to if the form is invalid
      start_creators = Array.new @course.creators
      start_assistants = Array.new @course.assistants
      start_evaluators = Array.new @course.evaluators

      if current_user.role? :evaluator
        @course.creators = User.find_all_by_id(params[:creators])
        @course.assistants = User.find_all_by_id(params[:assistants])
      end
      if current_user.role? :admin
        @course.evaluators = User.find_all_by_id(params[:evaluators])
      end

      if @course.update_attributes(params[:course])
        format.html { redirect_to organization_course_path(@organization, @course), notice: 'Course was successfully updated.' }
        #format.json { head :no_content }
      else
        # Form was invalid, rollback association updates
        @course.creators = start_creators
        @course.assistants = start_assistants
        @course.evaluators = start_evaluators

        format.html { render action: "edit" }
        #format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    flash[:notice] = "#{@course.name} has been deleted."
    @course.destroy

    respond_to do |format|
      format.html { redirect_to organization_courses_path(@organization) }
      #format.json { head :no_content }
    end
  end

  def determine_courses
    Course.all
  end
end
