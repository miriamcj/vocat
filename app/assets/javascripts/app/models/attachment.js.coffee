define ['backbone'], (Backbone) ->
  class AttachmentModel extends Backbone.Model

    paramRoot: 'attachment'

    urlRoot: () ->
      "/api/v1/submissions/#{@get('submission_id')}/attachments"
