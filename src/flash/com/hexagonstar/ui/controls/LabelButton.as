/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.ui.controls{	import com.hexagonstar.ui.core.InvalidationType;	import com.hexagonstar.ui.core.UIComponent;	import com.hexagonstar.ui.events.ComponentEvent;	import com.hexagonstar.ui.managers.IFocusManagerComponent;		import flash.display.DisplayObject;	import flash.events.Event;	import flash.events.KeyboardEvent;	import flash.events.MouseEvent;	import flash.text.TextField;	import flash.text.TextFieldType;	import flash.text.TextFormat;	import flash.ui.Keyboard;			[Event(name="click", type="flash.events.MouseEvent")]	[Event(name="labelChange", type="com.hexagonstar.env.event.ComponentEvent")]		[Style(name="disabledSkin", type="Class")]	[Style(name="upSkin", type="Class")]	[Style(name="downSkin", type="Class")]	[Style(name="overSkin", type="Class")]	[Style(name="selectedDisabledSkin", type="Class")]	[Style(name="selectedUpSkin", type="Class")]	[Style(name="selectedDownSkin", type="Class")]	[Style(name="selectedOverSkin", type="Class")]	[Style(name="textPadding", type="Number", format="Length")]	[Style(name="repeatDelay", type="Number", format="Time")]	[Style(name="repeatInterval", type="Number", format="Time")]	[Style(name="icon", type="Class")]	[Style(name="upIcon", type="Class")]	[Style(name="downIcon", type="Class")]	[Style(name="overIcon", type="Class")]	[Style(name="disabledIcon", type="Class")]	[Style(name="selectedDisabledIcon", type="Class")]	[Style(name="selectedUpIcon", type="Class")]	[Style(name="selectedDownIcon", type="Class")]	[Style(name="selectedOverIcon", type="Class")]	[Style(name="embedFonts", type="Boolean")]			/**	 * The LabelButton class is an abstract class that extends the BaseButton class	 * by adding a label, an icon, and toggle functionality. The LabelButton class	 * is subclassed by the Button, CheckBox, RadioButton, and CellRenderer classes. 	 * 	 * <p>The LabelButton component is used as a simple button class that can be	 * combined with custom skin states that support ScrollBar buttons, NumericStepper	 * buttons, ColorPicker swatches, and so on.</p>	 * 	 * @see com.hexagonstar.ui.controls.BaseButton	 */	public class LabelButton extends BaseButton implements IFocusManagerComponent	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				protected var _tf:TextField;		protected var _icon:DisplayObject;		protected var _oldMouseState:String;		protected var _labelPlacement:String = ButtonLabelPlacement.RIGHT;		protected var _isToggle:Boolean = false;		protected var _label:String = "Label";				/* other option is "border". Not currently used, but is reference in subclasses. */		protected var _mode:String = "center";				private static var _defaultStyles:Object =		{			icon:					null,			upIcon:					null,			downIcon:				null,			overIcon:				null,			disabledIcon:			null,			selectedDisabledIcon:	null,			selectedUpIcon:			null,			selectedDownIcon:		null,			selectedOverIcon:		null,			textFormat:				null,			disabledTextFormat:		null,			textPadding:			5,			embedFonts:				false		};						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new LabelButton instance.		 */		public function LabelButton(	x:Number = 0,										y:Number = 0,										width:Number = 0,										height:Number = 0,										label:String = null)		{			super();						if (x != 0 || y != 0) move(x, y);			if (width > 0) _width = width;			if (height > 0) _height = height;			if (label) _label = label;		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				public static function get styleDefinition():Object		{ 			return mergeStyles(_defaultStyles, BaseButton.styleDefinition);		}						/**		 * Gets or sets the text label for the component. By default, the label text		 * appears centered on the button. <p><strong>Note:</strong> Setting this		 * property triggers the <code>labelChange</code> event object to be dispatched.</p>		 *		 * @see #event:labelChange		 */		public function get label():String		{			return _label;		}				public function set label(v:String):void		{			_label = v;			if (_tf.text != _label)			{				_tf.text = _label;				dispatchEvent(new ComponentEvent(ComponentEvent.LABEL_CHANGE));			}			invalidate(InvalidationType.SIZE);			invalidate(InvalidationType.STYLES);		}						/**		 * Position of the label in relation to a specified icon. <p>In ActionScript,		 * you can use the following constants to set this property:</p>		 * <ul>		 * <li><code>ButtonLabelPlacement.RIGHT</code></li>		 * <li><code>ButtonLabelPlacement.LEFT</code></li>		 * <li><code>ButtonLabelPlacement.BOTTOM</code></li>		 * <li><code>ButtonLabelPlacement.TOP</code></li>		 * </ul>		 * 		 * @see ButtonLabelPlacement		 */		public function get labelPlacement():String		{			return _labelPlacement;		}				public function set labelPlacement(v:String):void		{			_labelPlacement = v;			invalidate(InvalidationType.SIZE);		}						/**		 * Gets or sets a Boolean value that indicates whether a button can be toggled.		 * A value of <code>true</code> indicates that it can; a value of <code>false		 * </code> indicates that it cannot.		 * 		 * <p>If this value is <code>true</code>, clicking the button toggles it between		 * selected and unselected states. You can get or set this state programmatically		 * by using the <code>selected</code> property.</p>		 *		 * <p>If this value is <code>false</code>, the button does not stay pressed after		 * the user releases it. In this case, its <code>selected</code> property is		 * always <code>false</code>.</p>		 *		 * <p><strong>Note:</strong> When the <code>toggle</code> is set to <code>false		 * </code>, <code>selected</code> is forced to <code>false</code> because only		 * toggle buttons can be selected.</p>		 */		public function get toggle():Boolean		{			return _isToggle;		}				public function set toggle(v:Boolean):void		{			if (!v && super.selected) selected = false; 			_isToggle = v;						if (_isToggle)				addEventListener(MouseEvent.CLICK, onToggleSelected, false, 0, true);			else				removeEventListener(MouseEvent.CLICK, onToggleSelected);						invalidate(InvalidationType.STATE);		}						/**		 * Gets or sets a Boolean value that indicates whether a toggle button is toggled		 * in the on or off position. A value of <code>true</code> indicates that it is		 * toggled in the on position; a value of <code>false</code> indicates that it		 * is toggled in the off position. This property can be set only if the <code>		 * toggle</code> property is set to <code>true</code>.		 * 		 * <p>For a CheckBox component, this value indicates whether the box displays a		 * check mark. For a RadioButton component, this value indicates whether the		 * component is selected.</p>		 *		 * <p>The user can change this property by clicking the component, but you can		 * also set this property programmatically.</p>		 *		 * <p>If the <code>toggle</code> property is set to <code>true</code>, changing		 * this property also dispatches a <code>change</code> event.</p>		 */		override public function get selected():Boolean		{			return (_isToggle) ? _isSelected : false;		}				override public function set selected(v:Boolean):void		{			_isSelected = v;			if (_isToggle) invalidate(InvalidationType.STATE);		}						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @private		 */		override protected function onKeyFocusDown(e:KeyboardEvent):void		{			if (!enabled) return;			if (e.keyCode == Keyboard.SPACE || e.keyCode == Keyboard.ENTER)			{				if (!_oldMouseState) _oldMouseState = _mouseState;				setMouseState(BaseButton.STATE_DOWN);				startPress();			}		}						/**		 * @private		 */		override protected function onKeyFocusUp(e:KeyboardEvent):void		{			if (!enabled) return;			if (e.keyCode == Keyboard.SPACE || e.keyCode == Keyboard.ENTER)			{				setMouseState(_oldMouseState);				_oldMouseState = null;				endPress();				dispatchEvent(new MouseEvent(MouseEvent.CLICK));			}		}						/**		 * @private		 */		protected function onToggleSelected(e:MouseEvent):void		{			selected = !selected;			dispatchEvent(new Event(Event.CHANGE, true));		}						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @private		 */		override protected function configUI():void		{			super.configUI();						_tf = new TextField();			_tf.type = TextFieldType.DYNAMIC;			_tf.selectable = false;			addChild(_tf);		}						/**		 * @private		 */		override protected function draw():void		{			if (_tf.text != _label) label = _label;						if (isInvalid(InvalidationType.STYLES, InvalidationType.STATE))			{				drawBackground();				drawIcon();				drawTextFormat();				invalidate(InvalidationType.SIZE, false);			}						if (isInvalid(InvalidationType.SIZE)) drawLayout();						if (isInvalid(InvalidationType.SIZE, InvalidationType.STYLES))			{				if (_isFocused && focusManager.showFocusIndicator) drawFocus(true);			}						/* because we're not calling super.draw */			validate();		}						/**		 * @private		 */		override protected function drawLayout():void		{			var padding:Number = getStyleValue("textPadding") as Number;			var placement:String = (!_icon && _mode == "center")				? ButtonLabelPlacement.TOP				: _labelPlacement;						_tf.height = _tf.textHeight + 4;			_tf.visible = (label.length > 0);						var txtW:Number = _tf.textWidth + 4;			var txtH:Number = _tf.textHeight + 4;			var paddedIconW:Number = (!_icon) ? 0 : _icon.width + padding;			var paddedIconH:Number = (!_icon) ? 0 : _icon.height + padding;			var tmpW:Number;			var tmpH:Number;						if (_icon)			{				_icon.x = Math.round((width - _icon.width) / 2);				_icon.y = Math.round((height - _icon.height) / 2);			}						if (!_tf.visible)			{				_tf.width = 0;				_tf.height = 0;			}			else if (placement == ButtonLabelPlacement.BOTTOM				|| placement == ButtonLabelPlacement.TOP)			{				tmpW = Math.max(0, Math.min(txtW, width - 2 * padding));								if (height - 2 > txtH) tmpH = txtH;				else tmpH = height - 2;								_tf.width = txtW = tmpW;				_tf.height = txtH = tmpH;				_tf.x = Math.round((width - txtW) / 2);				_tf.y = Math.round((height - _tf.height - paddedIconH)					/ 2 + ((placement == ButtonLabelPlacement.BOTTOM) ? paddedIconH : 0));								if (_icon)					_icon.y = Math.round((placement == ButtonLabelPlacement.BOTTOM)					? _tf.y - paddedIconH					: _tf.y + _tf.height + padding);			}			else			{				tmpW = Math.max(0, Math.min(txtW, width - paddedIconW - 2 * padding));				_tf.width = txtW = tmpW;				_tf.x = Math.round((width - txtW - paddedIconW)					/ 2 + ((placement != ButtonLabelPlacement.LEFT) ? paddedIconW : 0));				_tf.y = Math.round((height - _tf.height) / 2);								if (_icon)					_icon.x = Math.round((placement != ButtonLabelPlacement.LEFT)						? _tf.x - paddedIconW						: _tf.x + txtW + padding);			}						super.drawLayout();		}						/**		 * @private		 */		protected function drawIcon():void		{			var oldIcon:DisplayObject = _icon;			var styleName:String = (enabled) ? _mouseState : "disabled";						if (selected) styleName = "selected"				+ styleName.substr(0, 1).toUpperCase()				+ styleName.substr(1);						styleName += "Icon";			var iconStyle:Object = getStyleValue(styleName);						/* try the default icon */			if (!iconStyle) iconStyle = getStyleValue("icon");						if (iconStyle) _icon = getDisplayObjectInstance(iconStyle);			if (_icon) addChildAt(_icon, 1);			if (oldIcon && oldIcon != _icon) removeChild(oldIcon);		}						/**		 * @private		 */		protected function drawTextFormat():void		{			/* Apply a default textformat */			var uiStyles:Object = UIComponent.styleDefinition;			var defaultFormat:TextFormat = (enabled)				? uiStyles["defaultTextFormat"] as TextFormat				: uiStyles["defaultDisabledTextFormat"] as TextFormat;						_tf.setTextFormat(defaultFormat);			var f:TextFormat = getStyleValue(enabled ? "textFormat" : "disabledTextFormat")				as TextFormat;						if (f) _tf.setTextFormat(f);			else f = defaultFormat;						_tf.defaultTextFormat = f;			setEmbedFont();		}						/**		 * @private		 */		protected function setEmbedFont():void		{			_tf.embedFonts = getStyleValue("embedFonts") as Boolean;		}	}}