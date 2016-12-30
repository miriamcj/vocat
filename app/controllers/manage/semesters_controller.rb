class Manage::SemestersController < ApplicationController

  include Concerns::ManageConcerns

  def index
    search = {
        :organization_id => params[:organization_id],
        :year => params[:year]
    }
    @page = params[:page] || 1
    @semesters = Semester.search(search).page(params[:page]).order('start_date ASC')
  end

  def new
    @semester = Semester.new
  end

  def create
    @semester = Semester.new(semester_params)
    if @semester.save
      redirect_to semester_path(@semester), notice: 'Semester was successfully created.'
    else
      render :new
    end
  end

  def edit
    @semester = Semester.find(params[:id])
  end

  def show
    @semester = Semester.find(params[:id])
  end

  def update
    @semester = Semester.find(params[:id])
    if @semester.update(semester_params)
      redirect_to edit_semester_path(@semester), notice: 'Semester was successfully updated.'
    else
      render :edit
    end
  end

  def org_index
    @organization = Organization.find(params[:organization_id])
    @semesters = Semester.in_org(@organization).order('start_date DESC')
  end

  def update_all
    @organization = Organization.find(params[:organization_id])
    @semesters = Semester.update(params[:semesters].keys, params[:semesters].values).reject { |s| s.errors.empty? }
    if @semesters.empty?
      flash[:notice] = "Semesters updated"
      redirect_to organization_semesters_path(@organization)
    else
      render :index
    end
  end

  protected

  def semester_params
    params.require(:semester).permit(:name,
                                 :position,
                                 :organization_id,
                                 :start_date,
                                 :end_date
    )
  end

end
