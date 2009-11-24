/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.display.ui.controls{	import com.hexagonstar.display.ui.core.InvalidationType;	import com.hexagonstar.display.ui.core.UITextComponent;	import com.hexagonstar.display.ui.managers.IFocusManager;	import com.hexagonstar.display.ui.managers.IFocusManagerComponent;	import flash.events.FocusEvent;	[Event(name="enter", type="com.hexagonstar.env.event.ComponentEvent")]	[Event(name="change", type="flash.events.Event")]	[Event(name="textInput", type="flash.events.TextEvent")]		[Style(name="upSkin", type="Class")]	[Style(name="disabledSkin", type="Class")]	[Style(name="textPadding", type="Number", format="Length")]	[Style(name="embedFonts", type="Boolean")]			/**	 * The TextInput component is a single-line text component that	 * contains a native ActionScript TextField object.	 *	 * <p>A TextInput component can be enabled or disabled in an application.	 * When the TextInput component is disabled, it cannot receive input 	 * from mouse or keyboard. An enabled TextInput component implements focus, 	 * selection, and navigation like an ActionScript TextField object.</p>	 *	 * <p>You can use styles to customize the TextInput component by	 * changing its appearance--for example, when it is disabled.	 * Some other customizations that you can apply to this component	 * include formatting it with HTML or setting it to be a	 * password field whose text must be hidden. </p>	 *	 * @see TextArea	 */	public class TextInput extends UITextComponent implements IFocusManagerComponent	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				private static var _defaultStyles:Object =		{			upSkin:				"TextInputUp",			disabledSkin:		"TextInputDisabled",			focusRectSkin:		null,			focusRectPadding:	null,			textFormat:			null,			disabledTextFormat:	null,			textPadding:		1,			embedFonts:			false		};						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new TextInput instance.		 */		public function TextInput(x:Number = 0, y:Number = 0, width:Number = 0,			height:Number = 0)		{			super(x, y, width, height);		}						/**		 * @copy com.hexagonstar.ui.core.UIComponent#setFocus()		 */		override public function setFocus():void		{			if (stage) stage.focus = _tf;		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @copy com.hexagonstar.ui.core.UIComponent#getStyleDefinition()		 *		 * @see com.hexagonstar.ui.core.UIComponent#getStyle() UIComponent#getStyle()		 * @see com.hexagonstar.ui.core.UIComponent#setStyle() UIComponent#setStyle()		 * @see com.hexagonstar.ui.managers.StyleManager StyleManager		 */		public static function get styleDefinition():Object		{			return _defaultStyles;		}						override public function set enabled(v:Boolean):void		{			super.enabled = v;			updateTextFieldType();		}						public function set editable(v:Boolean):void		{			_isEditable = v;			updateTextFieldType();		}						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @private		 */		override protected function onFocusIn(e:FocusEvent):void		{			if (e.target == this) stage.focus = _tf;			var fm:IFocusManager = focusManager;						if (editable && fm)			{				fm.showFocusIndicator = true;				if (_tf.selectable && _tf.selectionBeginIndex == _tf.selectionBeginIndex)				{					setSelection(0, _tf.length);				}			}						super.onFocusIn(e);			if (editable) setIMEMode(true);		}						/**		 * @private		 */		override protected function onFocusOut(e:FocusEvent):void		{			super.onFocusOut(e);			if (editable) setIMEMode(false);		}						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @private		 */		override protected function draw():void		{			if (isInvalid(InvalidationType.STYLES, InvalidationType.STATE))			{				drawTextFormat();				drawBackground();				setEmbedFont();				invalidate(InvalidationType.SIZE, false);			}						if (isInvalid(InvalidationType.SIZE)) drawLayout();			super.draw();		}						/**		 * @private		 */		override protected function drawLayout():void		{			super.drawLayout();						var padding:Number = Number(getStyleValue("textPadding"));			_tf.width = width - 2 * padding;			_tf.height = height - 2 * padding;			_tf.x = _tf.y = padding;		}	}}