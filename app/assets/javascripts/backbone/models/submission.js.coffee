class Vocat.Models.Submission extends Backbone.Model

  urlRoot: '/api/v1/submissions'
  paramRoot: 'submission'

  canBeAnnotated: () ->
    @.get('current_user_can_annotate') == true && @.get('transcoded_attachment') == true