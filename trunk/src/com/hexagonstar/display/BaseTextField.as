/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.display{	import com.hexagonstar.env.IDisposable;	import com.hexagonstar.env.event.IRemovableEventDispatcher;	import com.hexagonstar.env.event.ListenerManager;		import flash.text.TextField;			/**	 * A base TextField that implements IRemovableEventDispatcher and IDisposable.	 */	public class BaseTextField extends TextField implements IRemovableEventDispatcher,		IDisposable	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				protected var _listenerManager:ListenerManager;		protected var _isDisposed:Boolean;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new BaseTextField instance.		 */		public function BaseTextField()		{			super();			_listenerManager = ListenerManager.getManager(this);		}						/**		 * @exclude		 */		override public function addEventListener(type:String,													listener:Function,													useCapture:Boolean = false,													priority:int = 0,													useWeakReference:Boolean = false):void		{			super.addEventListener(type, listener, useCapture, priority, useWeakReference);			_listenerManager.addEventListener(type, listener, useCapture, priority,				useWeakReference);		}				/**		 * @exclude		 */		override public function removeEventListener(type:String,													listener:Function,													useCapture:Boolean = false):void		{			super.removeEventListener(type, listener, useCapture);			_listenerManager.removeEventListener(type, listener, useCapture);		}				/**		 * Removes all event listeners.		 */		public function removeEventListeners():void		{			_listenerManager.removeEventListeners();		}						/**		 * Removes all events that report to the specified listener.		 * 		 * @param listener The listener function that processes the event.		 */		public function removeEventsForListener(listener:Function):void		{			_listenerManager.removeEventsForListener(listener);		}						/**		 * Removes all events of a specific type.		 * 		 * @param type The type of event.		 */		public function removeEventsForType(type:String):void		{			_listenerManager.removeEventsForType(type);		}						/**		 * {@inheritDoc}		 * 		 * Calling dispose on a base display object also removes it from its current parent.		 */		public function dispose():void 		{			removeEventListeners();			_listenerManager.dispose();			_isDisposed = true;						if (parent) parent.removeChild(this);		}						/**		 * Returns a string representation of the object		 * 		 * @return A string representation of the object.		 */		override public function toString():String		{			return "[BaseTextField]";		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				public function get isDisposed():Boolean 		{			return this._isDisposed;		}	}}