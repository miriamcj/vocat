define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/assets/new_asset')
  AssetModel = require('models/asset')
  AttachmentModel = require('models/attachment')
  iFrameTransport= require('vendor/plugins/iframe_transport')
  FileUpload = require('vendor/plugins/file_upload')

  class NewAsset extends Marionette.ItemView

    template: template

    ui: {
      testNewButton: '[data-behavior="test-new-asset"]'
      hideManage: '[data-behavior="hide-manage"]'
      uploadForm: '[data-behavior="upload-form"]'
      uploadFormWrapper: '[data-behavior="upload-form-wrapper"]'
      fileInputTrigger: '[data-behavior="file-input-trigger"]'
      fileInput: '[data-behavior="file-input"]'
      dropzone: '[data-behavior="dropzone"]'
      keyInput: 'input[name=key]'
      policyInput: 'input[name=policy]'
      signatureInput: 'input[name=signature]'
      assetUploadingMessage: '[data-behavior="asset-uploading-message"]'
      externalVideoForm: '[data-behavior="external-video-form"]'
      externalVideoUrl: '[data-behavior="external-video-url"]'
      progressBar: '[data-behavior="progress-bar"]'
    }

    triggers: {
      'click @ui.hideManage': 'hide:new'
      'click @ui.fileInputTrigger': 'show:file:input'
      'submit @ui.externalVideoForm': 'handle:external:video:submit'
    }

    regex: {
      youtube: /(v=|\.be\/)([^&#]{5,})/
      vimeo: /^.+vimeo.com\/(.*\/)?([^#\?]*)/
    }

    onHandleExternalVideoSubmit: () ->
      url = @ui.externalVideoUrl.val()
      @createRemoteVideoAsset(url)

    createRemoteVideoAsset: (url) ->
      vimeoMatches = url.match(@regex.vimeo)
      if vimeoMatches? && vimeoMatches.length > 0
        @createVimeoAsset(url)
      else
        @createYoutubeAsset(url)

    createYoutubeAsset: (value) ->
      matches = value.match(@regex.youtube)
      if matches? && matches.length > 0 && typeof matches[2] == 'string'
        attributes = {
          external_source: 'youtube'
          external_location: matches[2]
          submission_id: @collection.submissionId
        }
        asset = new AssetModel(attributes)
        asset.save({}, {success: () =>
          console.log asset,'a'
          @collection.add(asset)
          Vocat.vent.trigger('error:add', {level: 'notice', msg: 'The YouTube asset has been saved.'})
        })
      else
        Vocat.vent.trigger('error:add', {level: 'error', msg: 'The Youtube URL you entered is invalid.'})
        @resetUploader()

    createVimeoAsset: (value) ->
      matches = value.match(@regex.vimeo)
      id = if matches then matches[2] || matches[1] else null
      if id
        attributes = {
          external_source: 'vimeo'
          external_location: id
          submission_id: @collection.submissionId
        }
        asset = new AssetModel(attributes)
        asset.save({}, {success: () =>
          @collection.add(asset)
          Vocat.vent.trigger('error:add', {level: 'notice', msg: 'The Vimeo asset has been saved.'})
        })
      else
        Vocat.vent.trigger('error:add', {level: 'error', msg: 'The Vimeo URL you entered is invalid.'})
        @resetUploader()

    initialize: (options) ->
      @vent = Marionette.getOption(@, 'vent')

    onShowFileInput: () ->
      @ui.fileInput.click()

    onHideNew: () ->
      @vent.trigger('hide:new')

    onRender: () ->
      console.log 'rendered'
      @ui.assetUploadingMessage.hide()
      @initializeAsyncUploader()

    hideForm: () ->
      @ui.assetUploadingMessage.show()
      @ui.uploadFormWrapper.hide()

    showForm: () ->
      @ui.assetUploadingMessage.hide()
      @ui.uploadFormWrapper.show()

    initializeAsyncUploader: () ->
      attachment = null
      @ui.uploadForm.fileupload({
        multipart: true
        limitMultiFileUploads: 1
        limitConcurrentUploads: 1
        autoUpload: true
        add: (e, uploadForm) =>
          console.log uploadForm,'uf'
          file = uploadForm.files[0];
          console.log file,'ft'
          if @fileTypesRegex().test(file.name)
            @hideForm()
            attachment = new AttachmentModel({})
            attachment.save({'media_file_name': file.name}, {
              success: (model) =>
                uploadDocument = attachment.get('s3_upload_document')
                @ui.keyInput.val(uploadDocument.key)
                @ui.policyInput.val(uploadDocument.policy)
                @ui.signatureInput.val(uploadDocument.signature)
                uploadForm.submit()
              error: () =>
                Vocat.vent.trigger('error:add', {level: 'error', msg: 'Unable to create new attachment model.'})
                @resetUploader()
            })
          else
            Vocat.vent.trigger('error:add', {level: 'error', msg: "Invalid file extension. Extension must be one of: #{@model.get('allowed_extensions').join(', ')}."})
            @resetUploader()
        progress: (e, data) =>
          progress = parseInt(data.loaded / data.total * 100, 10)
          @ui.progressBar.width("#{progress}%")
        fail: (e, data) =>
          Vocat.vent.trigger('error:add', {level: 'error', msg: 'Unable to upload file to Amazon S3.'})
          @resetUploader()
        done: (e, data) =>
          asset = new AssetModel({attachment_id: attachment.id, submission_id: @collection.submissionId})
          asset.save({},{success: () =>
            @collection.add(asset)
            Vocat.vent.trigger('error:add', {level: 'error', msg: 'The new asset has been saved.'})
            @resetUploader()
          , error: () =>
            Vocat.vent.trigger('error:add', {level: 'error', msg: 'The server was unable to save the asset.'})
            @resetUploader()
          })
      })

    fileTypesRegex: () ->
      types = @model.get('allowed_extensions')
      types = types.join('|')
      out = "(\\.|\\/)(#{types})$"
      new RegExp(out, 'i')

    resetUploader: () ->
      @ui.uploadForm.fileupload('destroy')
      @render()
      @showForm()

    serializeData: () ->
      context = super()
      sd = {
        s3Bucket: window.VocatS3Bucket
        AWSPublicKey: window.VocatAWSPublicKey
        project: context
      }
      sd
