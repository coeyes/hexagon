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
	import com.hexagonstar.cyborg.base.MediatorBase;
	import com.hexagonstar.cyborg.core.IEventMap;
	import com.hexagonstar.cyborg.core.IMediatorMap;

	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.IEventDispatcher;

	
	/**
	 * Abstract MVCS <code>IMediator</code> implementation.
	 */
	public class Mediator extends MediatorBase
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////

		[Inject]
		public var contextView:DisplayObjectContainer;
		
		[Inject]
		public var mediatorMap:IMediatorMap;
		
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
		public function Mediator()
		{
		}
		
		
		/**
		 * @inheritDoc
		 */
		override public function preRemove():void
		{
			if (_eventMap)
			{
				_eventMap.unmapListeners();
			}
			super.preRemove();
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
		
		
		/**
		 * Local EventMap
		 * @return The EventMap for this Actor
		 */
		protected function get eventMap():IEventMap
		{
			return _eventMap || (_eventMap = new EventMap(eventDispatcher));
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Dispatch helper method.
		 *
		 * @param e The Event to dispatch on the <code>IContext</code>'s
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
		
		
		/**
		 * Syntactical sugar for mapping a listener to the <code>viewComponent</code> .
		 * 
		 * @param type
		 * @param listener
		 * @param eventClass
		 * @param useCapture
		 * @param priority
		 * @param useWeakReference
		 */		
		protected function addViewListener(type:String, listener:Function,
			eventClass:Class = null, useCapture:Boolean = false, priority:int = 0,
			useWeakReference:Boolean = true):void 
		{
			eventMap.mapListener(IEventDispatcher(_viewComponent), type, listener,
				eventClass, useCapture, priority, useWeakReference);
		}
		
		
		/**
		 * Syntactical sugar for mapping a listener to an <code>IEventDispatcher</code>.
		 * 
		 * @param dispatcher
		 * @param type
		 * @param listener
		 * @param eventClass
		 * @param useCapture
		 * @param priority
		 * @param useWeakReference
		 * 
		 */		
		protected function addContextListener(type:String, listener:Function,
			eventClass:Class = null, useCapture:Boolean = false, priority:int = 0,
			useWeakReference:Boolean = true):void
		{
			eventMap.mapListener(eventDispatcher, type, listener, eventClass, useCapture,
				priority, useWeakReference); 									   
		}
	}
}
