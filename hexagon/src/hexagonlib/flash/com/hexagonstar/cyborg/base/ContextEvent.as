/*
 * cyborg - ActionScript3 application framework based on robotlegs.
 * 
 *  ___   |_  __    __
 * |___\_||_|(__)|/|__|
 *      _|           _|
 *  
 * Licensed under the MIT License
 * 
 * Copyright (c) 2010 Hexagon Star Softworks
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
package com.hexagonstar.cyborg.base
{
	import flash.events.Event;

	
	/**
	 * A framework Event implementation
	 */
	public class ContextEvent extends Event
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		
		public static const STARTUP:String			= "startup";
		public static const STARTUP_COMPLETE:String	= "startupComplete";
		public static const SHUTDOWN:String			= "shutdown";
		public static const SHUTDOWN_COMPLETE:String	= "shutdownComplete";
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		protected var _body:*;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * A generic context <code>Event</code> implementation
		 *
		 * <p>This class is handy for prototype work, but it's usage is not considered
		 * Best Practice</p>
		 *
		 * @param type The <code>Event</code> type
		 * @param body A loosely typed payload
		 */
		public function ContextEvent(type:String, body:* = null)
		{
			super(type);
			_body = body;
		}

		
		override public function clone():Event
		{
			return new ContextEvent(type, body);
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Loosely typed <code>Event</code> payload
		 * @return Payload
		 */
		public function get body():*
		{
			return _body;
		}
	}
}
