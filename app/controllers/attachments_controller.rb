class AttachmentsController < ApplicationController
  load_and_authorize_resource :organization
  load_and_authorize_resource :course, :through => :organization
  load_and_authorize_resource :assignment, :through => :course

  #
  # polymorphic association:
  #
  # load the submission resource AND load
  # whatever else that the attachment can belong_to
  #
  load_and_authorize_resource :submission, :through => :assignment
# load_and_authorize_resource :other_fileable

  #
  # then add that other thing to the array of possible :through classes
  #
  load_and_authorize_resource :attachment, :through => :submission
# load_and_authorize_resource :attachment, :through => [:submission, :other_fileable]

  #
  # and then modify find_fileable to use the appropriate fileable class
  #

  before_filter :find_fileable

  # GET /attachments
  # GET /attachments.json
  def index
    @attachments = @fileable.attachments

    respond_to do |format|
      format.html # index.html.erb
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
    @attachment = @fileable.attachments.build(params[:attachment])

    respond_to do |format|
      if @attachment.save
        format.html { redirect_to @attachment, notice: 'Attachment was successfully created.' }
        format.json # create.json.erb
      else
        format.html { render action: "new" }
        #format.json { render json: @attachment.errors, status: :unprocessable_entity }
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
#   @fileable = @submission || @other_fileable
  end
end
