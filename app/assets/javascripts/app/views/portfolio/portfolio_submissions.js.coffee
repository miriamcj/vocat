define ['marionette', 'views/portfolio/portfolio_submissions_item', 'views/portfolio/portfolio_submissions_item_empty'], (Marionette, PortfolioSubmissionItem, EmptyView) ->

  class PortfolioSubmissionsView extends Marionette.CollectionView

    itemView: PortfolioSubmissionItem
    emptyView: EmptyView