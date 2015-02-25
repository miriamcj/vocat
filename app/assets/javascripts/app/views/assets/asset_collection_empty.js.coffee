define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/assets/asset_collection_empty')

  class AssetCollectionEmpty extends Marionette.ItemView

    template: template
    abilities: {}

    ui: {
      manageLink: '[data-behavior="empty-manage-link"]'
    }

    triggers: {
      'click @ui.manageLink': 'show:new'
    }

    onShowNew: () ->
      @vent.trigger('show:new')

    serializeData: () ->
      context = @abilities
      context.mediaUploadsClosed = @model.pastDue() && @model.get('rejects_past_due_media') && window.VocatUserCourseRole == 'creator'
      context.allowed_attachment_families = @model.get('allowed_attachment_families')
      context

    initialize: (options) ->
      @vent = Marionette.getOption(@, 'vent')
      @abilities = Marionette.getOption(@, 'abilities')
