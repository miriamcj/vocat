define ['backbone', 'models/field'], (Backbone, FieldModel) ->

  class FieldCollection extends Backbone.Collection
    model: FieldModel

