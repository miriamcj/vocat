/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import SubmissionCollection from 'collections/submission_collection';

export default class SubmissionForGroupCollection extends SubmissionCollection.extend({
  url: '/api/v1/submissions/for_group'
}) {};
