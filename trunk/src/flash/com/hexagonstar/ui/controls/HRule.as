/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.ui.controls{	import com.hexagonstar.display.shapes.LineShape;	import com.hexagonstar.ui.Component;		/**	 * HRule Class	 */	public class HRule extends Component	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				protected var _line:LineShape;		protected var _color:uint = 0x111111;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new HRuler instance.		 * 		 * @param x The x position to place this component.		 * @param y The y position to place this component.		 */		public function HRule(x:Number = 0, y:Number = 0, width:Number = 0)		{			super(x, y);		}						/**		 * Draws the visual UI of the component.		 */		override public function draw():void		{			super.draw();						_line.draw(0, 0, _width, 0, 1, _color);			_line.filters = (_hasShadow) ? [createShadow(1)] : [];		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Gets / sets the color of the rule.		 */		public function set color(v:uint):void		{			_color = v;			invalidate();		}				public function get color():uint		{			return _color;		}						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Initializes the component.		 * @private		 */		override protected function init():void		{			super.init();			resize(200, 1);		}						/**		 * Creates and adds child display objects.		 * @private		 */		override protected function addChildren():void		{			_line = new LineShape();			addChild(_line);		}	}}