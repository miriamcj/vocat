define ['marionette', 'views/portfolio/portfolio_projects_item'], (Marionette, PortfolioProjectsItem) ->

  class PortfolioProjectsView extends Marionette.CollectionView

    itemView: PortfolioProjectsItem
