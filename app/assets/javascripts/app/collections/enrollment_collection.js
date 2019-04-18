/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(['backbone', 'models/enrollment', 'collections/user_collection',
        'collections/course_collection'], function(Backbone, EnrollmentModel, UserCollection, CourseCollection) {
  let EnrollmentCollection;
  return EnrollmentCollection = (function() {
    EnrollmentCollection = class EnrollmentCollection extends Backbone.Collection {
      static initClass() {
  
        this.prototype.model = EnrollmentModel;
      }

      searchType() {
        if (this.scope.course) {
          return 'user';
        } else {
          return 'course';
        }
      }

      role() {
        return this.scope.role;
      }

      getSearchCollection() {
        if (this.searchType() === 'user') {
          return new UserCollection;
        } else {
          return new CourseCollection;
        }
      }

      getContextualName(model) {
        if (this.searchType() === 'user') {
          return model.get('user_name');
        } else {
          return model.get('course_name');
        }
      }

      newEnrollmentFromSearchModel(searchModel) {
        const attributes = {
          course: searchModel.id,
          user: searchModel.id
        };
        if (this.scope.course != null) { attributes.course = this.scope.course; }
        if (this.scope.user != null) { attributes.user = this.scope.user; }
        if (this.scope.role != null) { attributes.role = this.scope.role; }

        const model = new this.model(attributes);
        return model;
      }

      baseUrl() {
        if (this.searchType() === 'user') {
          return `/api/v1/courses/${this.scope.course}/enrollments`;
        } else {
          return `/api/v1/users/${this.scope.user}/enrollments`;
        }
      }

      bulkUrl() {
        if (this.searchType() === 'user') {
          return `${this.baseUrl()}/bulk?role=${this.scope.role}`;
        } else {
          return `${this.baseUrl()}/bulk`;
        }
      }

      url() {
        if (this.searchType() === 'user') {
          return `${this.baseUrl()}?role=${this.scope.role}`;
        } else {
          return this.baseUrl();
        }
      }

      comparator(model) {
        if (this.searchType() === 'user') {
          return model.get('user_name');
        } else {
          return model.get('course_name');
        }
      }

      initialize(models, options) {
        return this.scope = options.scope;
      }
    };
    EnrollmentCollection.initClass();
    return EnrollmentCollection;
  })();
});
