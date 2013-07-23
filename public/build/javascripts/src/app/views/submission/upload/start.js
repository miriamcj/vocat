(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'hbs!templates/submission/upload/start'], function(Marionette, template) {
    var UploadShowView, _ref;

    return UploadShowView = (function(_super) {
      __extends(UploadShowView, _super);

      function UploadShowView() {
        _ref = UploadShowView.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      UploadShowView.prototype.template = template;

      UploadShowView.prototype.triggers = {
        'click [data-behavior="show-upload"]': 'open:upload'
      };

      UploadShowView.prototype.ui = {
        player: '[data-behavior="video-player"]'
      };

      UploadShowView.prototype.initialize = function(options) {
        this.options = options || {};
        return this.vent = Marionette.getOption(this, 'vent');
      };

      UploadShowView.prototype.onOpenUpload = function(e) {
        return this.vent.triggerMethod('upload:open', {});
      };

      UploadShowView.prototype.onStartTranscoding = function(e) {
        return this.model.requestTranscoding();
      };

      return UploadShowView;

    })(Marionette.ItemView);
  });

}).call(this);
