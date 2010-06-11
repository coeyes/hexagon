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
	 * LazyMediatorActivator
	 */
	public class LazyMediatorActivator
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		private var _view:DisplayObject;
		private var _oneShot:Boolean;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Construct a <code>LazyMediatorActivator</code>.
		 * 
		 * @param view View target.
		 * @param oneShot If stop when the view is removed from stage.
		 */
		public function LazyMediatorActivator(view:DisplayObject, oneShot:Boolean = false)
		{
			_view = view;
			_oneShot = oneShot;
			
			if (view.stage)
			{
				triggerActivateMediatorEvent();
			}
			else
			{
				view.addEventListener(Event.ADDED_TO_STAGE, onViewAddedToStage);
			}
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Event Handlers                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		private function onViewAddedToStage(e:Event):void
		{
			_view.removeEventListener(Event.ADDED_TO_STAGE, onViewAddedToStage);
			triggerActivateMediatorEvent();
		}
		
		
		private function onViewRemovedFromStage(e:Event):void
		{
			_view.removeEventListener(Event.REMOVED_FROM_STAGE, onViewRemovedFromStage);
			triggerDeactivateMediatorEvent();
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		
		private function triggerActivateMediatorEvent():void
		{
			_view.dispatchEvent(new LazyMediatorEvent(LazyMediatorEvent.VIEW_ADDED, _view));
			_view.addEventListener(Event.REMOVED_FROM_STAGE, onViewRemovedFromStage);
		}
		
		
		private function triggerDeactivateMediatorEvent():void
		{
			_view.dispatchEvent(new LazyMediatorEvent(LazyMediatorEvent.VIEW_REMOVED,
				_view));
			if (!_oneShot)
			{
				_view.addEventListener(Event.ADDED_TO_STAGE, onViewAddedToStage);
			}
		}
	}
}
