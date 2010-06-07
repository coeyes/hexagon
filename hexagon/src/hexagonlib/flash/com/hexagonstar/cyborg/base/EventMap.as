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
	import com.hexagonstar.cyborg.core.IEventMap;

	import flash.events.Event;
	import flash.events.IEventDispatcher;

	
	/**
	 * An abstract <code>IEventMap</code> implementation
	 */
	public class EventMap implements IEventMap
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * The <code>IEventDispatcher</code>
		 */
		protected var _eventDispatcher:IEventDispatcher;
		
		/**
		 * @private
		 */
		protected var _dispatcherListeningEnabled:Boolean = true;
		
		/**
		 * @private
		 */
		protected var _listeners:Vector.<Params>;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new <code>EventMap</code> object
		 *
		 * @param eventDispatcher An <code>IEventDispatcher</code> to treat as a bus
		 */
		public function EventMap(eventDispatcher:IEventDispatcher)
		{
			_listeners = new Vector.<Params>();
			_eventDispatcher = eventDispatcher;
		}
		
		
		/**
		 * The same as calling <code>addEventListener</code> directly on the
		 * <code>IEventDispatcher</code>, but keeps a list of listeners for easy
		 * (usually automatic) removal.
		 *
		 * @param dispatcher The <code>IEventDispatcher</code> to listen to
		 * @param type The <code>Event</code> type to listen for
		 * @param listener The <code>Event</code> handler
		 * @param eventClass Optional Event class for a stronger mapping. Defaults to
		 *         <code>flash.events.Event</code>.
		 * @param useCapture
		 * @param priority
		 * @param useWeakReference
		 */
		public function mapListener(dispatcher:IEventDispatcher, type:String,
			listener:Function, eventClass:Class = null, useCapture:Boolean = false,
			priority:int = 0, useWeakReference:Boolean = true):void
		{
			if (dispatcherListeningEnabled == false && dispatcher == _eventDispatcher)
			{
				throw new ContextError(ContextError.E_EVENTMAP_NOSNOOPING);
			}
			
			eventClass = eventClass || Event;
			var params:Params;
			var i:int = _listeners.length;
			
			while (i--)
			{
				params = _listeners[i];
				if (params.dispatcher == dispatcher
					&& params.type == type
					&& params.listener == listener
					&& params.useCapture == useCapture
					&& params.eventClass == eventClass)
				{
					return;
				}
			}
			
			var callback:Function = function(e:Event):void
			{
				routeEventToListener(e, listener, eventClass);
			};
			
			params = new Params(dispatcher, type, listener, eventClass, callback, useCapture);
			_listeners.push(params);
			dispatcher.addEventListener(type, callback, useCapture, priority, useWeakReference);
		}
		
		
		/**
		 * The same as calling <code>removeEventListener</code> directly on the
		 * <code>IEventDispatcher</code>, but updates our local list of listeners.
		 *
		 * @param dispatcher The <code>IEventDispatcher</code>
		 * @param type The <code>Event</code> type
		 * @param listener The <code>Event</code> handler
		 * @param eventClass Optional Event class for a stronger mapping. Defaults to
		 *         <code>flash.events.Event</code>.
		 * @param useCapture
		 */
		public function unmapListener(dispatcher:IEventDispatcher, type:String,
			listener:Function, eventClass:Class = null, useCapture:Boolean = false):void
		{
			eventClass = eventClass || Event;
			var params:Params;
			var i:int = _listeners.length;
			
			while (i--)
			{
				params = _listeners[i];
				if (params.dispatcher == dispatcher
					&& params.type == type
					&& params.listener == listener
					&& params.useCapture == useCapture
					&& params.eventClass == eventClass)
				{
					dispatcher.removeEventListener(type, params.callback, useCapture);
					_listeners.splice(i, 1);
					return;
				}
			}
		}
		
		
		/**
		 * Removes all listeners registered through <code>mapListener</code>
		 */
		public function unmapListeners():void
		{
			var params:Params;
			var dispatcher:IEventDispatcher;
			
			while (params = _listeners.pop())
			{
				dispatcher = params.dispatcher;
				dispatcher.removeEventListener(params.type, params.callback, params.useCapture);
			}
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @return Is shared dispatcher listening allowed?
		 */
		public function get dispatcherListeningEnabled():Boolean
		{
			return _dispatcherListeningEnabled;
		}
		
		/**
		 * @private
		 */
		public function set dispatcherListeningEnabled(v:Boolean):void
		{
			_dispatcherListeningEnabled = v;
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Internal                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Event Handler
		 *
		 * @param event The <code>Event</code>
		 * @param listener
		 * @param originalEventClass
		 */
		protected function routeEventToListener(e:Event, listener:Function,
			originalEventClass:Class):void
		{
			if (e is originalEventClass)
			{
				listener(e);
			}
		}
	}
}


import flash.events.IEventDispatcher;

class Params
{
	public var dispatcher:IEventDispatcher;
	public var type:String;
	public var listener:Function;
	public var eventClass:Class;
	public var callback:Function;
	public var useCapture:Boolean;
	
	public function Params(d:IEventDispatcher, t:String, l:Function, e:Class,
		c:Function, u:Boolean)
	{
		dispatcher = d;
		type = t;
		listener = l;
		eventClass = e;
		callback = c;
		useCapture = u;
	}
}
