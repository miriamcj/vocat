class Api::V1::AssetsController < ApplicationController

  load_and_authorize_resource :asset
  respond_to :json

  def create
    attachment = Attachment.find(params[:attachment_id])
    if attachment.user_id == current_user.id
      @asset.attachment = attachment
      attachment.commit
      @asset.author_id = current_user.id
    end
    if @asset.save()
      # We need to reload the asset so it receives the correct type after the attachment is added.
      # Tl;dr: STI work around
      @asset = Asset.find @asset.id
      respond_with @asset, location: api_v1_asset_url(@asset)
    else
      respond_with @asset, status: :unprocessable_entity, location: nil
    end
  end

  def destroy
    @asset.destroy
    respond_with(@asset)
  end

  # PATCH /api/v1/discussion_posts/:id.json
  def update
    @asset.update_attributes(asset_params)
    respond_with(@asset)
  end
end
