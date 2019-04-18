/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(['backbone', 'models/course'], function(Backbone, courseModel) {
  let CourseCollection;
  return CourseCollection = (function() {
    CourseCollection = class CourseCollection extends Backbone.Collection {
      static initClass() {
  
        this.prototype.model = courseModel;
        this.prototype.activeModel = null;
  
        this.prototype.url = '/api/v1/courses';
      }

      getSearchTerm() {
        return 'section';
      }
    };
    CourseCollection.initClass();
    return CourseCollection;
  })();
});
