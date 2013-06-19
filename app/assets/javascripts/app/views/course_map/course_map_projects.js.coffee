define ['marionette', 'views/course_map/course_map_projects_item'], (Marionette, Item) ->

  class CourseMapProjectsView extends Marionette.CollectionView

    itemView: Item
