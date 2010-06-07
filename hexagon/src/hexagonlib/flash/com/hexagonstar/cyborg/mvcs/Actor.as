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
	import com.hexagonstar.cyborg.base.EventMap;
	import com.hexagonstar.cyborg.core.IEventMap;

	import flash.events.Event;
	import flash.events.IEventDispatcher;

	
	/**
	 * Abstract MVCS <code>IActor</code> implementation.
	 * <p>
	 * As part of the MVCS implementation the <code>Actor</code> provides core
	 * functionality to an applications various working parts.
	 * </p>
	 * <p>
	 * Some possible uses for the <code>Actor</code> include, but are by no means
	 * limited to:
	 * </p>
	 * <ul>
	 * <li>Service classes</li>
	 * <li>Model classes</li>
	 * <li>Controller classes</li>
	 * <li>Presentation model classes</li>
	 * </ul>
	 * <p>
	 * Essentially any class where it might be advantagous to have basic dependency
	 * injection supplied is a candidate for extending <code>Actor</code>.
	 * </p>
	 */
	public class Actor
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/** @private */
		protected var _eventDispatcher:IEventDispatcher;
		/** @private */
		protected var _eventMap:IEventMap;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Constructor.
		 */
		public function Actor()
		{
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		public function get eventDispatcher():IEventDispatcher
		{
			return _eventDispatcher;
		}

		[Inject]
		/**
		 * @private
		 */
		public function set eventDispatcher(v:IEventDispatcher):void
		{
			_eventDispatcher = v;
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Internal                                                                           //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Local EventMap.
		 * 
		 * @return The EventMap for this Actor
		 */
		protected function get eventMap():IEventMap
		{
			return _eventMap || (_eventMap = new EventMap(eventDispatcher));
		}
		
		
		/**
		 * Dispatch helper method.
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
