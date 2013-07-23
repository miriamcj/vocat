(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['backbone'], function(Backbone) {
    var AttachmentModel, _ref;

    return AttachmentModel = (function(_super) {
      __extends(AttachmentModel, _super);

      function AttachmentModel() {
        _ref = AttachmentModel.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      AttachmentModel.prototype.paramRoot = 'attachment';

      AttachmentModel.prototype.urlRoot = "/api/v1/attachments";

      return AttachmentModel;

    })(Backbone.Model);
  });

}).call(this);
