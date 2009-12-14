/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.display.text{	import flash.display.Sprite;	import flash.text.AntiAliasType;	import flash.text.TextField;	import flash.text.TextFieldAutoSize;	import flash.text.TextFormat;		/**	 * QuickTextField Class	 */	public class QuickTextField extends Sprite	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				protected var _tf:TextField;		protected var _format:TextFormat;		protected var _bgColor:uint;		protected var _bgAlpha	:Number;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new QuickTextField instance.		 */		public function QuickTextField(text:String = "",											width:int = 0,											height:int = 0,											format:TextFormat = null,											textSize:int = 11,											textColor:uint = 0x000000,											fontFace:String = "",											background:Boolean = false,											bgColor:uint = 0xFFFFFF,											bgAlpha:Number = 1.0)		{			if (format)			{				_format = format;			}			else			{				if (fontFace == "") fontFace = "Arial";				_format = new TextFormat(fontFace, textSize, textColor);			}						createTextField(width, height);						_tf.text = text;						if (background)			{				_bgColor = bgColor;				_bgAlpha = bgAlpha;				if (width > 0 && text != "")				{					createBackground();				}			}						addChild(_tf);		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				public function get text():String		{			return _tf.text;		}		public function set text(v:String):void		{			_tf.text = v;			createBackground();		}						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * createTextField		 * @private		 */		protected function createTextField(w:int, h:int):void		{			_tf = new TextField();			_tf.defaultTextFormat = _format;			_tf.selectable = false;			_tf.multiline = false;			_tf.antiAliasType = AntiAliasType.ADVANCED;			//_tf.border = true;			//_tf.borderColor = 0x55FF00FF;						if (w < 1)			{				_tf.autoSize = TextFieldAutoSize.LEFT;			}			else			{				_tf.width = w;				_tf.text = "X";				_tf.height = _tf.textHeight + 2;			}		}						/**		 * createBackground		 * @private		 */		protected function createBackground():void		{			with (graphics)			{				clear();				lineStyle();				beginFill(_bgColor, _bgAlpha);				drawRect(0, 0, _tf.width, _tf.height);				endFill();			}		}	}}