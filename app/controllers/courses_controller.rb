class CoursesController < ApplicationController

  load_resource
  authorize_resource :course, :except => :dashboard
  layout 'content'

  respond_to :html, :json

  def portfolio
    respond_with do |format|
      format.html { render :template => 'dashboard/creator' }
    end
  end

  #def index
  #  @courses = Course.all()
  #  respond_to do |format|
  #    format.html
  #  end
  #end
  #
  #def show
  #  respond_with @course
  #end
  #
  #def new
  #  @organization = current_user.organization
  #  @course = @organization.courses.build
  #  respond_to do |format|
  #    format.html # new.html.erb
  #  end
  #end
  #
  #def edit
  #  @course = Course.find(params[:id])
  #end
  #
  #def create
  #  @organization = current_user.organization
  #  @course = @organization.courses.build(params[:course])
  #  @course.creators = User.find_all_by_id(params[:creators])
  #  @course.assistants = User.find_all_by_id(params[:assistants])
  #  @course.evaluators = User.find_all_by_id(params[:evaluators])
  #
  #  respond_to do |format|
  #    if @course.save
  #      format.html { redirect_to admin_course_path(@course), notice: 'Course was successfully created.' }
  #    else
  #      format.html { render action: "new" }
  #    end
  #  end
  #end
  #
  #def update
  #  respond_to do |format|
  #    # Since associations are updated directly in the database
  #    # we need to save some info to rollback to if the form is invalid
  #    start_creators = Array.new @course.creators
  #    start_assistants = Array.new @course.assistants
  #    start_evaluators = Array.new @course.evaluators
  #
  #    if current_user.role? :evaluator
  #      @course.creators = User.find_all_by_id(params[:creators])
  #      @course.assistants = User.find_all_by_id(params[:assistants])
  #    end
  #    if current_user.role? :admin
  #      @course.evaluators = User.find_all_by_id(params[:evaluators])
  #    end
  #
  #    if @course.update_attributes(params[:course])
  #      format.html { redirect_to admin_course_path(@course), notice: 'Course was successfully updated.' }
  #      #format.json { head :no_content }
  #    else
  #      # Form was invalid, rollback association updates
  #      @course.creators = start_creators
  #      @course.assistants = start_assistants
  #      @course.evaluators = start_evaluators
  #
  #      format.html { render action: "edit" }
  #      #format.json { render json: @course.errors, status: :unprocessable_entity }
  #    end
  #  end
  #end
  #
  #def destroy
  #  flash[:notice] = "#{@course.name} has been deleted."
  #  @course.destroy
  #
  #  respond_to do |format|
  #    format.html { redirect_to admin_courses_path }
  #    #format.json { head :no_content }
  #  end
  #end

  def determine_courses
    Course.all
  end
end
