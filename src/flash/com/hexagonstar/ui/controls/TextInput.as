/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.ui.controls{	import com.hexagonstar.ui.core.InvalidationType;	import com.hexagonstar.ui.core.UIComponent;	import com.hexagonstar.ui.events.ComponentEvent;	import com.hexagonstar.ui.managers.IFocusManager;	import com.hexagonstar.ui.managers.IFocusManagerComponent;		import flash.display.DisplayObject;	import flash.events.Event;	import flash.events.FocusEvent;	import flash.events.KeyboardEvent;	import flash.events.TextEvent;	import flash.text.TextField;	import flash.text.TextFieldType;	import flash.text.TextFormat;	import flash.text.TextLineMetrics;	import flash.ui.Keyboard;		[Event(name="enter", type="com.hexagonstar.env.event.ComponentEvent")]	[Event(name="change", type="flash.events.Event")]	[Event(name="textInput", type="flash.events.TextEvent")]		[Style(name="upSkin", type="Class")]	[Style(name="disabledSkin", type="Class")]	[Style(name="textPadding", type="Number", format="Length")]	[Style(name="embedFonts", type="Boolean")]			/**	 * The TextInput component is a single-line text component that	 * contains a native ActionScript TextField object.	 *	 * <p>A TextInput component can be enabled or disabled in an application.	 * When the TextInput component is disabled, it cannot receive input 	 * from mouse or keyboard. An enabled TextInput component implements focus, 	 * selection, and navigation like an ActionScript TextField object.</p>	 *	 * <p>You can use styles to customize the TextInput component by	 * changing its appearance--for example, when it is disabled.	 * Some other customizations that you can apply to this component	 * include formatting it with HTML or setting it to be a	 * password field whose text must be hidden. </p>	 *	 * @see TextArea	 */	public class TextInput extends UIComponent implements IFocusManagerComponent	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				protected var _tf:TextField;		protected var _bg:DisplayObject;		protected var _savedHTML:String;		protected var _isEditable:Boolean = true;		protected var _isHTML:Boolean = false;				private static var _defaultStyles:Object =		{			upSkin: "TextInputUp",			disabledSkin: "TextInputDisabled",			focusRectSkin: null,			focusRectPadding: null,			textFormat: null,			disabledTextFormat: null,			textPadding: 0,			embedFonts: false		};						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new TextInput instance.		 */		public function TextInput(width:Number = -1, height:Number = -1)		{			super();						if (width >= 0) _width = width;			if (height >= 0) _height = height;		}						/**		 * @copy com.hexagonstar.ui.core.HUIComponent#drawFocus()		 */		override public function drawFocus(draw:Boolean):void		{			if (focusTarget)			{				focusTarget.drawFocus(draw);				return;			}			super.drawFocus(draw);		}						/**		 * @copy com.hexagonstar.ui.core.HUIComponent#setFocus()		 */		override public function setFocus():void		{			stage.focus = _tf;		}						/**		 * Sets the range of a selection made in a text area that has focus.		 * The selection range begins at the index that is specified by the start 		 * parameter, and ends at the index that is specified by the end parameter.		 * If the parameter values that specify the selection range are the same,		 * this method sets the text insertion point in the same way that the 		 * <code>caretIndex</code> property does.		 *		 * <p>The selected text is treated as a zero-based string of characters in which		 * the first selected character is located at index 0, the second 		 * character at index 1, and so on.</p>		 *		 * <p>This method has no effect if the text field does not have focus.</p>		 *		 * @param beginIndex The index location of the first character in the selection.		 * @param endIndex The index location of the last character in the selection.		 * @see #selectionBeginIndex		 * @see #selectionEndIndex		 */		public function setSelection(beginIndex:int, endIndex:int):void		{			_tf.setSelection(beginIndex, endIndex);		}						/**		 * Retrieves information about a specified line of text.		 * @param lineIndex The line number for which information is to be retrieved.		 */		public function getLineMetrics(index:int):TextLineMetrics		{			return _tf.getLineMetrics(index);		}						/**		 * Appends the specified string after the last character that the TextArea 		 * contains. This method is more efficient than concatenating two strings 		 * by using an addition assignment on a text property; for example, 		 * <code>myTextArea.text += moreText</code>. This method is particularly		 * useful when the TextArea component contains a significant amount of		 * content.		 *		 * @param text The string to be appended to the existing text.		 */		public function appendText(text:String):void		{			_tf.appendText(text);		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @copy com.hexagonstar.ui.core.HUIComponent#getStyleDefinition()		 *		 * @see com.hexagonstar.ui.core.HUIComponent#getStyle() HUIComponent#getStyle()		 * @see com.hexagonstar.ui.core.HUIComponent#setStyle() HUIComponent#setStyle()		 * @see com.hexagonstar.ui.managers.StyleManager StyleManager		 */		public static function get styleDefinition():Object		{			return _defaultStyles;		}						/**		 * Gets or sets a string which contains the text that is currently in 		 * the TextInput component. This property contains text that is unformatted 		 * and does not have HTML tags. To retrieve this text formatted as HTML, use 		 * the <code>htmlText</code> property.		 * 		 * @see #htmlText		 */		public function get text():String		{			return _tf.text;		}				public function set text(v:String):void		{			_tf.text = v;			_isHTML = false;			invalidate(InvalidationType.DATA);			invalidate(InvalidationType.STYLES);		}						/**		 * @copy com.hexagonstar.ui.core.HUIComponent#enabled		 */		override public function get enabled():Boolean		{			return super.enabled;		}				override public function set enabled(v:Boolean):void		{			super.enabled = v;			updateTextFieldType();		}						/**		 * @copy com.hexagonstar.ui.controls.TextArea#imeMode		 */		public function get imeMode():String		{			return _imeMode;		}				public function set imeMode(v:String):void		{			_imeMode = v;		}						/**		 * Gets or sets a Boolean value that indicates how a selection is		 * displayed when the text field does not have focus.		 * <p>When this value is set to <code>true</code> and the text field does 		 * not have focus, Flash Player highlights the selection in the text field 		 * in gray. When this value is set to <code>false</code> and the text field 		 * does not have focus, Flash Player does not highlight the selection in the 		 * text field.</p>		 */		public function get alwaysShowSelection():Boolean		{			return _tf.alwaysShowSelection;		}				public function set alwaysShowSelection(v:Boolean):void		{			_tf.alwaysShowSelection = v;			}						/**		 * Gets or sets a Boolean value that indicates whether the text field 		 * can be edited by the user. A value of <code>true</code> indicates		 * that the user can edit the text field; a value of <code>false</code>		 * indicates that the user cannot edit the text field.		 */				public function get editable():Boolean		{			return _isEditable;		}				public function set editable(v:Boolean):void		{			_isEditable = v;			updateTextFieldType();		}						/**		 * Gets or sets the position of the thumb of the horizontal scroll bar.		 * @see #maxHorizontalScrollPosition		 */		public function get horizontalScrollPosition():int		{			return _tf.scrollH;		}				public function set horizontalScrollPosition(v:int):void		{			_tf.scrollH = v;		}						/**		 * Gets a value that describes the furthest position to which the text 		 * field can be scrolled to the right.		 * @see #horizontalScrollPosition		 */		public function get maxHorizontalScrollPosition():int		{			return _tf.maxScrollH;		}						/**		 * Gets the number of characters in a TextInput component.		 * @see #maxChars		 */		public function get length():int		{			return _tf.length;		}						/**		 * Gets or sets the maximum number of characters that a user can enter		 * in the text field.		 * @see #length		 */		public function get maxChars():int		{			return _tf.maxChars;		}				public function set maxChars(v:int):void		{			_tf.maxChars = v;		}						/**		 * Gets or sets a Boolean value that indicates whether the current TextInput 		 * component instance was created to contain a password or to contain text. A value of 		 * <code>true</code> indicates that the component instance is a password text		 * field; a value of <code>false</code> indicates that the component instance		 * is a normal text field. 		 * <p>When this property is set to <code>true</code>, for each character that the		 * user enters into the text field, the TextInput component instance displays an asterisk.		 * Additionally, the Cut and Copy commands and their keyboard shortcuts are 		 * disabled. These measures prevent the recovery of a password from an		 * unattended computer.</p>		 *		 * @see flash.text.TextField#displayAsPassword TextField.displayAsPassword		 */		public function get displayAsPassword():Boolean		{			return _tf.displayAsPassword;		}				public function set displayAsPassword(v:Boolean):void		{			_tf.displayAsPassword = v;		}						/**		 * Gets or sets the string of characters that the text field accepts from a user. 		 * Note that characters that are not included in this string are accepted in the 		 * text field if they are entered programmatically.		 * <p>The characters in the string are read from left to right. You can specify a 		 * character range by using the hyphen (-) character. </p>		 * <p>If the value of this property is null, the text field accepts all characters. 		 * If this property is set to an empty string (""), the text field accepts no characters.</p>		 * <p>If the string begins with a caret (^) character, all characters are initially 		 * accepted and succeeding characters in the string are excluded from the set of 		 * accepted characters. If the string does not begin with a caret (^) character, 		 * no characters are initially accepted and succeeding characters in the string 		 * are included in the set of accepted characters.</p>		 * 		 * @see flash.text.TextField#restrict TextField.restrict		 */		public function get restrict():String		{			return _tf.restrict;		}				public function set restrict(v:String):void		{			_tf.restrict = v;		}						/**		 * Gets the index value of the first selected character in a selection 		 * of one or more characters.		 * <p>The index position of a selected character is zero-based and calculated 		 * from the first character that appears in the text area. If there is no 		 * selection, this value is set to the position of the caret.</p>		 *		 * @see #selectionEndIndex		 * @see #setSelection()		 */		public function get selectionBeginIndex():int		{			return _tf.selectionBeginIndex;		}						/**		 * Gets the index position of the last selected character in a selection 		 * of one or more characters. 		 * <p>The index position of a selected character is zero-based and calculated 		 * from the first character that appears in the text area. If there is no 		 * selection, this value is set to the position of the caret.</p>		 *		 * @see #selectionBeginIndex		 * @see #setSelection()		 */		public function get selectionEndIndex():int		{			return _tf.selectionEndIndex;		}				/**		 * Gets or sets a Boolean value that indicates whether extra white space is		 * removed from a TextInput component that contains HTML text. Examples 		 * of extra white space in the component include spaces and line breaks.		 * A value of <code>true</code> indicates that extra 		 * white space is removed; a value of <code>false</code> indicates that extra 		 * white space is not removed.		 * <p>This property affects only text that is set by using the <code>htmlText</code> 		 * property; it does not affect text that is set by using the <code>text</code> property. 		 * If you use the <code>text</code> property to set text, the <code>condenseWhite</code> 		 * property is ignored.</p>		 * <p>If the <code>condenseWhite</code> property is set to <code>true</code>, you 		 * must use standard HTML commands, such as &lt;br&gt; and &lt;p&gt;, to place line 		 * breaks in the text field.</p>		 *		 * @see flash.text.TextField#condenseWhite TextField.condenseWhite		 */		public function get condenseWhite():Boolean		{			return _tf.condenseWhite;		}				public function set condenseWhite(v:Boolean):void 		{			_tf.condenseWhite = v;		}						/**		 * Contains the HTML representation of the string that the text field contains.		 * @see #text		 * @see flash.text.TextField#htmlText		 */		public function get htmlText():String		{			return _tf.htmlText;		}				public function set htmlText(v:String):void		{			if (v == "")			{ 				text = "";				return;			}						_isHTML = true;			_savedHTML = _tf.htmlText = v;			invalidate(InvalidationType.DATA);			invalidate(InvalidationType.STYLES);		}						/**		 * The height of the text, in pixels.		 * @see #textWidth		 */		public function get textHeight():Number		{			return _tf.textHeight;		}						/**		 * The width of the text, in pixels.		 * @see #textHeight		 */		public function get textWidth():Number		{			return _tf.textWidth;		}						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @private		 */		override protected function onFocusIn(e:FocusEvent):void		{			if (e.target == this) stage.focus = _tf;			var fm:IFocusManager = focusManager;						if (editable && fm)			{				fm.showFocusIndicator = true;				if (_tf.selectable && _tf.selectionBeginIndex == _tf.selectionBeginIndex)				{					setSelection(0, _tf.length);				}			}						super.onFocusIn(e);			if (editable) setIMEMode(true);		}						/**		 * @private		 */		override protected function onFocusOut(e:FocusEvent):void		{			super.onFocusOut(e);			if (editable) setIMEMode(false);		}						/**		 * @private		 */		protected function onKeyDown(e:KeyboardEvent):void		{			if (e.keyCode == Keyboard.ENTER)				dispatchEvent(new ComponentEvent(ComponentEvent.ENTER, true));		}						/**		 * @private		 */		protected function onChange(e:Event):void		{			/* so you don't get two change events */			e.stopPropagation();			dispatchEvent(new Event(Event.CHANGE, true));		}						/**		 * @private		 */		protected function onTextInput(e:TextEvent):void		{			e.stopPropagation();			dispatchEvent(new TextEvent(TextEvent.TEXT_INPUT, true, false, e.text));		}						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @private		 */		override protected function configUI():void		{			super.configUI();						tabChildren = true;			_tf = new TextField();			_tf.addEventListener(TextEvent.TEXT_INPUT, onTextInput, false, 0, true);			_tf.addEventListener(Event.CHANGE, onChange, false, 0, true);			_tf.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);						addChild(_tf);			updateTextFieldType();		}						/**		 * @private		 */		override protected function draw():void		{			if (isInvalid(InvalidationType.STYLES, InvalidationType.STATE))			{				drawTextFormat();				drawBackground();				setEmbedFont();				invalidate(InvalidationType.SIZE, false);			}						if (isInvalid(InvalidationType.SIZE)) drawLayout();			super.draw();		}						/**		 * @private		 */		override protected function isOurFocus(target:DisplayObject):Boolean		{			return target == _tf || super.isOurFocus(target);		}						/**		 * @private		 */		protected function updateTextFieldType():void		{			_tf.type = (enabled && editable) ? TextFieldType.INPUT : TextFieldType.DYNAMIC;			_tf.selectable = enabled;		}						/**		 * @private		 */		protected function setEmbedFont():void		{			_tf.embedFonts = getStyleValue("embedFonts") as Boolean;		}						/**		 * @private		 */		protected function drawBackground():void		{			var bg:DisplayObject = _bg;			var styleName:String = (enabled) ? "upSkin" : "disabledSkin";			_bg = getDisplayObjectInstance(getStyleValue(styleName));			if (!_bg) return;			addChildAt(_bg, 0);			if (bg && bg != _bg && contains(bg)) removeChild(bg);		}						/**		 * @private		 */		protected function drawTextFormat():void		{			/* Apply a default textformat */			var uiStyles:Object = UIComponent.styleDefinition;			var defaultFormat:TextFormat = (enabled)				? uiStyles["defaultTextFormat"] as TextFormat				: uiStyles["defaultDisabledTextFormat"] as TextFormat;						_tf.setTextFormat(defaultFormat);						var f:TextFormat = getStyleValue(enabled ? "textFormat" : "disabledTextFormat")				as TextFormat;						if (f) _tf.setTextFormat(f);			else f = defaultFormat;						_tf.defaultTextFormat = f;						setEmbedFont();			if (_isHTML) _tf.htmlText = _savedHTML;		}						/**		 * @private		 */		protected function drawLayout():void		{			var padding:Number = Number(getStyleValue("textPadding"));						if (_bg)			{				_bg.width = width;				_bg.height = height;			}						_tf.width = width - 2 * padding;			_tf.height = height - 2 * padding;			_tf.x = _tf.y = padding;		}	}}