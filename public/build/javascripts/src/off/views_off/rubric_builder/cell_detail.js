(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Vocat.Views.RubricBuilderCellDetail = (function(_super) {
    __extends(RubricBuilderCellDetail, _super);

    function RubricBuilderCellDetail() {
      _ref = RubricBuilderCellDetail.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    RubricBuilderCellDetail.prototype.template = HBT["app/templates/rubric_builder/cell_detail"];

    RubricBuilderCellDetail.prototype.events = {
      'click .js-do-close': 'doClose',
      'click .js-do-close': 'doClose',
      'submit form': 'doSave'
    };

    RubricBuilderCellDetail.prototype.initialize = function(options) {
      RubricBuilderCellDetail.__super__.initialize.call(this, options);
      this.options.centerOn = '.rubric-table';
      this.field = this.model.get('fields').get(options.fieldId);
      return this.range = this.model.get('ranges').get(options.rangeId);
    };

    RubricBuilderCellDetail.prototype.doSave = function(event) {
      var description;

      event.preventDefault();
      description = this.$el.find('[name=description]').val();
      this.model.setDescription(this.field, this.range, description);
      return this.doClose();
    };

    RubricBuilderCellDetail.prototype.doClose = function(event) {
      if (event == null) {
        event = null;
      }
      if (event != null) {
        event.preventDefault();
      }
      this.hideModal();
      return this.remove();
    };

    RubricBuilderCellDetail.prototype.render = function(event) {
      var context;

      if (event == null) {
        event = null;
      }
      console.log(this.range, 'before json');
      context = {
        range: this.range.toJSON(),
        field: this.field.toJSON()
      };
      this.$el.html(this.template(context));
      this.$el.find('textarea').focus();
      return this.showModal();
    };

    return RubricBuilderCellDetail;

  })(Vocat.Views.AbstractModalView);

}).call(this);
