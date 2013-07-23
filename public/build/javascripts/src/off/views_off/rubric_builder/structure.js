(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Vocat.Views.RubricBuilderStructure = (function(_super) {
    __extends(RubricBuilderStructure, _super);

    function RubricBuilderStructure() {
      _ref = RubricBuilderStructure.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    RubricBuilderStructure.prototype.template = HBT["app/templates/rubric_builder/structure"];

    RubricBuilderStructure.prototype.events = {
      'submit .js-do-add-range': "addRange",
      'submit .js-do-add-field': "addField",
      'click .js-do-remove-field': "removeField",
      'click .js-do-remove-range': "removeRange",
      'change .js-do-update-range': "updateRange",
      'click 	.js-do-edit-detail': "doEditDetail"
    };

    RubricBuilderStructure.prototype.initialize = function(options) {
      this.model = options.model;
      RubricBuilderStructure.__super__.initialize.call(this, options);
      this.model.bind('change', this.render, this);
      this.model.bind('invalid', this.render, this);
      this.model.bind('valid', this.render, this);
      return this.render();
    };

    RubricBuilderStructure.prototype.openEditDetail = function(fieldId, rangeId) {
      var el, view;

      el = $('#js-cell-detail-container-' + fieldId + '-' + rangeId);
      view = new Vocat.Views.RubricBuilderCellDetail({
        model: this.model,
        fieldId: fieldId,
        rangeId: rangeId
      });
      $(el).append(view.el);
      return view.render();
    };

    RubricBuilderStructure.prototype.doEditDetail = function(event) {
      var $cell, data, fieldid, rangeid;

      event.preventDefault();
      $cell = $(event.target);
      data = $cell.data();
      fieldid = data.field;
      rangeid = data.range;
      return this.openEditDetail(fieldid, rangeid);
    };

    RubricBuilderStructure.prototype.updateRange = function(event) {
      var $target, data, id;

      event.preventDefault();
      $target = $(event.target);
      data = $target.data();
      this.model.updateRangeBound(data.model, data.type, $target.val());
      id = '#js-range-' + data.model + '-' + data.type;
      return $(id).focus();
    };

    RubricBuilderStructure.prototype.addRange = function(event) {
      event.preventDefault();
      this.model.addRange($('#js-do-add-range-value').val());
      return $('#js-do-add-range-value').focus();
    };

    RubricBuilderStructure.prototype.addField = function(event) {
      event.preventDefault();
      this.model.addField($('#js-do-add-field-value').val());
      return $('#js-do-add-field-value').focus();
    };

    RubricBuilderStructure.prototype.removeRange = function(event) {
      var target;

      event.preventDefault();
      target = event.target;
      return this.model.removeRange($(target).attr('data-model'));
    };

    RubricBuilderStructure.prototype.removeField = function(event) {
      var id;

      event.preventDefault();
      id = $(event.target).attr('data-model');
      return this.model.removeField(id);
    };

    RubricBuilderStructure.prototype.getRenderingContext = function() {
      var context;

      context = {
        validationError: this.model.validationError,
        prevalidationError: this.model.prevalidationError,
        rubric: this.model.toJSON()
      };
      this.model.get('ranges').each(function(range, index) {
        context.rubric.ranges[index].has_errors = range.hasErrors();
        return context.rubric.ranges[index].errors = range.errorMessages();
      });
      this.model.get('fields').each(function(field, index) {
        context.rubric.fields[index].has_errors = field.hasErrors();
        return context.rubric.fields[index].errors = field.errorMessages();
      });
      return context;
    };

    RubricBuilderStructure.prototype.initializeEditableInterfaces = function() {
      var _this = this;

      this.$el.find('.js-editable-input').each(function(index, el) {
        var collection, data, model;

        data = $(el).data();
        collection = _this.model.get(data.collection);
        model = collection.get(data.id);
        return new Vocat.Views.RubricBuilderEditableInput({
          model: model,
          el: el,
          property: data.property,
          placeholder: data.placeholder
        });
      });
      return this.$el.find('.js-editable-textarea').each(function(index, el) {
        var collection, data, model;

        data = $(el).data();
        collection = _this.model.get(data.collection);
        model = collection.get(data.id);
        return new Vocat.Views.RubricBuilderEditableTextarea({
          model: model,
          el: el,
          property: data.property,
          placeholder: data.placeholder
        });
      });
    };

    RubricBuilderStructure.prototype.render = function(event) {
      var context;

      if (event == null) {
        event = null;
      }
      context = this.getRenderingContext();
      this.$el.html(this.template(context));
      return this.initializeEditableInterfaces();
    };

    return RubricBuilderStructure;

  })(Vocat.Views.AbstractView);

}).call(this);
