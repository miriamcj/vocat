class Courses::SettingsController < ApplicationController

  load_and_authorize_resource :course
  layout 'evaluator'


  def edit
  end

  def update
    respond_to do |format|
      if @course.update_attributes({:settings => params[:settings]})
        format.html { redirect_to edit_course_setting_path(@course), notice: 'Course settings were successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end

  end



end