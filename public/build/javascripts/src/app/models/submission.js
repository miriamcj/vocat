(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['backbone', 'models/attachment'], function(Backbone, Attachment) {
    var SubmissionModel, _ref;

    return SubmissionModel = (function(_super) {
      __extends(SubmissionModel, _super);

      function SubmissionModel() {
        _ref = SubmissionModel.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      SubmissionModel.prototype.urlRoot = '/api/v1/submissions';

      SubmissionModel.prototype.paramRoot = 'submission';

      SubmissionModel.prototype.requestTranscoding = function() {
        return $;
      };

      SubmissionModel.prototype.canBeAnnotated = function() {
        return this.get('current_user_can_annotate') === true && this.get('has_transcoded_attachment') === true;
      };

      SubmissionModel.prototype.toJSON = function() {
        var json;

        json = SubmissionModel.__super__.toJSON.call(this);
        if (this.attachment != null) {
          json.attachment = this.attachment.toJSON();
        } else {
          json.attachment = null;
        }
        return json;
      };

      SubmissionModel.prototype.updateAttachment = function() {
        var rawAttachment;

        rawAttachment = this.get('attachment');
        if (rawAttachment != null) {
          this.attachment = new Attachment(rawAttachment);
          return this.unset('attachment', {
            silent: true
          });
        }
      };

      SubmissionModel.prototype.initialize = function() {
        var _this = this;

        this.listenTo(this, 'change:attachment', function() {
          return _this.updateAttachment();
        });
        return this.updateAttachment();
      };

      return SubmissionModel;

    })(Backbone.Model);
  });

}).call(this);
