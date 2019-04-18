/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(function(require) {
  let CreatorEnrollmentLayout;
  const Marionette =            require('marionette');
  const template =              require('hbs!templates/admin/enrollment_layout');
  const EnrollmentList =        require('views/admin/enrollment/list');
  const EnrollmentInput =       require('views/admin/enrollment/input');
  const EnrollmentBulkInput =   require('views/admin/enrollment/bulk_input');
  const SingleInvite = require('views/admin/enrollment/invite');
  const Flash = require('views/flash/flash_messages');

  return CreatorEnrollmentLayout = (function() {
    CreatorEnrollmentLayout = class CreatorEnrollmentLayout extends Marionette.LayoutView {
      static initClass() {
  
        this.prototype.listType = 'users';
        this.prototype.template = template;
        this.prototype.label = '';
  
        this.prototype.ui = {
          studentInput: '[data-behavior="student-input"]',
          labelContainer: '[data-behavior="label-container"]'
        };
  
        this.prototype.regions = {
          input: '[data-region="input"]',
          list: '[data-region="list"]',
          invite: '[data-region="invite"]',
          flash: '[data-region="flash"]'
        };
      }

      // Collection for this view is an enrollment collection, created by the controller.
      initialize(options) {
        // The search collection contains the results of the asynch search
        this.searchCollection = this.collection.getSearchCollection();

        // Can be courses or users, since the same UI elements are used for both.
        this.searchType = this.collection.searchType();

        // The list of current enrollments
        this.enrollmentList = new EnrollmentList({collection: this.collection, vent: this});

        // Error messages and feedback.
        return this.flashView = new Flash({vent: this, clearOnAdd: false});
      }

      showBulkEnrollAndInvite() {
        this.invite.reset();
        const enrollmentBulkInput = new EnrollmentBulkInput({collection: this.collection, vent: this});
        this.input.show(enrollmentBulkInput);
        this.listenTo(enrollmentBulkInput, 'showSingle', event => {
          return this.showSingle();
        });
        return this.input.show(enrollmentBulkInput);
      }

      showSingleInvite() {
        const singleInvite = new SingleInvite({collection: this.collection, vent: this, useAltTemplate: true});
        return this.invite.show(singleInvite);
      }

      showBulk() {
        return this.showBulkEnrollAndInvite();
      }

      onShow() {
        const data = this.$el.parent().data();
        if (data.hasOwnProperty('label')) {
          this.label = data.label;
          return this.ui.labelContainer.html(this.label);
        }
      }

      showSingle() {
        this.showSingleEnroll();
        if (this.searchType === 'user') {
          return this.showSingleInvite();
        }
      }

      showSingleEnroll() {
        const enrollmentInput = new EnrollmentInput({
          collection: this.searchCollection,
          enrollmentCollection: this.collection,
          collectionType: this.searchType,
          vent: this
        });
        this.input.show(enrollmentInput);
        this.listenTo(enrollmentInput, 'showBulk', event => {
          return this.showBulk();
        });
        return this.input.show(enrollmentInput);
      }

      onRender() {
        this.list.show(this.enrollmentList);
        this.flash.show(this.flashView);
        return this.showSingle();
      }

      serializeData() {
        return {
        label: this.label
        };
      }
    };
    CreatorEnrollmentLayout.initClass();
    return CreatorEnrollmentLayout;
  })();});