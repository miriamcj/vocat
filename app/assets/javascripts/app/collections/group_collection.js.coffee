define ['backbone', 'models/group'], (Backbone, GroupModel) ->
  class GroupCollection extends Backbone.Collection

    model: GroupModel
