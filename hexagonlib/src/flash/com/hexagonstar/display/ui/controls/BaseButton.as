/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.display.ui.controls{	import com.hexagonstar.display.ui.core.InvalidationType;	import com.hexagonstar.display.ui.core.UIComponent;	import com.hexagonstar.display.ui.event.UIComponentEvent;	import flash.display.DisplayObject;	import flash.events.MouseEvent;	import flash.events.TimerEvent;	import flash.utils.Timer;	[Event(name="buttonDown", type="com.hexagonstar.event.ComponentEvent")]	[Event(name="change", type="flash.events.Event")]	    [Style(name="upSkin", type="Class")]    [Style(name="downSkin", type="Class")]    [Style(name="overSkin", type="Class")]    [Style(name="disabledSkin", type="Class")]    [Style(name="emphasizedSkin", type="Class")]    [Style(name="selectedDisabledSkin", type="Class")]    [Style(name="selectedUpSkin", type="Class")]    [Style(name="selectedDownSkin", type="Class")]    [Style(name="selectedOverSkin", type="Class")]    [Style(name="repeatDelay", type="Number", format="Time")]    [Style(name="repeatInterval", type="Number", format="Time")]			/**     * The BaseButton class is the base class for all button components, defining      * properties and methods that are common to all buttons. This class handles      * drawing states and the dispatching of button events.	 */	public class BaseButton extends UIComponent	{				////////////////////////////////////////////////////////////////////////////////////////		// Constants                                                                          //		////////////////////////////////////////////////////////////////////////////////////////				public static const STATE_UP:String = "up";		public static const STATE_OVER:String = "over";		public static const STATE_DOWN:String = "down";						////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				protected var _bg:DisplayObject;		protected var _timer:Timer;		protected var _mouseState:String;		private var _unlockedMouseState:String;				protected var _isSelected:Boolean = false;		protected var _isAutoRepeat:Boolean = false;		private var _isMouseStateLocked:Boolean = false;				private static var _defaultStyles:Object =		{			upSkin:					"ButtonUp",			downSkin:				"ButtonDown",			overSkin:				"ButtonOver",			disabledSkin:			"ButtonDisabled",			selectedDisabledSkin:	"ButtonToggledDisabled",			selectedUpSkin:			"ButtonToggledDown",			selectedDownSkin:		"ButtonToggledDown",			selectedOverSkin:		"ButtonToggledDown",			focusRectSkin:			null,			focusRectPadding:		null,			repeatDelay:			500,			repeatInterval:			35		};						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new BaseButton instance.		 */		public function BaseButton()		{			super();						buttonMode = true;			useHandCursor = true;			mouseChildren = false;						setupMouseEvents();			setMouseState(STATE_UP);			_timer = new Timer(1, 0);			_timer.addEventListener(TimerEvent.TIMER, onButtonDown, false, 0, true);		}						/**		 * Set the mouse state via ActionScript. The BaseButton class uses this		 * property internally, but it can also be invoked manually, and will		 * set the mouse state visually.		 * 		 * @param state A string that specifies a mouse state. Supported values		 *         are "up", "over", and "down".		 */		public function setMouseState(state:String):void		{			if (_isMouseStateLocked)			{				_unlockedMouseState = state;				return;			}						if (_mouseState == state) return;			_mouseState = state;			invalidate(InvalidationType.STATE);		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @copy com.hexagonstar.ui.core.UIComponent#getStyleDefinition()		 *		 * @see com.hexagonstar.ui.core.UIComponent#getStyle() UIComponent#getStyle()		 * @see com.hexagonstar.ui.core.UIComponent#setStyle() UIComponent#setStyle()		 * @see com.hexagonstar.ui.managers.StyleManager StyleManager		 */		public static function get styleDefinition():Object		{			return _defaultStyles;		}						/**		 * Gets or sets a value that indicates whether the component can accept user 		 * input. A value of <code>true</code> indicates that the component can accept		 * user input; a value of <code>false</code> indicates that it cannot.		 * 		 * <p>When this property is set to <code>false</code>, the button is disabled.		 * This means that although it is visible, it cannot be clicked. This property is 		 * useful for disabling a specific part of the user interface. For example, a		 * button that is used to trigger the reloading of a web page could be disabled		 * by using this technique.</p>		 */		override public function get enabled():Boolean		{			return super.enabled;		}				override public function set enabled(v:Boolean):void		{			super.enabled = v;			mouseEnabled = v;		}						/**		 * Gets or sets a Boolean value that indicates whether a toggle button is		 * selected. A value of <code>true</code> indicates that the button is selected;		 * a value of <code>false</code> indicates that it is not. This property has no		 * effect if the <code>toggle</code> property is not set to <code>true</code>.		 * 		 * <p>For a CheckBox component, this value indicates whether the box is checked.		 * For a RadioButton component, this value indicates whether the component is		 * selected.</p>		 * 		 * <p>This value changes when the user clicks the component but can also be		 * changed programmatically. If the <code>toggle</code> property is set to		 * <code>true</code>, changing this property causes a <code>change</code> event		 * object to be dispatched.</p>		 * 		 * @see #event:change change		 * @see LabelButton#toggle LabelButton.toggle		 */		public function get selected():Boolean		{			return _isSelected;		}				public function set selected(v:Boolean):void		{			if (_isSelected == v) return;			_isSelected = v;			invalidate(InvalidationType.STATE);		}						/**		 * Gets or sets a Boolean value that indicates whether the <code>buttonDown</code>		 * event is dispatched more than one time when the user holds the mouse button down		 * over the component. A value of <code>true</code> indicates that the <code>		 * buttonDown</code> event is dispatched repeatedly while the mouse button remains		 * down; a value of <code>false</code> indicates that the event is dispatched only		 * one time.		 * 		 * <p>If this value is <code>true</code>, after the delay specified by the <code>		 * repeatDelay</code> style, the <code>buttonDown</code> event is dispatched at the		 * interval that is specified by the <code>repeatInterval</code> style.</p>		 *		 * @see #style:repeatDelay		 * @see #style:repeatInterval		 * @see #event:buttonDown		 */		public function get autoRepeat():Boolean		{			return _isAutoRepeat;		}				public function set autoRepeat(v:Boolean):void		{			_isAutoRepeat = v;		}						/**		 * @private		 */		public function set mouseStateLocked(v:Boolean):void		{			_isMouseStateLocked = v;			if (!v) setMouseState(_unlockedMouseState);			else _unlockedMouseState = _mouseState;		}						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @private		 */		protected function onButtonDown(e:TimerEvent):void		{			if (!_isAutoRepeat)			{				endPress();				return;			}						if (_timer.currentCount == 1)				_timer.delay = Number(getStyleValue("repeatInterval"));						dispatchEvent(new UIComponentEvent(UIComponentEvent.BUTTON_DOWN, true));		}						/**		 * @private		 */		protected function onMouseEvent(e:MouseEvent):void		{			if (e.type == MouseEvent.MOUSE_DOWN)			{				setMouseState(STATE_DOWN);				startPress();			}			else if (e.type == MouseEvent.ROLL_OVER || e.type == MouseEvent.MOUSE_UP)			{				setMouseState(STATE_OVER);				endPress();			}			else if (e.type == MouseEvent.ROLL_OUT)			{				setMouseState(STATE_UP);				endPress();			}		}						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @private		 */		override protected function draw():void		{			if (isInvalid(InvalidationType.STYLES, InvalidationType.STATE))			{				drawBackground();				/* invalidates size without calling draw next frame. */				invalidate(InvalidationType.SIZE, false);			}						if (isInvalid(InvalidationType.SIZE)) drawLayout();						super.draw();		}						/**		 * @private		 */		protected function setupMouseEvents():void		{			addEventListener(MouseEvent.ROLL_OVER, onMouseEvent, false, 0, true);			addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent, false, 0, true);			addEventListener(MouseEvent.MOUSE_UP, onMouseEvent, false, 0, true);			addEventListener(MouseEvent.ROLL_OUT, onMouseEvent, false, 0, true);		}						/**		 * @private		 */		protected function startPress():void		{			if (_isAutoRepeat)			{				_timer.delay = getStyleValue("repeatDelay") as Number;				_timer.start();			}			dispatchEvent(new UIComponentEvent(UIComponentEvent.BUTTON_DOWN, true));		}						/**		 * @private		 */		protected function endPress():void		{			_timer.reset();		}						/**		 * @private		 */		protected function drawBackground():void		{			var styleName:String = (enabled) ? _mouseState : "disabled";						if (selected)			{ 				styleName = "selected"				+ styleName.substr(0, 1).toUpperCase()				+ styleName.substr(1);			}						styleName += "Skin";			var bg:DisplayObject = _bg;			_bg = getDisplayObjectInstance(getStyleValue(styleName));			addChildAt(_bg, 0);						if (bg && bg != _bg) removeChild(bg);		}						/**		 * @private		 */		protected function drawLayout():void		{			_bg.width = width;			_bg.height = height;		}	}}