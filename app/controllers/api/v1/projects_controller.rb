class Api::V1::ProjectsController < ApiController

	load_and_authorize_resource :course
	load_and_authorize_resource :project
	respond_to :json

	# GET /api/v1/courses/:course_id/projects.json
	def index
		@projects = @course.projects
		respond_with @projects, :root => false
	end

	# PUT /api/v1/projects/:id.json
	def update
		@project.update_attributes(params[:project])
		respond_with(@project)
	end

	# DELETE /api/v1/projects/:id.json
	def destroy
		@project.destroy
		respond_with(@project)
	end

	# GET /api/v1/projects/:id.json
	def show
		respond_with(@project)
	end

	# POST /api/v1/courses/:course_id/projects/:id.json
	def create
		if @project.save
			respond_with @project, :root => false, status: :created, location: api_v1_project_url(@project)
		else
			respond_with @project, :root => false, status: :unprocessable_entity
		end
	end


end
