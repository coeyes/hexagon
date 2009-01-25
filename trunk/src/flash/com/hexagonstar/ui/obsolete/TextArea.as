/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.ui.obsolete{	import flash.events.Event;	import flash.text.StyleSheet;	import flash.text.TextFieldType;	import flash.text.TextFormat;		/**	 * TextArea Class	 */	public class TextArea extends TextComponent	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				protected var _panel:Panel;		protected var _scrollBar:VScrollBar;		protected var _editable:Boolean = true;		protected var _selectable:Boolean = true;		protected var _isHTML:Boolean = false;		protected var _isTransparent:Boolean;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new TextArea instance.		 * 		 * @param x The x position to place this component.		 * @param y The y position to place this component.		 * @param text The initial text to display in this component.		 * @param transparent determines if the TextArea is transparent or not.		 */		public function TextArea(x:Number = 0, y:Number =  0, text:String = "",			transparent:Boolean = false)		{			_isTransparent = transparent;			super(x, y, text);		}						/**		 * Draws the visual ui of the component.		 */		override public function draw():void		{			super.draw();						if (_panel)			{				_panel.resize(_width, _height);				_panel.hasShadow = _hasShadow;			}						_scrollBar.x = _width - _scrollBar.width;			_scrollBar.height = _height;			_scrollBar.maximum = _tf.maxScrollV;						_tf.width = _width - _scrollBar.width - 4;			_tf.height = _height - 4;						if (!_tf.styleSheet)				_tf.defaultTextFormat = new TextFormat(_font, _fontSize, _color);						if (_isHTML)			{				_tf.text = "";				_tf.htmlText = _text;			}			else			{				_tf.htmlText = "";				_tf.text = _text;			}						if (_selectable)			{				_tf.selectable = true;				_tf.mouseEnabled = true;			}			else			{				_tf.selectable = false;				_tf.mouseEnabled = false;			}						if (_editable)			{				_tf.type = TextFieldType.INPUT;			}			else			{				_tf.type = TextFieldType.DYNAMIC;			}		}						/**		 * Marks the component to update it's vertical scrolling on the next frame.		 */		public function updateScrolling():void		{			_tf.addEventListener(Event.ENTER_FRAME, onUpdateScrolling);		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Gets/sets whether the TextArea uses HTML text.		 */		public function set isHTML(v:Boolean):void		{			_isHTML = v;			invalidate();		}				public function get isHTML():Boolean		{			return isHTML;		}				/**		 * Gets/sets whether or not this text component will be editable.		 */		public function set editable(v:Boolean):void		{			_editable = v;			invalidate();		}				public function get editable():Boolean		{			return _editable;		}				/**		 * Gets/sets whether or not the component text will be selectable.		 */		public function set selectable(v:Boolean):void		{			_selectable = v;			invalidate();		}				public function get selectable():Boolean		{			return _selectable;		}				/**		 * Gets/sets the StyleSheet for use with HTML text.		 */		public function set styleSheet(v:StyleSheet):void		{			_tf.styleSheet = v;		}				public function get styleSheet():StyleSheet		{			return _tf.styleSheet;		}				/**		 * Gets/sets current scroll position of the text.		 */		public function set scrollPosition(v:int):void		{			_tf.scrollV = v;		}				public function get scrollPosition():int		{			return _tf.scrollV;		}				/**		 * Gets the maximum scroll position.		 */		public function get maxScrollPosition():int		{			return _tf.maxScrollV;		}						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @private		 */		protected function onChange(e:Event):void		{			if (_isHTML) _text = _tf.htmlText;			else _text = _tf.text;						_scrollBar.maximum = _tf.maxScrollV;			dispatchEvent(e);		}				/**		 * Invoked when the text area is being scrolled. This can occur when		 * scrolling with keys (PageUp/PageDown) or with the Mousewheel.		 * @private		 */		protected function onScroll(e:Event):void		{			if (!_scrollBar.isDragging)			{				_scrollBar.maximum = _tf.maxScrollV;				_scrollBar.value = _tf.scrollV;			}		}				/**		 * Invoked when the TextArea should update it's vertical scrolling.		 * @private		 */		protected function onUpdateScrolling(e:Event):void		{			_tf.removeEventListener(Event.ENTER_FRAME, onUpdateScrolling);			_tf.scrollV = _tf.maxScrollV;			_scrollBar.value = _tf.maxScrollV;			//Debug.trace("min: " + _slider.minimum + "\tmax: " + _slider.maximum);		}						/**		 * @private		 */		protected function onScrollBarChange(e:Event):void		{			_tf.scrollV = _scrollBar.value;		}						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Initializes the component.		 * @private		 */		override protected function init():void		{			super.init();			resize(200, 100);		}						/**		 * Creates and adds the child display objects of this component.		 * @private		 */		override protected function addChildren():void		{			if (!_isTransparent)			{				_panel = new Panel();				addChild(_panel);			}						_scrollBar = new VScrollBar();			_scrollBar.minimum = 1;			_scrollBar.addEventListener(Event.CHANGE, onScrollBarChange);			addChild(_scrollBar);						super.addChildren();						_tf.x = 2;			_tf.y = 2;			_tf.multiline = true;			_tf.wordWrap = true;			_tf.selectable = true;			_tf.type = TextFieldType.INPUT;			_tf.addEventListener(Event.CHANGE, onChange);			_tf.addEventListener(Event.SCROLL, onScroll);			addChild(_tf);		}	}}