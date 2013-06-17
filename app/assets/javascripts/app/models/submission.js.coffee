class Vocat.Models.Submission extends Backbone.Model

  urlRoot: '/api/v1/submissions'
  paramRoot: 'submission'

  requestTranscoding: () ->
    $

  canBeAnnotated: () ->
    @.get('current_user_can_annotate') == true && @.get('has_transcoded_attachment') == true