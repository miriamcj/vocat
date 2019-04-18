/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Backbone from 'backbone';

export default class AttachmentModel extends Backbone.Model {
  static initClass() {

    this.prototype.paramRoot = 'attachment';

    this.prototype.urlRoot = "/api/v1/attachments";
}
};
