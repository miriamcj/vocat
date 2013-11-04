class Api::V1::ProjectsController < ApiController

	load_and_authorize_resource :project
	respond_to :json

	# GET /api/v1/projects.json?course=:course
	def index
    @course = Course.find(params.require(:course))
		@projects = @course.projects
		respond_with @projects
	end

	# PUT /api/v1/projects/:id.json
  # PATCH /api/v1/projects/:id.json
	def update
		@project.update_attributes(project_params)
		respond_with(@project)
	end

	# DELETE /api/v1/projects/:id.json
	def destroy
		@project.destroy
		respond_with(@project)
	end

	# GET /api/v1/projects/:id.json
	def show
		respond_with @project, :root => false
	end

	# POST /api/v1/projects.json
	def create
		if @project.save
			respond_with @project, :root => false, status: :created, location: api_v1_project_url(@project)
		else
			respond_with @project, :root => false, status: :unprocessable_entity
		end
	end


end
