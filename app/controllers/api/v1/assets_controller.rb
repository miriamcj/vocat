class Api::V1::AssetsController < ApplicationController

  load_and_authorize_resource :asset
  respond_to :json

  # POST /api/v1/assets.json
  def create
    @asset.author = current_user
    # If an attachment_id is sent along with the request, associate the attachment with the asset.
    @asset.attach(Attachment.find(params[:attachment_id])) if params[:attachment_id]
    if @asset.save()
      # Due to STI, we need to completely reload the asset so it's given the correct class.
      @asset = Asset.find @asset.id
      respond_with @asset, location: api_v1_asset_url(@asset)
    else
      respond_with @asset, status: :unprocessable_entity, location: nil
    end
  end

  def show
    respond_with(@asset)
  end

  # DELETE /api/v1/assets/:id.json
  def destroy
    @asset.destroy
    respond_with(@asset)
  end

  # PATCH /api/v1/assets/:id.json
  def update
    update_params = asset_params
    update_params[:listing_order_position] = params[:listing_order_position]
    @asset.update_attributes(update_params)
    respond_with(@asset)
  end
end
