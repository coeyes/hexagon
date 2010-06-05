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
package com.hexagonstar.cyborg.mvcs
{
	import com.hexagonstar.cyborg.core.ICommandMap;
	import com.hexagonstar.cyborg.core.IInjector;
	import com.hexagonstar.cyborg.core.IMediatorMap;

	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.IEventDispatcher;

	
	/**
	 * Abstract MVCS command implementation.
	 */
	public class Command
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////

		[Inject]
		public var contextView:DisplayObjectContainer;
		
		[Inject]
		public var commandMap:ICommandMap;
		
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		
		[Inject]
		public var injector:IInjector;
		
		[Inject]
		public var mediatorMap:IMediatorMap;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Constructor.
		 */
		public function Command()
		{
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function execute():void
		{
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Dispatch helper method
		 *
		 * @param e The <code>Event</code> to dispatch on the <code>IContext</code>'s
		 * <code>IEventDispatcher</code>.
		 */
		protected function dispatch(e:Event):Boolean
		{
			if (eventDispatcher.hasEventListener(e.type))
			{
 		        return eventDispatcher.dispatchEvent(e);
			}
			return false;  
		}
	}
}
