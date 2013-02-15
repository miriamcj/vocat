class AttachmentsController < ApplicationController
  # GET /attachments
  # GET /attachments.json
  def index
    @fileable = find_fileable
    @attachments = Attachment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @attachments }
    end
  end

  # GET /attachments/1
  # GET /attachments/1.json
  def show
    @fileable = find_fileable
    @attachment = Attachment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @attachment }
    end
  end

  # GET /attachments/new
  # GET /attachments/new.json
  def new
    @fileable = find_fileable
    @attachment = Attachment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @attachment }
    end
  end

  # GET /attachments/1/edit
  def edit
    @fileable = find_fileable
    @attachment = Attachment.find(params[:id])
  end

  # POST /attachments
  # POST /attachments.json
  def create
    @fileable = find_fileable
    @attachment = @fileable.attachments.build(params[:attachment])

    respond_to do |format|
      if @attachment.save
        format.html { redirect_to @attachment, notice: 'Attachment was successfully created.' }
        format.json # create.json.erb
      else
        format.html { render action: "new" }
        format.json { render json: @attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /attachments/1
  # PUT /attachments/1.json
  def update
    @attachment = Attachment.find(params[:id])

    respond_to do |format|
      if @attachment.update_attributes(params[:attachment])
        format.html { redirect_to @attachment, notice: 'Attachment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attachments/1
  # DELETE /attachments/1.json
  def destroy
    @attachment = Attachment.find(params[:id])
    @attachment.destroy

    respond_to do |format|
      format.html { redirect_to attachments_url }
      format.json { head :no_content }
    end
  end

  def find_fileable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
end
