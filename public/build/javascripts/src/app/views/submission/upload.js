(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'hbs!templates/submission/upload', 'models/attachment', 'vendor/plugins/file_upload'], function(Marionette, template, Attachment) {
    var UploadView, _ref;

    return UploadView = (function(_super) {
      __extends(UploadView, _super);

      function UploadView() {
        _ref = UploadView.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      UploadView.prototype.template = template;

      UploadView.prototype.ui = {
        upload: '[data-behavior="async-upload"]'
      };

      UploadView.prototype.initialize = function(options) {
        this.vent = Marionette.getOption(this, 'vent');
        this.courseId = Marionette.getOption(this, 'courseId');
        this.listenTo(this.vent, 'upload:open', function(data) {
          return this.triggerMethod('open', data);
        });
        this.listenTo(this.vent, 'upload:close', function(data) {
          return this.triggerMethod('close', data);
        });
        this.listenTo(this.model, 'attachment:upload:started', function(data) {
          return this.triggerMethod('close', data);
        });
        return this.listenTo(this.model, 'attachment:upload:failed', function(data) {
          return this.triggerMethod('open', data);
        });
      };

      UploadView.prototype.onBeforeRender = function() {
        return this.$el.hide();
      };

      UploadView.prototype.onClose = function() {
        return this.$el.slideUp();
      };

      UploadView.prototype.onOpen = function() {
        console.log('open heard');
        return this.$el.slideDown();
      };

      UploadView.prototype.onRender = function() {
        var _this = this;

        return this.ui.upload.fileupload({
          url: "/api/v1/attachments?submission=" + this.model.id,
          dataType: 'json',
          done: function(e, data) {
            _this.attachment = new Attachment(data.result);
            _this.model.attachment = _this.attachment;
            return _this.vent.triggerMethod('attachment:upload:done');
          },
          fail: function(e, data) {
            _this.model.set('is_upload_started', false);
            _this.vent.triggerMethod('attachment:upload:failed');
            return _this.vent.triggerMethod('flash', {
              level: 'error',
              message: 'Your upload file failed. Only video files are allowed and please make sure it is less than 25MB.'
            });
          },
          send: function(e, data) {
            _this.model.set('is_upload_started', true);
            _this.vent.triggerMethod('attachment:upload:started');
            return _this.vent.triggerMethod('flash:flush');
          }
        });
      };

      return UploadView;

    })(Marionette.ItemView);
  });

}).call(this);
