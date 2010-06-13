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
	import com.hexagonstar.core.BasicClass;
	import com.hexagonstar.cyborg.core.IMediator;

	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.getDefinitionByName;

	
	/**
	 * An abstract <code>IMediator</code> implementation.
	 */
	public class MediatorBase extends BasicClass implements IMediator
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Flex framework work-around part #1.
		 * @private
		 */
		protected static var _UIComponentClass:Class;
		
		/**
		 * Flex framework work-around part #2.
		 * @private
		 */
		protected static const _flexAvailable:Boolean = checkFlex();
		
		/**
		 * Internal
		 * <p>This Mediator's View Component, used by the cyborg MVCS framework internally.
		 * You should declare a dependency on a concrete view component in your
		 * implementation instead of working with this property.</p>
		 * 
		 * @private
		 */
		protected var _viewComponent:Object;
		
		/**
		 * Internal
		 * <p>In the case of deffered instantiation, onRemove might get called before
		 * onCreationComplete has fired. This here Bool helps us track that scenario.</p>
		 */
		protected var _removed:Boolean;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new <code>Mediator</code> object.
		 */
		public function MediatorBase()
		{
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function preRegister():void
		{
			_removed = false;
			
			if (_flexAvailable && (_viewComponent is _UIComponentClass)
				&& !_viewComponent["initialized"])
			{
				IEventDispatcher(_viewComponent).addEventListener("creationComplete",
					onCreationComplete, false, 0, true);
			}
			else
			{
				onRegister();
			}
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function onRegister():void
		{
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function onRemove():void
		{
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function preRemove():void
		{
			_removed = true;
			onRemove();
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function getViewComponent():Object
		{
			return _viewComponent;
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function setViewComponent(viewComponent:Object):void
		{
			_viewComponent = viewComponent;
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Internal                                                                           //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Flex framework work-around part #3.
		 * <p>Checks for availability of the Flex framework by trying to get the
		 * class for UIComponent.</p>
		 */
		protected static function checkFlex():Boolean
		{
			try
			{
				_UIComponentClass = getDefinitionByName("mx.core::UIComponent") as Class;
			}
			catch (err:Error)
			{
				/* do nothing */
			}
			return _UIComponentClass != null;
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Event Handlers                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Flex framework work-around part #4.
		 * <p><code>FlexEvent.CREATION_COMPLETE</code> handler for this Mediator's
		 * View Component</p>
		 *
		 * @param e The Flex <code>FlexEvent</code> event.
		 */
		protected function onCreationComplete(e:Event):void
		{
			IEventDispatcher(e.target).removeEventListener("creationComplete",
				onCreationComplete);
			
			if (!_removed) onRegister();
		}
	}
}
