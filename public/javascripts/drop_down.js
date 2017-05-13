/*
  DropDown, Script for dealing with drop down menus, version 0.0.2

  DropDown is freely distributable under the terms of an MIT-style license.

The MIT License

Copyright (c) 2007 Mats Lindblad <mats.lindblad [AT] it.su.se>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

 *  Dependencies
 *    Prototype               =>   http://prototypejs.org/ == 1.6
 *    LowPro                  =>   http://www.danwebb.net/lowpro == 0.5
 *    Script.aculo.us effects => http://wiki.script.aculo.us/scriptaculous/ == 1.8
 *
 *  Author: Mats Lindblad <mats.lindblad@gmail.com>
 *  Version: 0.0.1
 *--------------------------------------------------------------------------*/
var DropDown = Class.create();
DropDown.prototype = {
  initialize: function(source_element, target_element, options) {
    this.element = $(source_element);
    this.dropdown = $(target_element);
    this.previous_content = null;
    this.drop_down_id = (this.element.id?this.element.id:this.element.tagName) + '_' + (this.dropdown.id ? this.dropdown.id : this.dropdown.tagName)
    this.has_effects = (typeof Effect != 'undefined');
    this.options = {
      openOn:           'mouseover',
      hide_delay:       250, // the delay before the menu closes
      drop_down_div_id: this.drop_down_id, // build an ID from the elements ID's or add your own
      width:            200, // height will be calculated when the tool tip is rendered
      beforeShow:       Prototype.emptyFunction,
      afterShow:        Prototype.emptyFunction,
      beforeHide:       Prototype.emptyFunction,
      afterHide:        Prototype.emptyFunction,
      leftOffset:       0,
      topOffset:        0,
      className:        'drop_down_element',
      extraClassName:   null,
      useEffects:       true,
      openEffectOptions:{
        duration: 0.5,
        queue: {
          position: 'end',
          scope: this.drop_down_id
        }
      },
      hideEffectOptions:{
        duration: 0.5,
        queue: {
          position: 'end',
          scope: this.drop_down_id
        },
        afterFinish: function() {$(this.drop_down_id).setOpacity("0.999999");}.bind(this)}
    };
    Object.extend(this.options, options || {});
    this.buildPlaceHolder();
    this.place_holder.hide();
    this.dropdown.hide();
  },
  /* <div id="dropmenudiv" style="visibility:hidden;width:'+menuwidth+';background-color:'+menubgcolor+'" onMouseover="clearhidemenu()" onMouseout="dynamichide(event)"></div> */
  buildPlaceHolder: function(){
    this.place_holder = $div({id:this.options.drop_down_div_id, 'class':this.options.className}, this.dropdown.cloneNode(true));
    if (this.options.extraClassName)
      this.place_holder.addClassName(this.options.extraClassName);
    this.frameForIE();
    document.body.appendChild(this.place_holder);

    // Events: Allow user to click-to-open as well as hover-to-open
    if (this.options.openOn == 'mouseover')
      this.element.observe('mouseover', this.handleMouseOver.bindAsEventListener(this));
    else if (this.options.openOn == 'click')
      this.element.observe('click', this.handleMouseOver.bindAsEventListener(this));

    // all other events should remain the same
    this.element.observe('mouseout', this.handleMouseOut.bindAsEventListener(this));
    this.place_holder.observe("mouseover", this.clearDelayedHide.bindAsEventListener(this));
    this.place_holder.observe("mouseout", this.handleMouseOut.bindAsEventListener(this));

    document.observe("keyup", this.handleKeyEvent.bindAsEventListener(this));
  },
  position: function() {
    var xy = this.element.viewportOffset();
    var h = this.element.getHeight();
    var style = {
      top:    parseInt(xy[1]+h+this.options.topOffset) + "px",
      left:   parseInt(xy[0]+this.options.leftOffset) + "px",
      width:  this.options.width + 'px'
    };
    this.place_holder.setStyle(style);
    if (Prototype.Browser.IE) {
      this.underlay.setStyle({
        width: this.options.width + 'px',
        height: this.place_holder.getHeight() + 'px',
        top: parseInt(xy[1]+h+this.options.topOffset) + 'px',
        left: parseInt(xy[0]+this.options.leftOffset) + 'px'
      });
    }
  },
  handleMouseOver: function(event){
    this.clearDelayedHide();
    if (this.showing) { return this; }
    this.position();
    this.options.beforeShow(this);
    this.show();
    this.options.afterShow(this);
  },
  handleMouseOut: function(event){
    this.delayedHide();
  },
  handleKeyEvent: function(event){
    if (this.showing && (event.keyCode == Event.KEY_ESC))
      this.delayedHide();
  },
  hideDropDown: function(){
    this.options.beforeHide(this);
    this.hide();
    this.options.afterHide(this);
  },
  delayedHide: function() {
    this.delay_hide_timer = setTimeout(this.hideDropDown.bind(this), this.options.hide_delay);
  },
  clearDelayedHide: function() {
    if (typeof this.delay_hide_timer != "undefined")
      clearTimeout(this.delay_hide_timer);
  },
  frameForIE: function() {
    if (Prototype.Browser.IE) {
      this.underlay = document.createElement('iframe');
      Element.setStyle(this.underlay, {
        position: 'absolute',
        display: 'none',
        border: 0,
        margin: 0,
        opacity: 0.01,
        padding: 0,
        background: 'none',
        zIndex: 400
      });
      document.body.appendChild(this.underlay);
    }
  },
  show: function(){
    if (Prototype.Browser.IE) { // IE select fix
      this.underlay.show();
    }
    if (this.has_effects && this.options.useEffects)
      new Effect.BlindDown(this.place_holder, this.options.openEffectOptions);
    else
      this.place_holder.show();
    this.showing = true;
  },
  hide: function(){
    if (Prototype.Browser.IE) { // select fix
      this.underlay.hide();
    }
    if (this.has_effects && this.options.useEffects)
      new Effect.Fade(this.place_holder, this.options.hideEffectOptions);
    else
      this.place_holder.hide();
    this.showing = false;
  }
};