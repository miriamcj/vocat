define ['backbone', 'models/attachment'], (Backbone, Attachment) ->

  class SubmissionModel extends Backbone.Model

    urlRoot: '/api/v1/submissions'
    paramRoot: 'submission'

    requestTranscoding: () ->
      $

    canBeAnnotated: () ->
      @get('current_user_can_annotate') == true && @get('has_transcoded_attachment') == true

    toJSON: () ->
      json = super()
      if @attachment?
        json.attachment = @attachment.toJSON()
      else
        json.attachment = null
      json

    initialize: () ->
      rawAttachment = @.get('attachment')
      if rawAttachment?
        @attachment = new Attachment(rawAttachment)
        @unset('attachment',{silent: true})