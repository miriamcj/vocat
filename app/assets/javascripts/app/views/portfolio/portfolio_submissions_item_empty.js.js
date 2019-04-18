define ['marionette', 'hbs!templates/portfolio/portfolio_item_empty'], (Marionette, template) ->
  class PortfolioItemEmptyView extends Marionette.ItemView

    template: template
