class RubricsController < ApplicationController

	load_and_authorize_resource :rubric
	layout 'admin'

	def index
		@rubrics = Rubric.all()

		respond_to do |format|
			format.html
		end
	end

	def show
		respond_to do |format|
			format.html
		end
	end

	def new
		respond_to do |format|
			format.html
		end
	end

	def edit
	end

	def create

		respond_to do |format|
			if @rubric.save
				format.html { redirect_to @rubric, notice: 'Rubric was successfully created.' }
			else
				format.html { render action: "new" }
			end
		end
	end

	def update
		respond_to do |format|
			if @rubric.update_attributes(params[:rubric])
				format.html { redirect_to admin_rubric_path(@rubric), notice: 'Rubric was successfully updated.' }
			else
				format.html { render action: "edit" }
			end
		end
	end

	def destroy
		flash[:notice] = "Rubric deleted."
		@project.destroy

		respond_to do |format|
			format.html { redirect_to admin_rubric_path(@rubric) }
			format.json { head :no_content }
		end
	end
end
