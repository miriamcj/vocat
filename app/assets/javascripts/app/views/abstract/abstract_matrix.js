/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'backbone.marionette';

import { debounce } from "lodash";
const Waypoints = require("waypoints");
const WaypointsSticky = require("waypoints_sticky");

export default class AbstractMatrix extends Marionette.LayoutView {
  constructor() {

    this.minWidth = 200;
    this.maxWidth = 300;
    this.memoizeHashCount = 0;
    this.position = 0;
    this.counter = 0;

    this.stickyHeader = false;
    this.locks = {
      forward: false
    };

    this.ui = {
      sliderContainer: '[data-behavior="matrix-slider"]',
      sliderLeft: '[data-behavior="matrix-slider-left"]',
      sliderRight: '[data-behavior="matrix-slider-right"]'
    };

    this.triggers = {
      'click [data-behavior="matrix-slider-left"]': 'slider:left',
      'click [data-behavior="matrix-slider-right"]': 'slider:right'
    };
  }

  adjustToCurrentPosition() {
    return this.recalculateMatrix();
  }

  parentOnShow() {
    this.recalculateMatrix();
    if (this.stickyHeader) { this._initializeStickyHeader(); }
    this.listenTo(this, 'recalculate', debounce(() => {
      return this.recalculateMatrix();
    }), 250, true);

    $(window).resize(function() {
      if (this.resizeTo) {
        clearTimeout(this.resizeTo);
        return this.resizeTo = setTimeout(function() {
          return $(this).trigger('resize_end');
        });
      }
    });
    return $(window).bind('resize_end', () => {
      return this.recalculateMatrix();
    });
  }

  recalculateMatrix() {
    this._setColumnWidths();
    this._setRowHeights();
    return this._updateSliderControls();
  }

  slideToEnd() {
    this.locks.forward = true;
    this._slideTo(this._columnCount());
    return this._updateSliderControls();
  }

  onSliderLeft() {
    return this._slide('backward');
  }

  onSliderRight() {
    return this._slide('forward');
  }

  onBeforeClose() {
    $(window).off("resize");
    return true;
  }

  _getColHeadersTable() {
    return this.$el.find('[data-behavior="col-headers"]');
  }

  _getActor() {
    return this.$el.find('[data-behavior="matrix-actor"]');
  }

  _getStage() {
    return this.$el.find('[data-behavior="matrix-stage"]');
  }

  _getColHeaderCells() {
    return this.$el.find('[data-behavior="col-headers"] th');
  }

  _getFirstRowCells() {
    return this.$el.find('[data-behavior="matrix-actor"] tr:first-child td');
  }

  _getRowHeaders() {
    return this.$el.find('[data-vertical-headers] th');
  }

  _getActorRows() {
    return this._getActor().find('tr');
  }

  _getWidthCheckCells() {
    return this.$el.find('[data-behavior="col-headers"] tr:first-child th, [data-behavior="matrix-actor"] tr:first-child td');
  }

  _getHandleWidth() {
    let show;
    if (this.ui.sliderLeft.is(':visible')) { show = true; } else { show = false; }
    this.ui.sliderLeft.show();
    const w = Math.floor(this.ui.sliderLeft.outerWidth());
    if (show === false) {
      this.ui.sliderLeft.hide();
    }
    return w;
  }

  _setRowHeights() {
    const spacerHeight = this._getNaturalSpacerHeight();
    this._setSpacerHeight();
    const actorRows = this._getActorRows();
    return this._getRowHeaders().each((index, el) => {
      const $header = $(el);
      const $row = $(actorRows[index]).find('td');
      const headerHeight = $header.outerHeight();
      const rowHeight = $row.outerHeight();
      if (headerHeight > rowHeight) {
        return $row.outerHeight(headerHeight);
      } else if (rowHeight > headerHeight) {
        return $header.outerHeight(rowHeight);
      }
    });
  }

  _getMaxNaturalColumnWidth() {
    const cells = this._getWidthCheckCells();
    let maxWidth = 0;
    cells.each((i, cell) => {
      const $cell = $(cell);
      const style = $cell.attr('style');
      $cell.attr({style: `max-width: ${this.maxWidth}px`});
      const w = $cell.outerWidth();
      $cell.attr({style});
      if (w > maxWidth) { return maxWidth = w; }
    });
    return maxWidth;
  }

  _getColumnWidth() {
    const maxNaturalWidth = this._getMaxNaturalColumnWidth();
    if (maxNaturalWidth > this.minWidth) {
      return maxNaturalWidth;
    } else {
      return this.minWidth;
    }
  }

  _columnCount() {
    const bodyCols = this._getFirstRowCells().length;
    const headerCols = this._getColHeaderCells().length;
    return Math.max(bodyCols, headerCols);
  }

  _getAdjustedColumnWidth() {
    const width = this._getColumnWidth();
    const space = this._visibleWidth();
    const colsAtMin = Math.floor(space / width);
    let adjustedWidth = space / colsAtMin;
    adjustedWidth = adjustedWidth < this.maxWidth ? adjustedWidth : this.maxWidth;
    return adjustedWidth;
  }

  _visibleWidth() {
    return this._getStage().outerWidth() - this._getHandleWidth();
  }

  _removeWidthConstraints() {
    this._getColHeadersTable().outerWidth(300);
    return this._getActor().outerWidth(300);
  }

  _setColumnWidths() {
    this._removeWidthConstraints();
    let totalWidth = 0;
    const width = this._getAdjustedColumnWidth();
    this._getColHeaderCells().each(function(i, cell) {
      totalWidth = totalWidth + width;
      return $(cell).outerWidth(width);
    });
    this._getColHeadersTable().outerWidth(totalWidth);
    this._getFirstRowCells().each((i, cell) => $(cell).outerWidth(width));
    // Set outer width of each actor
    return this._getActor().outerWidth(totalWidth);
  }

  _getNaturalSpacerHeight() {
    this.$el.find('[data-match-height-target]').css({height: 'auto'});
    return this.$el.find('[data-match-height-target]').outerHeight();
  }

  _setSpacerHeight() {
    const minHeight = this._getNaturalSpacerHeight();
    // Work around for chrome rendering bug when height of th in table is adjusted.
    const targetHeight = this.$el.find('[data-match-height-source]').outerHeight() - .4;
    if (targetHeight > minHeight) {
      return this.$el.find('[data-match-height-target]').outerHeight(targetHeight).hide().show();
    } else {
      return this.$el.find('[data-match-height-source]').outerHeight(minHeight).hide().show();
    }
  }

  _updateSliderControls() {
    if (this._canSlideBackwardFrom()) {
      this.ui.sliderLeft.show();
    } else {
      this.ui.sliderLeft.hide();
    }
    if (this._canSlideForwardFrom() && (this.locks.forward === false)) {
      this.ui.sliderRight.show();
    } else {
      this.ui.sliderRight.hide();
    }
    return this._positionSliderLeft();
  }

  _canSlideForwardFrom(left = null) {
    if (left === null) { left = this._currentLeft(); }
    return left > (this._hiddenWidth() * -1);
  }

  _canSlideBackwardFrom(left = null) {
    if (left === null) { left = this._currentLeft(); }
    return left < 0;
  }

  _currentLeft() {
    let l = this._getActor().css('left');
    if (l === 'auto') {
      l = 0;
    } else {
      l = parseInt(l, 10);
    }
    return l;
  }

  _hiddenWidth() {
    return Math.floor(this._getActor().outerWidth() - this._getStage().outerWidth());
  }

  _positionSliderLeft() {
    const w = this.$el.find('[data-vertical-headers]').outerWidth();
    return this.ui.sliderLeft.css('left', w);
  }

  _slide(direction) {
    const globalChannel = Backbone.Wreqr.radio.channel('global');
    globalChannel.vent.trigger('user:action');
    let position = this._checkAndAdjustPosition(this.position);
    if ((direction === 'forward') && this._canSlideForwardFrom()) {
      position = position + 1;
    }
    if ((direction === 'backward') && this._canSlideBackwardFrom()) {
      position = position - 1;
    }
    return this._slideTo(position);
  }

  _checkAndAdjustPosition(position) {
    if (position > this._maxAttainablePosition()) {
      position = this._maxAttainablePosition();
    }
    if (position < 0) {
      position = 0;
    }
    return position;
  }

  _visibleColumns() {
    let out = Math.floor(this._visibleWidth() / this._getAdjustedColumnWidth());
    if (out === 0) { out = 1; }
    return out;
  }

  _maxAttainablePosition() {
    return this._columnCount() - this._visibleColumns();
  }

  _slideTo(position) {
    position = this._checkAndAdjustPosition(position);
    this.position = position;
    return this._animate(this._targetForPosition(this.position), () => {
      this.locks.forward = false;
      return this._updateSliderControls();
    });
  }

  _getCurrentColumnWidth(column) {
    return $(this._getColHeaderCells().get(column)).outerWidth();
  }

  _targetForPosition(position) {
    const hiddenWidth = this._hiddenWidth();
    const columnWidth = this._getCurrentColumnWidth(position);
    let target = position * columnWidth * -1;
    if (target < (hiddenWidth * -1)) { target = hiddenWidth * -1; }
    target = Math.ceil(target);
    if (target > 0) { target = 0; }
    return target;
  }

  _animate(target, duration) {
    if (duration == null) { duration = 250; }
    this._getActor().animate({left: target}, duration).promise().done(() => this._updateSliderControls());
    return this._getColHeadersTable().animate({left: target}, duration).promise().done(() => this._updateSliderControls());
  }

  _initializeStickyHeader() {
    const $el = this.$el.find('[data-class="sticky-header"]');
    return $el.waypoint('sticky', {
      offset: $('.page-header').outerHeight(),
      handler(direction) {
        const $container = $(this);
        const child = $container.children(':first');
        if (direction === 'down') {
          child.outerWidth(child.outerWidth());
          $container.find('[data-behavior="dropdown-options"]').each((index, el) => $(el).trigger('stuck'));
        }
        if (direction === 'up') {
          return child.css({width: 'auto'});
        }
      }
    });
  }
}
