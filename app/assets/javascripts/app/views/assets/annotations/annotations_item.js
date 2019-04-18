/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';
import template from 'hbs!templates/assets/annotations/annotations_item';
import ModalConfirmView from 'views/modal/modal_confirm';

export default class AnnotationItem extends Marionette.ItemView {
  static initClass() {

    this.prototype.assetHasDuration = false;
    this.prototype.highlighted = true;
    this.prototype.ignoreTime = false;
    this.prototype.template = template;
    this.prototype.tagName = 'li';
    this.prototype.className = 'annotation';

    this.prototype.triggers = {
      'click @ui.destroy': {
        event: 'annotation:destroy',
        stopPropagation: true
      },
      'click @ui.edit': {
        event: 'annotation:edit',
        stopPropagation: true
      },
      'click @ui.seek': {
        event: 'seek',
        stopPropagation: false
      },
      'click @ui.activate': {
        event: 'activate',
        stopPropagation: false
      },
      'click @ui.body': {
        event: 'toggle',
        stopPropagation: false
      }
    };

    this.prototype.ui = {
      seek: '[data-behavior="seek"]',
      destroy: '[data-behavior="destroy"]',
      edit: '[data-behavior="edit"]',
      body: '[data-behavior="annotation-body"]',
      activate: '[data-behavior="activate"]'
    };

    this.prototype.modelEvents = {
      "change:body": "onModelBodyChange",
      "change:canvas": "onModelCanvasChange"
    };
    
  }

  onActivate() {
    this.vent.trigger('request:annotator:input:stop');
    if (this.model.get('active')) {
      return this.model.collection.deactivateAllModels();
    } else {
      this.model.collection.activateModel(this.model);
      return this.vent.trigger('request:annotation:show', this.model);
    }
  }

  onModelBodyChange() {
    return this.render();
  }

  onModelCanvasChange() {
    return this.render();
  }

  onToggle() {
    return this.$el.toggleClass('annotation-open');
  }

  setupListeners() {
    return this.listenTo(this.model, 'change:active', this.handleActiveStateChange);
  }

  handleActiveStateChange() {
    if (this.model.get('active') === true) {
      this.$el.addClass('annotation-active');
      return this.trigger('activated', this);
    } else {
      return this.$el.removeClass('annotation-active');
    }
  }

  initialize(options) {
    this.vent = options.vent;
    this.errorVent = options.errorVent;
    this.assetHasDuration = options.assetHasDuration;
    return this.setupListeners();
  }

  remove() {
    this.trigger('before:remove');
    return this.$el.slideUp(200, () => {
      this.$el.remove();
      return this.trigger('after:remove');
    });
  }

  onSeek() {
    return this.vent.trigger('request:time:update', {
      seconds: this.model.get('seconds_timecode'), callback: () => {
        return this.model.activate();
      }
      , callbackScope: this
    });
  }

  onAnnotationDestroy() {
    this.vent.trigger('request:pause', {});
    return Vocat.vent.trigger('modal:open', new ModalConfirmView({
      model: this.model,
      vent: this,
      descriptionLabel: 'Are you sure you want to delete this annotation? Deleted annotations cannot be recovered.',
      confirmEvent: 'confirm:destroy',
      dismissEvent: 'dismiss:destroy'
    }));
  }

  serializeData() {
    const data = super.serializeData();
    data.assetHasDuration = this.assetHasDuration;
    data.hasDrawing = this.model.hasDrawing();
    return data;
  }

  onConfirmDestroy() {
    this.model.destroy({
      success: () => {
        return Vocat.vent.trigger('error:add',
          {level: 'notice', clear: true, lifetime: '5000', msg: 'The annotation has been successfully deleted.'});
      }
      , error: xhr => {
        return Vocat.vent.trigger('error:add', {level: 'notice', msg: xhr.responseJSON.errors});
      }
    });
    return this.vent.trigger('request:resume', {});
  }

  onDismissDestroy() {
    return this.vent.trigger('request:resume', {});
  }

  onAnnotationEdit() {
    return this.vent.trigger('request:annotator:input:edit', this.model);
  }

  onRender() {
    const role = this.model.get('author_role');
    switch (role) {
      case "administrator":
        return this.$el.addClass('role-administrator');
      case "evaluator":
        return this.$el.addClass('role-evaluator');
      case "creator":
        return this.$el.addClass('role-creator');
      case "self":
        return this.$el.addClass('role-self');
    }
  }
};
