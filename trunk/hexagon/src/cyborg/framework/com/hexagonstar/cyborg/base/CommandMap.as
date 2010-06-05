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
	import com.hexagonstar.cyborg.core.ICommandMap;
	import com.hexagonstar.cyborg.core.IInjector;
	import com.hexagonstar.cyborg.core.IReflector;
	import com.hexagonstar.cyborg.mvcs.Command;

	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.describeType;

	
	/**
	 * An abstract <code>ICommandMap</code> implementation
	 */
	public class CommandMap implements ICommandMap
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * The <code>IEventDispatcher</code> to listen to
		 */
		protected var _eventDispatcher:IEventDispatcher;
		
		/**
		 * The <code>IInjector</code> to inject with
		 */
		protected var _injector:IInjector;
		
		/**
		 * The <code>IReflector</code> to reflect with
		 */
		protected var _reflector:IReflector;
		
		/**
		 * Internal
		 * TODO This needs to be documented
		 */
		protected var _eventTypeMap:Dictionary;
		
		/**
		 * Internal
		 * Collection of command classes that have been verified to implement
		 * an <code>execute</code> method.
		 */
		protected var _verifiedCommandClasses:Dictionary;
		
		/**
		 * @private
		 */
		protected var _detainedCommands:Dictionary;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new <code>CommandMap</code> object
		 *
		 * @param eventDispatcher The <code>IEventDispatcher</code> to listen to
		 * @param injector An <code>IInjector</code> to use for this context
		 * @param reflector An <code>IReflector</code> to use for this context
		 */
		public function CommandMap(eventDispatcher:IEventDispatcher, injector:IInjector,
			reflector:IReflector)
		{
			_eventDispatcher = eventDispatcher;
			_injector = injector;
			_reflector = reflector;
			_eventTypeMap = new Dictionary(false);
			_verifiedCommandClasses = new Dictionary(false);
			_detainedCommands = new Dictionary(false);
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function mapEvent(eventType:String, commandClass:Class,
			eventClass:Class = null, oneshot:Boolean = false):void
		{
			verifyCommandClass(commandClass);
			eventClass = eventClass || Event;
			
			var eventClassMap:Dictionary = _eventTypeMap[eventType]
				|| (_eventTypeMap[eventType] = new Dictionary(false));
			var callbacksByCommandClass:Dictionary = eventClassMap[eventClass]
				|| (eventClassMap[eventClass] = new Dictionary(false));
			
			if (callbacksByCommandClass[commandClass] != null)
			{
				throw new ContextError(ContextError.E_COMMANDMAP_OVR + " - eventType ("
					+ eventType + ") and Command (" + commandClass + ")");
			}
			
			var callback:Function = function(e:Event):void
			{
				routeEventToCommand(e, commandClass, oneshot, eventClass);
			};
			
			_eventDispatcher.addEventListener(eventType, callback, false, 0, true);
			callbacksByCommandClass[commandClass] = callback;
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function unmapEvent(eventType:String, commandClass:Class,
			eventClass:Class = null):void
		{
			var eventClassMap:Dictionary = _eventTypeMap[eventType];
			if (eventClassMap == null) return;
			
			var callbacksByCommandClass:Dictionary = eventClassMap[eventClass || Event];
			if (callbacksByCommandClass == null) return;
			
			var callback:Function = callbacksByCommandClass[commandClass];
			if (callback == null) return;
			
			_eventDispatcher.removeEventListener(eventType, callback, false);
			delete callbacksByCommandClass[commandClass];
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function unmapEvents():void
		{
			for (var eventType:String in _eventTypeMap)
			{
				var eventClassMap:Dictionary = _eventTypeMap[eventType];
				for each (var callbacksByCommandClass:Dictionary in eventClassMap)
				{
					for each (var callback:Function in callbacksByCommandClass)
					{
						_eventDispatcher.removeEventListener(eventType, callback, false);
					}
				}
			}
			_eventTypeMap = new Dictionary(false);
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function hasEventCommand(eventType:String, commandClass:Class,
			eventClass:Class = null):Boolean
		{
			var eventClassMap:Dictionary = _eventTypeMap[eventType];
			if (eventClassMap == null) return false;
			
			var callbacksByCommandClass:Dictionary = eventClassMap[eventClass || Event];
			if (callbacksByCommandClass == null) return false;
			
			return callbacksByCommandClass[commandClass] != null;
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function execute(commandClass:Class, payload:Object = null,
			payloadClass:Class = null, named:String = ""):void
		{
			verifyCommandClass(commandClass);
			
			if (payload != null || payloadClass != null)
			{
				payloadClass ||= _reflector.getClass(payload);
				_injector.mapValue(payloadClass, payload, named);
			}
			
			var command:Command = _injector.instantiate(commandClass);
			
			if (payload !== null || payloadClass != null)
			{
				_injector.unmap(payloadClass, named);
			}
			
			command.execute();
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function detain(command:Object):void
		{
			_detainedCommands[command] = true;
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function release(command:Object):void
		{
			if (_detainedCommands[command])
			{
				delete _detainedCommands[command];
			}
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Internal                                                                           //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @throws org.robotlegs.base::ContextError 
		 */
		protected function verifyCommandClass(commandClass:Class):void
		{
			if (!_verifiedCommandClasses[commandClass])
			{
				_verifiedCommandClasses[commandClass] =
					describeType(commandClass).factory.method.(@name == "execute").length();
				
				if (!_verifiedCommandClasses[commandClass])
				{
					throw new ContextError(ContextError.E_COMMANDMAP_NOIMPL
						+ " - " + commandClass);
				}
			}
		}
		
		
		/**
		 * Event Handler
		 *
		 * @param event The <code>Event</code>
		 * @param commandClass The Class to construct and execute
		 * @param oneshot Should this command mapping be removed after execution?
		 * @return <code>true</code> if the event was routed to a Command and the
		 *          Command was executed, <code>false</code> otherwise
		 */
		protected function routeEventToCommand(event:Event, commandClass:Class,
			oneshot:Boolean, originalEventClass:Class):Boolean
		{
			if (!(event is originalEventClass)) return false;
			execute(commandClass, event);
			if (oneshot) unmapEvent(event.type, commandClass, originalEventClass);
			return true;
		}
	}
}
