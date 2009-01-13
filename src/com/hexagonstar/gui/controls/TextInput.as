/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.gui.controls{	import com.hexagonstar.display.shapes.RectangleShape;	import com.hexagonstar.gui.Component;		import flash.display.DisplayObjectContainer;	import flash.display.Sprite;	import flash.events.Event;	import flash.text.TextField;	import flash.text.TextFieldType;	import flash.text.TextFormat;			/**	 * TextInput Class	 */	public class TextInput extends Component	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				protected var _bg:RectangleShape;		protected var _tf:TextField;		protected var _text:String = "";		protected var _isPassword:Boolean = false;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new TextInput instance.		 * 		 * @param x The x position to place this component.		 * @param y The y position to place this component.		 * @param text The string containing the initial text of this component.		 * @param defaultHandler The event handling function to handle the default event		 *         for this component (Event.Change in this case).		 */		public function TextInput(x:Number = 0,									 y:Number =  0,									 text:String = "",									 defaultHandler:Function = null)		{			_text = text;			super(x, y);						if (defaultHandler != null) addEventListener(Event.CHANGE, defaultHandler);		}						/**		 * Draws the visual UI of the component.		 */		override public function draw():void		{			super.draw();						_bg.draw(_width, _height, 0x333333);			_bg.filters = (_hasShadow) ? [createShadow(1, true)] : [];						_tf.displayAsPassword = _isPassword;			_tf.text = _text;			_tf.width = _width - 4;						if (_tf.text == "")			{				_tf.text = "X";				_tf.height = Math.min(_tf.textHeight + 4, _height);				_tf.text = "";			}			else			{				_tf.height = Math.min(_tf.textHeight + 4, _height);			}						_tf.x = 2;			_tf.y = Math.round(_height / 2 - _tf.height / 2);		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Gets / sets the text shown in this InputText.		 */		public function set text(v:String):void		{			_text = v;			invalidate();		}				public function get text():String		{			return _text;		}				/**		 * Gets / sets the list of characters that are allowed in this TextInput.		 */		public function set restrict(v:String):void		{			_tf.restrict = v;		}				public function get restrict():String		{			return _tf.restrict;		}				/**		 * Gets / sets the maximum number of characters that can be shown in this InputText.		 */		public function set maxChars(v:int):void		{			_tf.maxChars = v;		}				public function get maxChars():int		{			return _tf.maxChars;		}				/**		 * Gets / sets whether or not this input text will show up as password (asterisks).		 */		public function set password(v:Boolean):void		{			_isPassword = v;			invalidate();		}				public function get password():Boolean		{			return _isPassword;		}						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Internal change handler.		 * @private		 * 		 * @param e The Event passed by the system.		 */		protected function onChange(e:Event):void		{			_text = _tf.text;		}						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Initializes the component.		 * @private		 */		override protected function init():void		{			super.init();			resize(200, 22);		}						/**		 * Creates and adds child display objects.		 * @private		 */		override protected function addChildren():void		{			_bg = new RectangleShape();			addChild(_bg);						_tf = new TextField();			//_tf.embedFonts = true;			_tf.selectable = true;			_tf.type = TextFieldType.INPUT;			_tf.defaultTextFormat = new TextFormat("sans", 11, 0xFFFFFF);			_tf.addEventListener(Event.CHANGE, onChange);			addChild(_tf);		}	}}