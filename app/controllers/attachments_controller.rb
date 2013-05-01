class AttachmentsController < ApplicationController

  load_and_authorize_resource :submission
  load_and_authorize_resource :attachment, :through => :submission
  load_and_authorize_resource :attachment
  before_filter :find_fileable

  # GET /attachments
  # GET /attachments.json
  def index
    @attachments = @fileable.attachments

    respond_to do |format|
      format.html # course_map.html.erb
      #format.json { render json: @attachments }
    end
  end

  # GET /attachments/1
  # GET /attachments/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      #format.json { render json: @attachment }
    end
  end

  # GET /attachments/new
  # GET /attachments/new.json
  def new
    @attachment = Attachment.new

    respond_to do |format|
      format.html # new.html.erb
      #format.json { render json: @attachment }
    end
  end

  # GET /attachments/1/edit
  def edit
  end

  # POST /attachments
  # POST /attachments.json
  def create

    respond_to do |format|
      if @attachment.save
        format.html { redirect_to @attachment, notice: 'Attachment was successfully created.' }
        format.json { render json: @attachment, status: :created, location: @attachment}
      else
        format.html { render action: "new" }
        format.json { render json: @attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /attachments/1
  # PUT /attachments/1.json
  def update
    respond_to do |format|
      if @attachment.update_attributes(params[:attachment])
        format.html { redirect_to @attachment, notice: 'Attachment was successfully updated.' }
        #format.json { head :no_content }
      else
        format.html { render action: "edit" }
        #format.json { render json: @attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attachments/1
  # DELETE /attachments/1.json
  def destroy
    @attachment.destroy

    respond_to do |format|
      format.html { redirect_to attachments_url }
      #format.json { head :no_content }
    end
  end

  def find_fileable
    @fileable = @submission
  end
end
