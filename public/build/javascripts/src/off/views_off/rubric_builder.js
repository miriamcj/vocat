(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Vocat.Views.RubricBuilder = (function(_super) {
    __extends(RubricBuilder, _super);

    function RubricBuilder() {
      _ref = RubricBuilder.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    RubricBuilder.prototype.template = HBT["app/templates/rubric_builder"];

    RubricBuilder.prototype.events = {
      'click .debug': 'debug',
      'click .js-save': 'save'
    };

    RubricBuilder.prototype.debug = function(event) {
      event.preventDefault();
      console.clear();
      console.log(this.model, 'Full Model');
      return console.log(this.model.toJSON(), 'JSON Representation');
    };

    RubricBuilder.prototype.save = function(event) {
      event.preventDefault;
      return this.model.save();
    };

    RubricBuilder.prototype.initialize = function(options) {
      var courseId;

      courseId = this.$el.data().course;
      if (Vocat.Bootstrap.Models.Rubric != null) {
        this.model = new Vocat.Models.Rubric(Vocat.Bootstrap.Models.Rubric, {
          parse: true
        });
      } else {
        this.model = new Vocat.Models.Rubric({});
        if (courseId != null) {
          this.model.courseId = courseId;
        }
      }
      RubricBuilder.__super__.initialize.call(this, options);
      return this.render();
    };

    RubricBuilder.prototype.render = function() {
      var context,
        _this = this;

      context = {
        rubric: this.model.toJSON()
      };
      this.$el.html(this.template(context));
      this.$el.find('.js-editable-input').each(function(index, el) {
        return new Vocat.Views.RubricBuilderEditableInput({
          model: _this.model,
          el: el,
          property: 'name',
          placeholder: "Enter a name"
        });
      });
      return new Vocat.Views.RubricBuilderStructure({
        model: this.model,
        el: $('#js-rubric_builder_structure')
      });
    };

    return RubricBuilder;

  })(Vocat.Views.AbstractView);

}).call(this);
