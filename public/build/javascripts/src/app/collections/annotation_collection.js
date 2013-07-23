(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['backbone', 'models/annotation'], function(Backbone, AnnotationModel) {
    var AnnotationCollection, _ref;

    return AnnotationCollection = (function(_super) {
      __extends(AnnotationCollection, _super);

      function AnnotationCollection() {
        _ref = AnnotationCollection.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      AnnotationCollection.prototype.model = AnnotationModel;

      AnnotationCollection.prototype.initialize = function(models, options) {
        if (options.attachmentId != null) {
          return this.attachmentId = options.attachmentId;
        }
      };

      AnnotationCollection.prototype.url = '/api/v1/annotations';

      AnnotationCollection.prototype.comparator = function(annotation) {
        return annotation.get('seconds_timecode');
      };

      return AnnotationCollection;

    })(Backbone.Collection);
  });

}).call(this);
