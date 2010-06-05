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
package com.hexagonstar.cyborg.core
{
	/**
	 * The CommandMap contract
	 */
	public interface ICommandMap
	{
		/**
		 * Detain a Command instance
		 * 
		 * @param command The Command instance to detain
		 */
		function detain(command:Object):void;
		
		
		/**
		 * Release a Command instance
		 * 
		 * @param command The Command instance to release for garbage collection
		 */
		function release(command:Object):void;
		
		
		/**
		 * Execute a Command with an optional payload
		 * <p>
		 * The <code>commandClass</code> must implement an execute() method
		 * </p>
		 * 
		 * @param commandClass The Class to instantiate - must have an execute() method
		 * @param payload An optional payload
		 * @param payloadClass An optional class to inject the payload as
		 * @param named An optional name for the payload injection
		 * @throws org.robotlegs.base::ContextError
		 */
		function execute(commandClass:Class, payload:Object = null,
			payloadClass:Class = null, named:String = ""):void;
		
		
		/**
		 * Map a Class to an Event type
		 * <p>
		 * The <code>commandClass</code> must implement an execute() method
		 * </p>
		 * 
		 * @param eventType The Event type to listen for
		 * @param commandClass The Class to instantiate - must have an execute() method
		 * @param eventClass Optional Event class for a stronger mapping. Defaults to
		 *            <code>flash.events.Event</code>. Your commandClass can optionally
		 *            [Inject] a variable of this type to access the event that triggered
		 *            the command.
		 * @param oneshot Unmap the Class after execution?
		 * @throws org.robotlegs.base::ContextError
		 */
		function mapEvent(eventType:String, commandClass:Class, eventClass:Class = null,
			oneshot:Boolean = false):void;
		
		
		/**
		 * Unmap a Class to Event type mapping
		 * 
		 * @param eventType The Event type
		 * @param commandClass The Class to unmap
		 * @param eventClass Optional Event class for a stronger mapping. Defaults to
		 *            <code>flash.events.Event</code>.
		 */
		function unmapEvent(eventType:String, commandClass:Class,
			eventClass:Class = null):void;
		
		
		/**
		 * Removes all mappings made through <code>mapEvent</code>
		 */
		function unmapEvents():void;
		
		/**
		 * Check if a Class has been mapped to an Event type
		 * 
		 * @param eventType The Event type
		 * @param commandClass The Class
		 * @param eventClass Optional Event class for a stronger mapping. Defaults to
		 *            <code>flash.events.Event</code>.
		 * @return Whether the Class is mapped to this Event type
		 */
		function hasEventCommand(eventType:String, commandClass:Class,
			eventClass:Class = null):Boolean;
	}
}
