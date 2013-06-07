class Api::V1::AttachmentsController < ApplicationController

  load_and_authorize_resource :submission
  load_and_authorize_resource :attachment, :through => :submission
  load_and_authorize_resource :attachment
  before_filter :find_fileable

  # POST /attachments
  # POST /attachments.json
  def create
    respond_to do |format|
      if @attachment.save
        format.json { render json: @attachment, status: :created }
      else
        format.json { render json: @attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  def find_fileable
    @fileable = @submission
  end
end
