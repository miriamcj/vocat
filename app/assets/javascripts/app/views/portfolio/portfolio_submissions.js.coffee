define ['marionette', 'views/portfolio/portfolio_submissions_item'], (Marionette, PortfolioSubmissionItem) ->

  class PortfolioSubmissionsView extends Marionette.CollectionView

    itemView: PortfolioSubmissionItem
