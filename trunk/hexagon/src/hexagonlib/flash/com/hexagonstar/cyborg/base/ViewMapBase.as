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

	import flash.display.DisplayObjectContainer;
	import flash.events.Event;

	
	/**
	 * A base ViewMap implementation
	 */
	public class ViewMapBase
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/** @private */
		protected var _enabled:Boolean = true;
		/** @private */
		protected var _active:Boolean = true;
		/** @private */
		protected var _contextView:DisplayObjectContainer;
		/** @private */
		protected var _injector:IInjector;
		/** @private */
		protected var _useCapture:Boolean;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new <code>ViewMap</code> object
		 *
		 * @param contextView The root view node of the context. The map will listen for
		 *         ADDED_TO_STAGE events on this node
		 * @param injector An <code>IInjector</code> to use for this context
		 */
		public function ViewMapBase(contextView:DisplayObjectContainer, injector:IInjector)
		{
			_injector = injector;
			
			// change this at your peril lest ye understand the problem and have a better solution
			_useCapture = true;
			
			// this must come last, see the setter!
			this.contextView = contextView;
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		public function get contextView():DisplayObjectContainer
		{
			return _contextView;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set contextView(v:DisplayObjectContainer):void
		{
			if (v != _contextView)
			{
				removeListeners();
				_contextView = v;
				addListeners();
			}
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set enabled(v:Boolean):void
		{
			if (v != _enabled)
			{
				removeListeners();
				_enabled = v;
				addListeners();
			}
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Internal                                                                           //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		protected function activate():void
		{
			if (!_active)
			{
				_active = true;
				addListeners();
			}
		}
		
		
		/**
		 * @private
		 */
		protected function addListeners():void
		{
		}
		
		
		/**
		 * @private
		 */
		protected function removeListeners():void
		{
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Event Handlers                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		protected function onViewAdded(e:Event):void
		{
		}
	}
}
