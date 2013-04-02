class Admin::RubricsController < ApplicationController

	load_and_authorize_resource :rubric

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
        format.json { render json: @rubric, status: :created, location: @rubric}
      else
				format.html { render action: "new" }
        format.json { render json: @rubric.errors, status: :unprocessable_entity }
			end
		end
	end

	def update
		respond_to do |format|
			if @rubric.update_attributes(params[:rubric])
				format.html { redirect_to admin_rubric_path(@rubric), notice: 'Rubric was successfully updated.' }
        format.json { head :no_content }
			else
				format.html { render action: "edit" }
        format.json { render json: @rubric.errors, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		flash[:notice] = "Rubric deleted."
		@rubric.destroy

		respond_to do |format|
			format.html { redirect_to admin_rubrics_path() }
			format.json { head :no_content }
		end
	end
end
