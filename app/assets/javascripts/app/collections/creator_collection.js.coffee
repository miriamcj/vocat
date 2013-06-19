define ['backbone', 'models/creator'], (Backbone, CreatorModel) ->
  class CreatorCollection  extends Backbone.Collection
    model: CreatorModel