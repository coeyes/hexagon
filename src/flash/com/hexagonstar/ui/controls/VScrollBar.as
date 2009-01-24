/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.ui.controls{	import flash.events.Event;	import flash.events.MouseEvent;	import flash.geom.Rectangle;			/**	 * VScrollBar Class	 */	public class VScrollBar extends AbstractScrollBar	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new VScrollBar instance.		 * 		 * @param x The x position to place this component.		 * @param y The y position to place this component.		 */		public function VScrollBar(x:Number = 0, y:Number = 0)		{			super(x, y);		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Internal mouseDown handler. Starts dragging the handle.		 * @private		 */		override protected function onMouseDown(e:MouseEvent):void		{			super.onMouseDown(e);			_handle.startDrag(false, new Rectangle(0, 0, 0, _height - _handleSize));		}						/**		 * Internal mouseMove handler for when the handle is being moved.		 * @private		 */		override protected function onMouseMove(e:MouseEvent):void		{			var old:Number = _value;			_value = (_height - _width - _handle.y) / (_height - _width) * (_min - _max) + _max;			if (_value != old) dispatchEvent(new Event(Event.CHANGE));		}						/**		 * Handler called when user clicks the background of the ScrollBar,		 * causing the handle to move to that point. Only active if trackClick is true.		 * @private		 */		override protected function onTrackClick(e:MouseEvent):void		{			// TODO		}						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Initializes the component.		 */		override protected function init():void		{			super.init();			resize(6, 100);		}						/**		 * Draws the handle of the ScrollBar.		 * @private		 */		override protected function drawHandle():void		{			_handleSize = _height / (_max / 4);			if (_handleSize < 20) _handleSize = 20;			else if (_handleSize > _height / 3) _handleSize = _height / 3;						with (_handle.graphics)			{				clear();				beginFill(0x555555);				drawRect(1, 1, _width - 2, _handleSize - 2);				endFill();			}						positionHandle();		}						/**		 * Adjusts position of handle when value, maximum or minimum have changed.		 * TODO: Should also be called when ScrollBar is resized.		 * @private		 */		override protected function positionHandle():void		{			var v:Number = _height - _handleSize - (_value - _max) / (_min - _max)				* (_height - _width);						if (v < 0) v = 0;			else if (v > _height - _handle.height) v = _height - _handle.height;			_handle.y = v;		}	}}