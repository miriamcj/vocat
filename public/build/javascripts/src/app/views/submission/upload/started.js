(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'hbs!templates/submission/upload/started'], function(Marionette, template) {
    var UploadStartedView, _ref;

    return UploadStartedView = (function(_super) {
      __extends(UploadStartedView, _super);

      function UploadStartedView() {
        _ref = UploadStartedView.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      UploadStartedView.prototype.template = template;

      return UploadStartedView;

    })(Marionette.ItemView);
  });

}).call(this);
