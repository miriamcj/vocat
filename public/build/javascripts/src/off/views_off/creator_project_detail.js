(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Vocat.Views.CreatorProjectDetail = (function(_super) {
    __extends(CreatorProjectDetail, _super);

    function CreatorProjectDetail() {
      _ref = CreatorProjectDetail.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    CreatorProjectDetail.prototype.template = HBT["app/templates/creator_project_detail"];

    CreatorProjectDetail.prototype.initialize = function(options) {
      console.log('called');
      CreatorProjectDetail.__super__.initialize.call(this, options);
      return this.render();
    };

    CreatorProjectDetail.prototype.render = function() {
      var context;

      context = {};
      this.$el.html(this.template(context));
      new Vocat.Views.CreatorProjectDetailVideo({
        model: this.model,
        el: $('#video-view')
      });
      new Vocat.Views.CreatorProjectDetailScore({
        model: this.model,
        el: $('#score-view')
      });
      return new Vocat.Views.CreatorProjectDetailDiscussion({
        model: this.model,
        el: $('#discussion-view')
      });
    };

    return CreatorProjectDetail;

  })(Vocat.Views.AbstractView);

}).call(this);
