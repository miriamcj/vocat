/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';

import 'jquery_ui';

export default class SortableTable extends Marionette.Behavior {
  static initClass() {

    this.prototype.defaults = {
    };

    this.prototype.ui = {
      table: 'tbody'
    };
  }

  initialize() {
    return this.listenTo(this, ('childview:update-sort'), (rowView, args) => {
      return this.updateSort(args[0], args[1]);
    });
  }


  onRender() {
    return this.ui.table.sortable({
      revert: true,
      handle: '.row-handle',
      items: 'tr:not([data-ui-behavior="drag-disabled"])',
      cursor: "move",
      revert: 175,
      start: (event, ui) => {
        // TODO: Assign widths to the dragged row.
        const handle = ui.item.find('.row-handle');
        const w = handle.outerWidth();
        return this.ui.table.find('.row-handle').each((index, el) => {
          return console.log($(el).outerWidth(w));
        });
      },
      helper: (index, $el) => {
        const $originals = $el.children();
        const $helper = $el.clone();
        $helper.children().each((index, el) => $(el).outerWidth($originals.eq(index).outerWidth()));
        return $helper;
      },

      stop(event, ui) {
        return ui.item.trigger('drop', ui.item.index());
      }
    });
  }

  updateSort(model, position) {
    const adjustedPosition = position;
    this.view.collection.remove(model);
    model.set('listing_order_position', adjustedPosition);
    this.view.collection.add(model, {at: position});
    return model.save();
  }
};
