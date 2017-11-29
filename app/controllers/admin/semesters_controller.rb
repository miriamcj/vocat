module Admin
  class SemestersController < ApplicationController

    load_and_authorize_resource :semester, :through => :the_current_organization
    before_filter :org_validate_semester

    def index
      search = {
          :organization_id => @current_organization.id,
          :year => params[:year]
      }
      @page = params[:page] || 1
      @semesters = Semester.search(search).page(params[:page]).order('start_date ASC')
    end

    def new
      @semester = @current_organization.semesters.build
    end

    def create
      @semester = @current_organization.semesters.build(semester_params)
      if @semester.save
        redirect_to admin_semester_path(@semester), notice: 'Semester was successfully created.'
      else
        render :new
      end
    end

    def edit
      @semester = @current_organization.semesters.find(params[:id])
    end

    def show
      @semester = @current_organization.semesters.find(params[:id])
    end

    def update
      @semester = Semester.find(params[:id])
      if @semester.update(semester_params)
        redirect_to edit_admin_semester_path(@semester), notice: 'Semester was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @semester = @current_organization.semesters.find(params[:id])
      if @semester.destroy
        redirect_to admin_semesters_path, notice: 'Semester was successfully destroyed.'
      else
        redirect_to admin_semesters_path, alert: @semester.errors.full_messages
      end
    end

    def academic_calendar
      @semesters = @current_organization.semesters.order('start_date DESC')
    end

    def update_all
      @semesters = Semester.update(params[:semesters].keys, params[:semesters].values).reject { |s| s.errors.empty? }
      if @semesters.empty?
        flash[:notice] = "Semesters updated"
        redirect_to admin_semesters_path
      else
        render :index
      end
    end

    protected

    def semester_params
      params.require(:semester).permit(:name,
                                       :organization_id,
                                       :start_date,
                                       :end_date
      )
    end

  end

end