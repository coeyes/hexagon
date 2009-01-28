/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.ui.controls{	import com.hexagonstar.ui.core.InvalidationType;	import com.hexagonstar.ui.core.UIComponent;	import com.hexagonstar.ui.core.UITextComponent;	import com.hexagonstar.ui.events.ScrollEvent;	import com.hexagonstar.ui.managers.IFocusManager;	import com.hexagonstar.ui.managers.IFocusManagerComponent;		import flash.display.DisplayObject;	import flash.events.Event;	import flash.events.FocusEvent;	import flash.events.MouseEvent;	import flash.system.IME;	import flash.text.TextField;			[Event(name="change", type="flash.events.Event")]	[Event(name="textInput", type="flash.events.TextEvent")]	[Event(name="enter", type="com.hexagonstar.env.event.ComponentEvent")]	[Event(name="scroll", type="com.hexagonstar.env.event.ScrollEvent")]		[Style(name="upSkin", type="Class")]	[Style(name="disabledSkin", type="Class")]	[Style(name="textPadding", type="Number", format="Length")]	[Style(name="embedFonts", type="Boolean")]			/**	 * The TextArea component is a multiline text field with a border and optional	 * scroll bars. The TextArea component supports the HTML rendering capabilities	 * of Adobe Flash Player.	 *	 * @see TextInput	 */	public class TextArea extends UITextComponent implements IFocusManagerComponent	{		////////////////////////////////////////////////////////////////////////////////////////		// Constants                                                                          //		////////////////////////////////////////////////////////////////////////////////////////				protected static const SCROLL_BAR_STYLES:Object =		{			downArrowDisabledSkin: "downArrowDisabledSkin",			downArrowDownSkin: "downArrowDownSkin",			downArrowOverSkin: "downArrowOverSkin",			downArrowUpSkin: "downArrowUpSkin",			upArrowDisabledSkin: "upArrowDisabledSkin",			upArrowDownSkin: "upArrowDownSkin",			upArrowOverSkin: "upArrowOverSkin",			upArrowUpSkin: "upArrowUpSkin",			thumbDisabledSkin: "thumbDisabledSkin",			thumbDownSkin: "thumbDownSkin",			thumbOverSkin: "thumbOverSkin",			thumbUpSkin: "thumbUpSkin",			thumbIcon: "thumbIcon",			trackDisabledSkin: "trackDisabledSkin",			trackDownSkin: "trackDownSkin",			trackOverSkin: "trackOverSkin",			trackUpSkin: "trackUpSkin",			repeatDelay: "repeatDelay",			repeatInterval: "repeatInterval"		};						////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				protected var _hScrollPolicy:String = ScrollPolicy.AUTO;		protected var _vScrollPolicy:String = ScrollPolicy.AUTO;		protected var _hScrollBar:UIScrollBar;		protected var _vScrollBar:UIScrollBar;		protected var _isWordWrap:Boolean = true;		protected var _isTextChanged:Boolean = false;				private static var _defaultStyles:Object =		{			upSkin:				"TextInputUp",			disabledSkin:		"TextInputDisabled",			focusRectSkin:		null,			focusRectPadding:	null,			textFormat:			null,			disabledTextFormat:	null,			textPadding:		3,			embedFonts:			false		};						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new TextArea instance.		 */		public function TextArea(x:Number = 0, y:Number = 0, width:Number = 0,			height:Number = 0)		{			super(x, y, width, height);		}						/**		 * @copy com.hexagonstar.ui.core.UITextComponent#appendText()		 */		override public function appendText(text:String):void		{			super.appendText(text);			invalidate(InvalidationType.DATA);		}						/**		 * Marks the component to update it's vertical scrolling on the next frame.		 */		public function updateScrolling():void		{			_tf.addEventListener(Event.ENTER_FRAME, onUpdateScrolling);		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @copy com.hexagonstar.ui.core.UIComponent#getStyleDefinition()		 *		 * @see com.hexagonstar.ui.core.UIComponent#getStyle() UIComponent#getStyle()		 * @see com.hexagonstar.ui.core.UIComponent#setStyle() UIComponent#setStyle()		 * @see com.hexagonstar.ui.managers.StyleManager StyleManager		 */		public static function get styleDefinition():Object		{			return UIComponent.mergeStyles(_defaultStyles, ScrollBar.styleDefinition);		}						override public function set enabled(v:Boolean):void		{			super.enabled = v;			/* Disables mouseWheel interaction. */			mouseChildren = enabled;			invalidate(InvalidationType.STATE);		}						override public function set text(v:String):void		{			super.text = v;			_isTextChanged = true;		}						override public function set htmlText(v:String):void		{			super.htmlText = v;			_isTextChanged = true;		}						override public function set condenseWhite(v:Boolean):void		{			_tf.condenseWhite = v;			invalidate(InvalidationType.DATA);		}						override public function set horizontalScrollPosition(v:int):void		{			/* We must force a redraw to ensure that the size is up to date. */			drawNow();			super.horizontalScrollPosition = v;		}						/**		 * Gets the width of the text, in pixels.		 * @see #textHeight		 */		override public function get textWidth():Number		{			drawNow();			return _tf.textWidth;		}						/**		 * Gets the height of the text, in pixels.		 * @see #textWidth		 */		override public function get textHeight():Number		{			drawNow();			return _tf.textHeight;		}						/**		 * @copy com.hexagonstar.ui.core.UITextComponent#length		 */		override public function get length():int		{			return _tf.text.length;		}						/**		 * @copy com.hexagonstar.ui.core.UITextComponent#imeMode		 */		override public function get imeMode():String		{			return IME.conversionMode;		}						/**		 * Gets a reference to the horizontal scroll bar.		 * @see #verticalScrollBar		 */		public function get horizontalScrollBar():UIScrollBar		{ 			return _hScrollBar;		}				/**		 * Gets a reference to the vertical scroll bar.		 * @see #horizontalScrollBar		 */		public function get verticalScrollBar():UIScrollBar		{			return _vScrollBar;		}						/**		 * Gets or sets the scroll policy for the horizontal scroll bar. 		 * This can be one of the following values:		 * <ul>		 * <li>ScrollPolicy.ON: The horizontal scroll bar is always on.</li>		 * <li>ScrollPolicy.OFF: The scroll bar is always off.</li>		 * <li>ScrollPolicy.AUTO: The scroll bar turns on when it is needed.</li>		 * </ul>		 * 		 * @see #verticalScrollPolicy		 * @see ScrollPolicy		 */		public function get horizontalScrollPolicy():String		{			return _hScrollPolicy;		}				public function set horizontalScrollPolicy(v:String):void		{			_hScrollPolicy = v;			invalidate(InvalidationType.SIZE);		}						/**		 * Gets or sets the scroll policy for the vertical scroll bar. 		 * This can be one of the following values:		 * <ul>		 * <li>ScrollPolicy.ON: The scroll bar is always on.</li>		 * <li>ScrollPolicy.OFF: The scroll bar is always off.</li>		 * <li>ScrollPolicy.AUTO: The scroll bar turns on when it is needed.</li>		 * </ul>		 * 		 * @see #horizontalScrollPolicy		 * @see ScrollPolicy		 */		public function get verticalScrollPolicy():String		{			return _vScrollPolicy;		}				public function set verticalScrollPolicy(v:String):void		{			_vScrollPolicy = v;			invalidate(InvalidationType.SIZE);		}						/**		 * Gets or sets the change in the position of the scroll bar thumb, in  pixels,		 * after the user scrolls the text field vertically. If this value is 1, the text		 * field was not vertically scrolled.		 * 		 * @see #horizontalScrollPosition		 */		public function get verticalScrollPosition():int		{			return _tf.scrollV;		}				public function set verticalScrollPosition(v:int):void		{			/* We must force a redraw to ensure that the size is up to date. */			drawNow();			_tf.scrollV = v;		}						/**		 * Gets the maximum value of the <code>verticalScrollPosition</code> property.		 * @see #verticalScrollPosition		 * @see #maxHScrollPosition		 */		public function get maxVerticalScrollPosition():int		{			return _tf.maxScrollV;		}						/**		 * Gets or sets a Boolean value that indicates whether the text		 * wraps at the end of the line. A value of <code>true</code> 		 * indicates that the text wraps; a value of <code>false</code>		 * indicates that the text does not wrap. 		 *		 * @see flash.text.TextField#wordWrap TextField.wordWrap		 */				public function get wordWrap():Boolean		{			return _isWordWrap;		}				public function set wordWrap(v:Boolean):void		{			_isWordWrap = v;			invalidate(InvalidationType.STATE);		}						public function set editable(v:Boolean):void		{			_isEditable = v;			invalidate(InvalidationType.STATE);		}						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @private		 */		override protected function onFocusIn(e:FocusEvent):void		{			setIMEMode(true);						if (e.target == this) stage.focus = _tf;			var fm:IFocusManager = focusManager;						if (fm)			{				if (editable) fm.showFocusIndicator = true;				fm.defaultButtonEnabled = false;			}						super.onFocusIn(e);			if (editable) setIMEMode(true);		}				/**		 * @private		 */		override protected function onFocusOut(e:FocusEvent):void		{			var fm:IFocusManager = focusManager;			if (fm) fm.defaultButtonEnabled = true;			setSelection(0, 0);			super.onFocusOut(e);			if (editable) setIMEMode(false);		}						/**		 * @private		 */		override protected function onChange(e:Event):void		{			super.onChange(e);			invalidate(InvalidationType.DATA);		}						/**		 * @private		 */		protected function onScroll(e:ScrollEvent):void		{			dispatchEvent(e);		}						/**		 * @private		 */		protected function onMouseWheel(e:MouseEvent):void		{			if (!enabled || !_vScrollBar.visible) return;			_vScrollBar.scrollPosition -= e.delta * _vScrollBar.lineScrollSize;			dispatchEvent(new ScrollEvent(ScrollBarDirection.VERTICAL,				e.delta * _vScrollBar.lineScrollSize, _vScrollBar.scrollPosition));		}						/**		 * @private		 */		protected function onDelayedLayoutUpdate(e:Event):void		{			if (_isTextChanged)			{				_isTextChanged = false;				drawLayout();				return;			}			removeEventListener(Event.ENTER_FRAME, onDelayedLayoutUpdate);		}						/**		 * Invoked when the TextArea should update it's vertical scrolling.		 * @private		 */		protected function onUpdateScrolling(e:Event):void		{			_tf.scrollV = _tf.maxScrollV;			_vScrollBar.scrollPosition = _tf.maxScrollV;			_tf.removeEventListener(Event.ENTER_FRAME, onUpdateScrolling);		}						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @private		 */		override protected function configUI():void		{			super.configUI();						_vScrollBar = new UIScrollBar();			_vScrollBar.name = "V";			_vScrollBar.visible = false;			_vScrollBar.focusEnabled = false;			_vScrollBar.addEventListener(ScrollEvent.SCROLL, onScroll, false, 0, true);			copyStylesToChild(_vScrollBar, SCROLL_BAR_STYLES);			addChild(_vScrollBar);						_hScrollBar = new UIScrollBar();			_hScrollBar.name = "H";			_hScrollBar.visible = false;			_hScrollBar.focusEnabled = false;			_hScrollBar.direction = ScrollBarDirection.HORIZONTAL;			_hScrollBar.addEventListener(ScrollEvent.SCROLL, onScroll, false, 0, true);			copyStylesToChild(_hScrollBar, SCROLL_BAR_STYLES);			addChild(_hScrollBar);						_hScrollBar.scrollTarget = _tf;			_vScrollBar.scrollTarget = _tf;						addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel, false, 0, true);		}						/**		 * @private		 */		override protected function draw():void		{			if (isInvalid(InvalidationType.STATE)) updateTextFieldType();						if (isInvalid(InvalidationType.STYLES))			{				setChildStyles();				setEmbedFont();			}						if (isInvalid(InvalidationType.STYLES, InvalidationType.STATE))			{				drawTextFormat();				drawBackground();				invalidate(InvalidationType.SIZE, false);			}						if (isInvalid(InvalidationType.SIZE, InvalidationType.DATA)) drawLayout();			super.draw();		}						/**		 * @private		 */		override protected function updateTextFieldType():void		{			super.updateTextFieldType();			_tf.wordWrap = _isWordWrap;			_tf.multiline = true;		}						/**		 * @private		 */		override protected function drawLayout():void		{			super.drawLayout();						var padding:Number = getStyleValue("textPadding") as Number;			_tf.x = _tf.y = padding;						/* Figure out which scrollbars we need */			var availHeight:Number = height;			var vScrollBar:Boolean = needVScroll();			var availWidth:Number = width - (vScrollBar ? _vScrollBar.width : 0);			var hScrollBar:Boolean = needHScroll();						if (hScrollBar) availHeight -= _hScrollBar.height;			setTextSize(availWidth, availHeight, padding);						/* catch the edge case of the horizontal scroll bar necessitating a vertical one */			if (hScrollBar && !vScrollBar && needVScroll())			{				vScrollBar = true;				availWidth -= _vScrollBar.width;				setTextSize(availWidth, availHeight, padding);			}						/* Size and move the scrollBars */			if (vScrollBar)			{				_vScrollBar.visible = true;				_vScrollBar.x = width - _vScrollBar.width;				_vScrollBar.height = availHeight;				_vScrollBar.visible = true;				_vScrollBar.enabled = enabled;			}			else			{				_vScrollBar.visible = false;			}						if (hScrollBar)			{				_hScrollBar.visible = true;				_hScrollBar.y = height - _hScrollBar.height;				_hScrollBar.width = availWidth;				_hScrollBar.visible = true;				_hScrollBar.enabled = enabled;			}			else			{				_hScrollBar.visible = false;			}						updateScrollBars();			addEventListener(Event.ENTER_FRAME, onDelayedLayoutUpdate, false, 0, true);		}						/**		 * @private		 */		protected function setChildStyles():void		{			copyStylesToChild(_vScrollBar, SCROLL_BAR_STYLES);			copyStylesToChild(_hScrollBar, SCROLL_BAR_STYLES);		}						/**		 * @private		 */		protected function updateScrollBars():void		{			_hScrollBar.update();			_vScrollBar.update();			_vScrollBar.enabled = enabled;			_hScrollBar.enabled = enabled;			_hScrollBar.drawNow();			_vScrollBar.drawNow();		}						/**		 * @private		 */		protected function needVScroll():Boolean		{			if (_vScrollPolicy == ScrollPolicy.OFF) return false;			if (_vScrollPolicy == ScrollPolicy.ON) return true;			return (_tf.maxScrollV > 1);		}						/**		 * @private		 */		protected function needHScroll():Boolean		{			if (_hScrollPolicy == ScrollPolicy.OFF) return false;			if (_hScrollPolicy == ScrollPolicy.ON) return true;			return (_tf.maxScrollH > 0);		}						/**		 * @private		 */		protected function setTextSize(width:Number, height:Number, padding:Number):void		{			var w:Number = width - padding * 2;			var h:Number = height - padding * 2;						if (w != _tf.width) _tf.width = w;			if (h != _tf.height) _tf.height = h;		}	}}