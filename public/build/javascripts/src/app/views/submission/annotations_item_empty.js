(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'hbs!templates/submission/annotations_item_empty'], function(Marionette, template) {
    var AnnotationsEmptyView, _ref;

    return AnnotationsEmptyView = (function(_super) {
      __extends(AnnotationsEmptyView, _super);

      function AnnotationsEmptyView() {
        _ref = AnnotationsEmptyView.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      AnnotationsEmptyView.prototype.template = template;

      AnnotationsEmptyView.prototype.tagName = 'li';

      AnnotationsEmptyView.prototype.className = 'annotations--item';

      return AnnotationsEmptyView;

    })(Marionette.ItemView);
  });

}).call(this);
