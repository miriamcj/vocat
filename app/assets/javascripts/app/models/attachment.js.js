define ['backbone'], (Backbone) ->
  class AttachmentModel extends Backbone.Model

    paramRoot: 'attachment'

    urlRoot: "/api/v1/attachments"
