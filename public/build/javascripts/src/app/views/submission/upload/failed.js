(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'hbs!templates/submission/upload/failed'], function(Marionette, template) {
    var UploadFailedView, _ref;

    return UploadFailedView = (function(_super) {
      __extends(UploadFailedView, _super);

      function UploadFailedView() {
        _ref = UploadFailedView.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      UploadFailedView.prototype.template = template;

      return UploadFailedView;

    })(Marionette.ItemView);
  });

}).call(this);
