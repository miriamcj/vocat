/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let NewAsset;
import Marionette from 'marionette';
import template from 'hbs!templates/assets/new_asset';
import AssetModel from 'models/asset';
import AttachmentModel from 'models/attachment';
import iFrameTransport from 'vendor/plugins/iframe_transport';
import FileUpload from 'vendor/plugins/file_upload';
import ShortTextInputView from 'views/property_editor/short_text_input';

export default NewAsset = (function() {
  NewAsset = class NewAsset extends Marionette.ItemView {
    static initClass() {

      this.prototype.template = template;

      this.prototype.ui = {
        testNewButton: '[data-behavior="test-new-asset"]',
        hideManage: '[data-behavior="hide-manage"]',
        uploadForm: '[data-behavior="upload-form"]',
        uploadFormWrapper: '[data-behavior="upload-form-wrapper"]',
        fileInputTrigger: '[data-behavior="file-input-trigger"]',
        fileInput: '[data-behavior="file-input"]',
        dropzone: '[data-behavior="dropzone"]',
        uploadStatus: '[data-behavior="upload-status"]',
        uploadStatusDetail: '[data-behavior="upload-status-detail"]',
        keyInput: 'input[name=key]',
        policyInput: 'input[name=policy]',
        signatureInput: 'input[name=signature]',
        assetUploadingMessage: '[data-behavior="asset-uploading-message"]',
        externalVideoUrl: '[data-behavior="external-video-url"]',
        externalVideoSubmit: '[data-behavior="external-video-url-submit"]',
        progressBar: '[data-behavior="progress-bar"]'
      };

      this.prototype.triggers = {
        'click @ui.externalVideoSubmit': 'handle:external:video:submit',
        'click @ui.hideManage': 'hide:new',
        'click @ui.fileInputTrigger': 'show:file:input',
        'submit @ui.externalVideoForm': 'handle:external:video:submit'
      };

      this.prototype.regex = {
        youtube: /(v=|\.be\/)([^&#]{5,})/,
        vimeo: /^.+vimeo.com\/(.*\/)?([^#\?]*)/
      };
    }

    onHandleExternalVideoSubmit() {
      const url = this.ui.externalVideoUrl.val();
      return this.createRemoteVideoAsset(url);
    }

    createRemoteVideoAsset(url) {
      const vimeoMatches = url.match(this.regex.vimeo);
      if ((vimeoMatches != null) && (vimeoMatches.length > 0)) {
        this.createVimeoAsset(url);
      } else {
        this.createYoutubeAsset(url);
      }
      return this.ui.externalVideoUrl.val('');
    }

    createYoutubeAsset(value) {
      const matches = value.match(this.regex.youtube);
      if ((matches != null) && (matches.length > 0) && (typeof matches[2] === 'string')) {
        const attributes = {
          external_source: 'youtube',
          external_location: matches[2],
          submission_id: this.collection.submissionId
        };
        const asset = new AssetModel(attributes);
        return asset.save({}, {
          success: () => {
            this.collection.add(asset);
            Vocat.vent.trigger('error:add', {level: 'notice', msg: 'The YouTube video has been saved.'});
            const onSave = () => {
              return asset.save({}, {
                success: () => {
                  Vocat.vent.trigger('error:add', {level: 'error', clear: true, msg: 'Media successfully updated.'});
                  return this.render();
                }
                , error: () => {
                  return Vocat.vent.trigger('error:add', {level: 'error', clear: true, msg: 'Unable to update media title.'});
                }
              });
            };
            return Vocat.vent.trigger('modal:open', new ShortTextInputView({
              model: asset,
              vent: this.vent,
              onSave,
              property: 'name',
              saveLabel: 'Update media title',
              inputLabel: 'What would you like to call this media?'
            }));
          }
        });

      } else {
        Vocat.vent.trigger('error:add', {level: 'error', msg: 'The Youtube URL you entered is invalid.'});
        return this.resetUploader();
      }
    }

    createVimeoAsset(value) {
      const matches = value.match(this.regex.vimeo);
      const id = matches ? matches[2] || matches[1] : null;
      if (id) {
        const attributes = {
          external_source: 'vimeo',
          external_location: id,
          submission_id: this.collection.submissionId
        };
        const asset = new AssetModel(attributes);
        return asset.save({}, {
          success: () => {
            this.collection.add(asset);
            Vocat.vent.trigger('error:add', {level: 'notice', msg: 'The Vimeo video has been saved.'});
            const onSave = () => {
              return asset.save({}, {
                success: () => {
                  Vocat.vent.trigger('error:add', {level: 'error', clear: true, msg: 'Media successfully updated.'});
                  return this.render();
                }
                , error: () => {
                  return Vocat.vent.trigger('error:add', {level: 'error', clear: true, msg: 'Unable to update media title.'});
                }
              });
            };
            return Vocat.vent.trigger('modal:open', new ShortTextInputView({
              model: asset,
              vent: this.vent,
              onSave,
              property: 'name',
              saveLabel: 'Update media title',
              inputLabel: 'What would you like to call this media?'
            }));
          }
        });
      } else {
        Vocat.vent.trigger('error:add', {level: 'error', msg: 'The Vimeo URL you entered is invalid.'});
        return this.resetUploader();
      }
    }

    initialize(options) {
      return this.vent = Marionette.getOption(this, 'vent');
    }

    onShowFileInput() {
      return this.ui.fileInput.click();
    }

    onHideNew() {
      return this.vent.trigger('hide:new');
    }

    onRender() {
      this.ui.assetUploadingMessage.hide();
      return this.initializeAsyncUploader();
    }

    hideForm() {
      this.vent.triggerMethod('request:state:uploading');
      this.ui.assetUploadingMessage.show();
      return this.ui.uploadFormWrapper.hide();
    }

    showForm() {
      this.vent.triggerMethod('request:state:manage');
      this.ui.assetUploadingMessage.hide();
      return this.ui.uploadFormWrapper.show();
    }

    initializeAsyncUploader() {
      let attachment = null;
      return this.ui.uploadForm.fileupload({
        multipart: true,
        limitMultiFileUploads: 1,
        limitConcurrentUploads: 1,
        autoUpload: true,
        add: (e, uploadForm) => {
          const file = uploadForm.files[0];
          if (this.fileTypesRegex().test(file.name)) {
            this.hideForm();
            attachment = new AttachmentModel({});
            return attachment.save({'media_file_name': file.name}, {
              success: model => {
                const uploadDocument = attachment.get('s3_upload_document');
                this.ui.keyInput.val(uploadDocument.key);
                this.ui.policyInput.val(uploadDocument.policy);
                this.ui.signatureInput.val(uploadDocument.signature);
                uploadForm.submit();
                this.ui.uploadStatus.html('Uploading...');
                return this.ui.uploadStatusDetail.html("");
              },
              error: () => {
                Vocat.vent.trigger('error:add', {level: 'error', msg: 'Unable to create new attachment model.'});
                return this.resetUploader();
              }
            });
          } else {
            Vocat.vent.trigger('error:add', {
              level: 'error',
              msg: `Invalid file extension. Extension must be one of: ${this.model.get('allowed_extensions').join(', ')}.`
            });
            return this.resetUploader();
          }
        },
        progress: (e, data) => {
          const progress = parseInt((data.loaded / data.total) * 100, 10);
          this.ui.uploadStatus.html("Uploading...");
          this.ui.uploadStatusDetail.html(`${this.toFileSize(data.loaded)} out of ${this.toFileSize(data.total)}`);
          return this.ui.progressBar.width(`${progress}%`);
        },
        fail: (e, data) => {
          Vocat.vent.trigger('error:add', {level: 'error', msg: 'Unable to upload. Please check your internet connection or try again later.'});
          return this.resetUploader();
        },
        done: (e, data) => {
          const asset = new AssetModel({attachment_id: attachment.id, submission_id: this.collection.submissionId});
          this.ui.uploadStatus.html("Saving media to Vocat...");
          this.ui.uploadStatusDetail.html("Please wait.");
          return asset.save({}, {
            success: () => {
              this.collection.add(asset);
              asset.poll();
              Vocat.vent.trigger('error:add', {level: 'error', clear: true, msg: 'Media successfully saved.'});
              const onSave = () => {
                return asset.save({}, {
                  success: () => {
                    Vocat.vent.trigger('error:add', {level: 'error', clear: true, msg: 'Media successfully updated.'});
                    return this.render();
                  }
                  , error: () => {
                    return Vocat.vent.trigger('error:add', {level: 'error', clear: true, msg: 'Unable to update media title.'});
                  }
                });
              };
              Vocat.vent.trigger('modal:open', new ShortTextInputView({
                model: asset,
                vent: this.vent,
                onSave,
                property: 'name',
                saveLabel: 'Update media title',
                inputLabel: 'What would you like to call this media?'
              }));
              return this.resetUploader();
            }
            , error: () => {
              Vocat.vent.trigger('error:add',
                {level: 'error', clear: true, msg: 'The server was unable to save the media.'});
              return this.resetUploader();
            }
          });
        }
      });
    }

    toFileSize(bytes) {
      const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
      if (bytes === 0) { return 'O bytes'; }
      const i = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)));
      return (bytes / Math.pow(1024, i)).toFixed(2) + '' + sizes[i];
    }

    fileTypesRegex() {
      let types = this.model.get('allowed_extensions');
      types = types.join('|');
      const out = `(\\.|\\/)(${types})$`;
      return new RegExp(out, 'i');
    }

    resetUploader() {
      this.ui.uploadForm.fileupload('destroy');
      this.render();
      return this.showForm();
    }

    serializeData() {
      const context = super.serializeData();
      const sd = {
        s3Bucket: window.VocatS3Bucket,
        AWSPublicKey: window.VocatAWSPublicKey,
        project: context
      };
      return sd;
    }
  };
  NewAsset.initClass();
  return NewAsset;
})();
