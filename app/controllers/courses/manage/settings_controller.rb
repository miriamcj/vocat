class Courses::Manage::SettingsController < ApplicationController

  layout 'frames'

  load_and_authorize_resource :course
  before_filter :disable_layout_messages

  def edit
  end

  def update
    respond_to do |format|
      if @course.update_attributes!(settings: course_settings_params)
        format.html { redirect_to course_manage_settings_path(@course), notice: 'Course settings were successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end

  end


end