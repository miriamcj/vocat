/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(function(require) {
  let EnrollmentUserInput;
  const Marionette = require('marionette');
  const usersTemplate = require('hbs!templates/admin/enrollment/user_input');
  const coursesTemplate = require('hbs!templates/admin/enrollment/course_input');
  const ItemView = require('views/admin/enrollment/input_item');
  const EmptyView = require('views/admin/enrollment/input_empty');
  const ClosesOnUserAction = require('behaviors/closes_on_user_action');
  require('jquery_ui');
  require('vendor/plugins/ajax_chosen');

  return EnrollmentUserInput = (function() {
    EnrollmentUserInput = class EnrollmentUserInput extends Marionette.CompositeView {
      static initClass() {
  
        this.prototype.emptyView = EmptyView;
  
        this.prototype.childView = ItemView;
  
        this.prototype.childViewContainer = '[data-container="items"]';
  
        this.prototype.ui = {
          emptyViewContainer: '[data-container="empty"]',
          containerWrapper: '[data-behavior="container-wrapper"]',
          termInput: '[data-behavior="search-term"]',
          showBulk: '[data-behavior="show-bulk"]'
        };
  
        this.prototype.triggers = {
          'keypress [data-behavior="search-term"]': {
            event: "update",
            preventDefault: false,
            stopPropagation: false
          },
          'keyup [data-behavior="search-term"]': {
            event: "update",
            preventDefault: false,
            stopPropagation: false
          },
  
          'change [data-behavior="search-term"]': {
            event: "update",
            preventDefault: false,
            stopPropagation: false
          },
          'blur [data-behavior="search-term"]': {
            event: "blur",
            preventDefault: false,
            stopPropagation: false
          },
          'focus [data-behavior="search-term"]': 'focus',
          'click [data-behavior="show-bulk"]': 'showBulk'
        };
  
        this.prototype.onUpdate = _.debounce(function() {
          const promise = $.Deferred();
          promise.then(() => {
            if (this.ui.termInput.is(":focus")) {
              return this.open();
            }
          });
  
          const term = this.getTerm();
          if (term.length >= 1) {
            const data = {};
            data[this.collection.getSearchTerm()] = term;
            this.trigger('input:changed', {value: term});
            this.collection.fetch({
              url: `${this.collection.url}/search`, data, success: () => {
                return promise.resolve();
              }
            });
          } else {
            this.collection.reset();
            promise.resolve();
          }
  
  
          return promise;
        }
        , 250);
      }

      initialize(options) {
        this.collectionType = options.collectionType;
        this.enrollmentCollection = options.enrollmentCollection;
        return this.setupListeners();
      }


      setupListeners() {
        return this.listenTo(this, 'childview:clicked', event => {
          this.ui.termInput.val('');
          this.ui.termInput.blur();
          const promise = this.onUpdate();
          return promise.then(() => {
            return this.close();
          });
        });
      }

  //    onChildviewAdd: () ->
  //      @ui.termInput.val('')
  //      @onUpdate()

      checkCollectionLength() {
        if (this.collection.length > 0) {
          return this.open();
        } else {
          return this.close();
        }
      }

      buildChildView(item, ItemViewType, childViewOptions) {
        const options = _.extend({model: item}, childViewOptions);
        options.enrollmentCollection = this.enrollmentCollection;
        options.vent = this.options.vent;
        options.collectionType = this.collectionType;
        const childView = new ItemViewType(options);
        return childView;
      }

      getTemplate() {
        if (this.collection.getSearchTerm() === 'email') {
          return usersTemplate;
        } else {
          return coursesTemplate;
        }
      }

      close() {
        if (this.ui.containerWrapper.is(':visible')) {
          this.ui.containerWrapper.hide();
          return this.triggerMethod('closed');
        }
      }

      open() {
        if (!this.ui.containerWrapper.is(':visible')) {
          this.ui.containerWrapper.show();
          return this.triggerMethod('opened');
        }
      }

      getTerm() {
        return this.ui.termInput.val().trim();
      }

      onFocus() {
        const term = this.getTerm();
        if (term.length >= 1) {
          return this.open();
        }
      }

      onBlur() {
        this.close();
        return true;
      }

      onShow() {
        return this.ui.containerWrapper.hide();
      }
    };
    EnrollmentUserInput.initClass();
    return EnrollmentUserInput;
  })();
});
