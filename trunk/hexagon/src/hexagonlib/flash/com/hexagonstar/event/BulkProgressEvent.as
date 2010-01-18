/*
 * hexagonlib - Multi-Purpose ActionScript 3 Library.
 *       __    __
 *    __/  \__/  \__    __
 *   /  \__/HEXAGON \__/  \
 *   \__/  \__/  LIBRARY _/
 *            \__/  \__/
 *
 * Licensed under the MIT License
 * 
 * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
package com.hexagonstar.event
{
	import flash.events.Event;
	import flash.events.ProgressEvent;

	
	/**
	 * @author Sascha Balkau
	 * @version 1.0.0
	 */
	public class BulkProgressEvent extends ProgressEvent
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/** @private */
		protected var _weightPercent:Number;
		/** @private */
		protected var _percentLoaded:int;
		/** @private */
		protected var _ratioLoaded:Number;
		/** @private */
		protected var _bytesTotalCurrent:int;
		/** @private */
		protected var _filesLoaded:int;
		/** @private */
		protected var _filesTotal:int;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * 
		 */
		public function BulkProgressEvent(type:String,
											bytesLoaded:int,
											bytesTotal:int,
											bytesTotalCurrent:int,
											filesLoaded:int,
											filesTotal:int,
											weightPercent:Number,
											bubbles:Boolean = false,
											cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			
			this.bytesLoaded = bytesLoaded;
			this.bytesTotal = bytesTotal;
			_bytesTotalCurrent = bytesTotalCurrent;
			_filesLoaded = filesLoaded;
			_filesTotal = filesTotal;
			_weightPercent = weightPercent;
			
			percentLoaded = bytesTotal > 0 ? ((bytesLoaded / bytesTotal) * 100) : 0;
			ratioLoaded = _filesTotal == 0 ? 0 : _filesLoaded / _filesTotal;
		}
		
		
		/**
		 * Clones the event.
		 */
		override public function clone():Event
		{
			return new BulkProgressEvent(type, bytesLoaded, bytesTotal, _bytesTotalCurrent,
				_filesLoaded, _filesTotal, _weightPercent, bubbles, cancelable);
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * A number between 0 - 1 that indicates progress regarding weights.
		 */
		public function get weightPercent():Number
		{
			return _weightPercent;
		}
		public function set weightPercent(v:Number):void
		{ 
			if (isNaN(v) || !isFinite(v)) v = 0;
			_weightPercent = v;
		}
		
		
		/**
		 * A number between 0 - 1 that indicates progress regarding bytes.
		 */
		public function get percentLoaded():int
		{
			return _percentLoaded;
		}
		public function set percentLoaded(v:int):void
		{
			if (isNaN(v) || !isFinite(v)) v = 0;
			_percentLoaded = v;
		}
		
		
		/**
		 * The ratio (0-1) loaded (number of items loaded / number of items total).
		 */
		public function get ratioLoaded():Number
		{
			return _ratioLoaded;
		}
		public function set ratioLoaded(v:Number):void
		{
			if (isNaN(v) || !isFinite(v)) v = 0;
			_ratioLoaded = v;
		}
	}
}
