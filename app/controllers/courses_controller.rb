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
    params[:instructors][:id] = params[:instructors][:id].keep_if {|i| i != ""}
    if current_user.role?(:instructor) && params[:instructors][:id].empty?
      flash[:error] = "You must specify at least one instructor for the course."
      redirect_to :action => :new
      return
    end
    @course = @organization.courses.build(params[:course])

    respond_to do |format|
      if @course.save
        if current_user.role? :admin
          instructors = User.find_all_by_id(params[:instructors][:id])
          @course.add_instructors instructors
        elsif current_user.role? :instructor
          @course.add_instructor User.find_by_id(params[:instructors][:id])
        end
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
      if @course.update_attributes(params[:course])
        format.html { redirect_to organization_course_path(@organization, @course), notice: 'Course was successfully updated.' }
        #format.json { head :no_content }
      else
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
