/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.display.sprites{	import com.hexagonstar.display.BaseSprite;	import com.hexagonstar.display.StageReference;			/**	 * PaddedSprite Class	 * 	 * TODO biig todo here!	 */	public class PaddedSprite extends BaseSprite	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				protected var _paddingLeft:int;		protected var _paddingRight:int;		protected var _paddingTop:int;		protected var _paddingBottom:int;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new PaddedSprite instance.		 * 		 * @param padding The padding around all four sides in the PaddedSprite.		 * @param width The width of the PaddedSprite. If NaN, it equals the stageWidth.		 * @param height The height of the PaddedSprite. If NaN, it equals the stageHeight.		 */		public function PaddedSprite(padding:int = 0, width:int = NaN, height:int = NaN)		{			super();						this.padding = padding;			this.width = (width == NaN) ? StageReference.stage.stageWidth : width;			this.height = (height == NaN) ? StageReference.stage.stageHeight : height;		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				public function set padding(v:int):void		{			_paddingLeft = _paddingRight = _paddingTop = _paddingBottom = v;		}				public function get paddingLeft():int		{			return _paddingLeft;		}				public function set paddingLeft(v:int):void		{			_paddingLeft = v;		}				public function get paddingRight():int		{			return _paddingRight;		}				public function set paddingRight(v:int):void		{			_paddingRight = v;		}				public function get paddingTop():int		{			return _paddingTop;		}				public function set paddingTop(v:int):void		{			_paddingTop = v;		}				public function get paddingBottom():int		{			return _paddingBottom;		}				public function set paddingBottom(v:int):void		{			_paddingBottom = v;		}						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////			}}