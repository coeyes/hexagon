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
	import com.hexagonstar.cyborg.core.IInjector;
	import com.hexagonstar.cyborg.core.IReflector;

	import flash.display.DisplayObjectContainer;

	
	/**
	 * LazyMediatorMap
	 */
	public class LazyMediatorMap extends MediatorMap
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		public function LazyMediatorMap(contextView:DisplayObjectContainer,
			injector:IInjector, reflector:IReflector)
		{
			super(contextView, injector, reflector);
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Internal                                                                           //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		override protected function addListeners():void
		{
			if (contextView && enabled && _active)
			{
				contextView.addEventListener(LazyMediatorEvent.VIEW_ADDED, onViewAdded,
					true, 0, true);
				contextView.addEventListener(LazyMediatorEvent.VIEW_REMOVED, onViewRemoved,
					true, 0, true);
			}
		}
		
		
		/**
		 * @private
		 */
		override protected function removeListeners():void
		{
			if (contextView && enabled && _active)
			{
				contextView.removeEventListener(LazyMediatorEvent.VIEW_ADDED,
					onViewAdded, true);
				contextView.removeEventListener(LazyMediatorEvent.VIEW_REMOVED,
					onViewRemoved, true);
			}
		}
	}
}
