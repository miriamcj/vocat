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
      fileInputTrigger: '[data-behavior="file-input-trigger"]'
      fileInput: '[data-behavior="file-input"]'
      dropzone: '[data-behavior="dropzone"]'
      keyInput: 'input[name=key]'
      policyInput: 'input[name=policy]'
      signatureInput: 'input[name=signature]'
      assetUploadingMessage: '[data-behavior="asset-uploading-message"]'
    }

    triggers: {
      'click @ui.hideManage': 'hide:new'
      'click @ui.fileInputTrigger': 'show:file:input'
    }

    initialize: (options) ->
      @vent = Marionette.getOption(@, 'vent')

    onShowFileInput: () ->
      console.log @ui.fileInput.length
      @ui.fileInput.click()

    onHideNew: () ->
      @vent.trigger('hide:new')

    onRender: () ->
      @ui.assetUploadingMessage.hide()
      @initializeAsyncUploader()

    hideForm: () ->
      @ui.assetUploadingMessage.show()
      @ui.uploadForm.hide()

    showForm: () ->
      @ui.assetUploadingMessage.hide()
      @ui.uploadForm.show()

    initializeAsyncUploader: () ->
#      $(document).bind('drop dragover', (e) ->
#        console.log e,'rambo kill you'
#        e.preventDefault()
#      )
#
#      console.log @ui.dropzone.length, 'dz'
#      @ui.dropzone.css({border: '5px solid red'})
      attachment = null
      @ui.uploadForm.fileupload({
        multipart: true
        limitMultiFileUploads: 1
        limitConcurrentUploads: 1
        autoUpload: true
        drop: () =>
          console.log 'heard drop'
        add: (e, uploadForm) =>
          @hideForm()
          attachment = new AttachmentModel({})
          attachment.save({'media_file_name': uploadForm.files[0].name}, {
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
        fail: (e, data) =>
          Vocat.vent.trigger('error:add', {level: 'error', msg: 'Unable to upload file to S3.'})
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

    resetUploader: () ->
      console.log 'reseting'
      @ui.uploadForm.fileupload('destroy')
      @render()
      @showForm()

    serializeData: () ->
      sd = {
        s3Bucket: window.VocatS3Bucket
        AWSPublicKey: window.VocatAWSPublicKey
      }
      sd
