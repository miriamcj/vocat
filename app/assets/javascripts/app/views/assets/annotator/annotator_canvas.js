/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'backbone.marionette';
import { $ } from "jquery";
import paper from 'paper-jsdom';
import template from 'templates/assets/annotator/annotator_canvas.hbs';
import ModalConfirmView from 'views/modal/modal_confirm';

export default class AnnotatorCanvasView extends Marionette.ItemView {
  constructor() {

    this.template = template;
    this.mode = null;
    this.currentPath = null;
    this.paths = [];
    this.dirty = false;
    let eraseEnabled = false;
    this.tools = {
      draw: null,
      oval: null,
      nullTool: null
    };
    this.className = 'annotation-canvas';

    this.ui = {
      canvas: '[data-behavior="canvas"]'
    };
  }

  initialize(options) {
    this.vent = options.vent;
    this.collection = this.model.annotations();
    return this.setupListeners();
  }

  setupListeners() {
    this.listenTo(this.vent, 'request:annotation:canvas:load', this.loadCanvas, this);
    this.listenTo(this.vent, 'request:annotation:canvas:disable', this.disable, this);
    this.listenTo(this.vent, 'request:annotation:canvas:setmode', this.setMode, this);
    this.listenTo(this.vent, 'request:canvas', this.announceCanvas, this);
    return this.listenTo(this, 'lock:attempted', this.handleLockAttempted, this);
  }

  handleLockAttempted(requestedPlayback) {
    return this.showClearCanvasWarning(requestedPlayback);
  }

  showClearCanvasWarning(requestedPlayback) {
    if (this.dirty === true) {
      return Vocat.vent.trigger('modal:open', new ModalConfirmView({
        model: requestedPlayback,
        vent: this,
        descriptionLabel: 'Changing the playback position will clear your drawing. If that\'s OK, press yes to proceed. If it\'s not OK, press cancel and post your annotation.',
        confirmEvent: 'confirm:clear:canvas',
        dismissEvent: 'dismiss:clear:canvas'
      }));
    } else {
      return this.onConfirmClearCanvas(requestedPlayback);
    }
  }


  onConfirmClearCanvas(requestedPlayback) {
    this.disable();
    return setTimeout(() => {
      return this.vent.trigger('request:time:update', {seconds: requestedPlayback});
    }
    , 10);
  }

  setMode(mode) {
    if (mode !== 'select') { this.enable(); }
    this.eraseEnabled = false;
    paper.project.deselectAll();
    // Default mode is select
    if ((this.mode === mode) && (mode !== null)) {
      mode = 'select';
    }
    this.mode = mode;
    if (this.mode === 'draw') {
      this.vent.trigger('announce:canvas:tool', 'draw');
      return this.tools.draw.activate();
    } else if (this.mode === 'oval') {
      this.vent.trigger('announce:canvas:tool', 'oval');
      return this.tools.oval.activate();
    } else if (this.mode === 'erase') {
      this.activateEraseTool();
      return this.vent.trigger('announce:canvas:tool', 'erase');
    } else if (this.mode === 'select') {
      this.tools.nullTool.activate();
      return this.vent.trigger('announce:canvas:tool', 'select');
    } else if (this.mode === null) {
      this.vent.trigger('announce:canvas:tool', null);
      return this.tools.nullTool.activate();
    }
  }

  disable() {
    this.setMode(null);
    this.clearCanvas();
    this.vent.trigger('request:unlock', {view: this});
    this.vent.trigger('announce:canvas:disabled', {view: this});
    this.vent.trigger('announce:canvas:clean', {view: this});
    return this.$el.hide();
  }

  enable() {
    this.vent.trigger('announce:canvas:enabled', {view: this});
    this.vent.trigger('request:annotation:hide');
    return this.$el.show();
  }

  clearCanvas() {
    this.dirty = false;
    paper.project.clear();
    return this.updateCanvas();
  }

  loadCanvas(annotation) {
    this.clearCanvas();
    const json = annotation.getCanvasJSON();
    if (json) {
      paper.project.importJSON(json);
      const paths = paper.project.getItems({class: Path});
      paths.forEach(path => {
        this.addPathEvents(path);
        return path.selected = false;
      });
      this.updateCanvas();
    }
    return this.enable();
  }

  updateCanvas() {
    return paper.view.update();
  }

  onRender() {
    const height = $('[data-behavior="player-container"]').outerHeight();
    const width = $('[data-behavior="player-container"]').outerWidth();
    this.ui.canvas.attr('width', width);
    this.ui.canvas.attr('height', height);
    this.initializePaper();
    return this.disable();
  }

  _initOvalTool() {
    this.tools.oval = new paper.Tool;
    this.tools.oval.onMouseDown = event => {
      return this.startPoint = event.point;
    };
    this.tools.oval.onMouseDrag = event => {
      let path;
      if (this.currentPath) { this.currentPath.remove(); }
      if (paper.Key.isDown('shift')) {
        let diff;
        const sx = this.startPoint.x;
        const sy = this.startPoint.y;
        let ex = event.point.x;
        let ey = event.point.y;
        const xdiff = Math.abs(ex - sx);
        const ydiff = Math.abs(ey - sy);
        if (xdiff > ydiff) {
          diff = xdiff;
        } else {
          diff = ydiff;
        }
        if (ex > sx) {
          ex = sx + diff;
        } else {
          ex = sx - diff;
        }
        if (ey > sy) {
          ey = sy + diff;
        } else {
          ey = sy - diff;
        }
        path = new paper.Path.Ellipse(new Rectangle(this.startPoint, new Point(ex, ey)));
      } else {
        path = new paper.Path.Ellipse(new Rectangle(this.startPoint, event.point));
      }
      path.strokeColor = this.getColor();
      path.strokeWidth = 6;
      path.shadowColor = new Color(0, 0, 0);
      path.shadowBlur = 18;
      path.shadowOffset = new Point(3, 3);
      return this.currentPath = path;
    };
    return this.tools.oval.onMouseUp = event => {
      this.vent.trigger('announce:canvas:dirty');
      this.dirty = true;
      this.addPathEvents(this.currentPath);
      return this.currentPath = null;
    };
  }

  _initDrawTool() {
    this.tools.draw = new paper.Tool;
    this.tools.draw.onMouseDown = event => {
      const path = new paper.Path({
        shadowColor: new Color(0, 0, 0),
        shadowBlur: 18,
        shadowOffset: new Point(3, 3)
      });
      this.currentPath = path;
      path.strokeColor = this.getColor();
      path.strokeWidth = 6;
      return path.add(event.point);
    };
    this.tools.draw.onMouseDrag = event => {
      return this.currentPath.add(event.point);
    };
    return this.tools.draw.onMouseUp = event => {
      this.currentPath.simplify(20);
      this.vent.trigger('announce:canvas:dirty');
      this.dirty = true;
      this.addPathEvents(this.currentPath);
      return this.currentPath = null;
    };
  }

  _initNullTool() {
    this.tools.nullTool = new paper.Tool;
    return this.tools.nullTool.onKeyDown = event => {
      if ((event.key === 'delete') || (event.key === 'backspace')) {
        const paths = paper.project.getItems({selected: true, class: Path});
        if (paths.length > 0) {
          paths.forEach(path => {
            return path.remove();
          });
          event.preventDefault();
          this.updateCanvas();
          return false;
        }
      } else {
        return true;
      }
    };
  }

  _initPaper() {
    paper.install(window);
    return paper.setup(this.ui.canvas[0]);
  }

  _addPathEventErase(path) {
    return path.on('click', event => {
      if (this.eraseEnabled === true) {
        this.dirty = true;
        path.remove();
        this.updateCanvas();
        return false;
      } else {
        return true;
      }
    });
  }

  _addPathEventHoverSelect(path) {
    return path.on('mouseenter', () => {
      if (this.eraseEnabled === true) {
        path.selected = true;
      }
      return true;
    });
  }

  _addPathEventHoverDeselect(path) {
    return path.on('mouseleave', () => {
      if (this.eraseEnabled === true) {
        path.selected = false;
      }
      return true;
    });
  }

  _addPathEventSelect(path) {
    return path.on('mouseup', () => {
      if (this.mode === 'select') {
        if (path.selected === false) {
          paper.project.getItems({class: Path}).forEach(path => path.selected = false);
          path.selected = true;
        } else {
          if (path.vocat_event_mousedrag === false) {
            path.selected = false;
          } else {
            path.vocat_event_mousedrag = false;
          }
        }
      }
      return true;
    });
  }

  _addPathEventSetOffset(path) {
    return path.on('mousedown', event => {
      if (this.mode === 'select') {
        const offset = path.position.subtract(event.point);
        path.vocat_event_last_mouse_offset = offset;
      }
      return true;
    });
  }

  _addPathEventDrag(path) {
    return path.on('mousedrag', event => {
      if (this.mode === 'select') {
        path.vocat_event_mousedrag = true;
        if (path.selected === false) {
          paper.project.getItems({class: Path}).forEach(path => path.selected = false);
          path.selected = true;
        }
        path.position = event.point.add(path.vocat_event_last_mouse_offset);
        this.dirty = true;
        event.preventDefault();
      }
      return true;
    });
  }

  addPathEvents(path) {
    this._addPathEventErase(path);
    this._addPathEventHoverSelect(path);
    this._addPathEventHoverDeselect(path);
    this._addPathEventSelect(path);
    this._addPathEventSetOffset(path);
    return this._addPathEventDrag(path);
  }

  activateEraseTool() {
    this.eraseEnabled = true;
    return this.tools.nullTool.activate();
  }

  initializePaper() {
    this._initPaper();
    this._initDrawTool();
    this._initOvalTool();
    return this._initNullTool();
  }

  getColor() {
    switch (window.VocatUserCourseRole) {
      case 'evaluator':
        return new Color(.9607843137, 0.7882352941, 0.1764705882); // Yellow
      case 'creator':
        return new Color(0.3764705882, 0.6392156863, 0.7490196078); // Blue
      default:
        return new Color(0.9568627451, 0.262745098, 0.3333333333); // Red
    }
  }

  announceCanvas() {
    let json, svg;
    if (paper.project.isEmpty()) {
      json = null;
      svg = null;
    } else {
      json = paper.project.exportJSON({asString: true});
      svg = paper.project.exportSVG({asString: true});
      // When we save this SVG image, we need assign a fluid width
      // and height, and set the viewbox to the width and height
      // of the canvas when the image was created. This will allows
      // us to resize it along with the size of the video playback.
      const svgEl = $(svg);
      const width = this.ui.canvas.outerWidth();
      const height = this.ui.canvas.outerHeight();
      svgEl[0].setAttribute('viewBox', `0 0 ${width} ${height}`);
      svgEl[0].setAttribute('width', '100%');
      svgEl[0].setAttribute('height', '100%');
      svg = $('<div>').append($(svgEl).clone()).html();
    }
    return this.vent.trigger('announce:canvas', JSON.stringify({json, svg}));
  }
}
