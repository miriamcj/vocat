define ['backbone'], (Backbone) ->

  class SubmissionModel extends Backbone.Model

    urlRoot: '/api/v1/submissions'
    paramRoot: 'submission'

    requestTranscoding: () ->
      $

    canBeAnnotated: () ->
      @.get('current_user_can_annotate') == true && @.get('has_transcoded_attachment') == true