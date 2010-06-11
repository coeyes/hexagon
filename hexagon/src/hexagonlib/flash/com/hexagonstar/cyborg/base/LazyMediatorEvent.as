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
	import flash.display.DisplayObject;
	import flash.events.Event;

	
	/**
	 * Lazy mediator events triggered by LazyMediatorActivator and handled by
	 * LazyMediatorObserver.
	 */
	public class LazyMediatorEvent extends Event
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Trigger when a view is added to stage.
		 */
		public static const VIEW_ADDED:String = "viewAdded";
		
		/**
		 * Trigger when a view is removed from stage.
		 */
		public static const VIEW_REMOVED:String = "viewRemoved";
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		private var _view:DisplayObject;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Construct a <code>LazyMediatorEvent</code>.
		 * 
		 * @param type  Type of the event.
		 * @param view  The view componet being added/removed.
		 */
		public function LazyMediatorEvent(type:String, view:DisplayObject)
		{
			super(type, true);
			_view = view;
		}
		
		
		/**
		 * clone
		 */
		override public function clone():Event
		{
			return new LazyMediatorEvent(type, _view);
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * The view componet being added/removed.
		 */
		public function get view():DisplayObject
		{
			return _view;
		}
	}
}
