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
	/**
	 * A framework Error implementation
	 */
	public class ContextError extends Error
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		
		public static const E_COMMANDMAP_NOIMPL:String	= "Command Class does not implement an execute() method";
		public static const E_COMMANDMAP_OVR:String		= "Cannot overwrite map";
		public static const E_MEDIATORMAP_NOIMPL:String	= "Mediator Class does not implement IMediator";
		public static const E_MEDIATORMAP_OVR:String		= "Mediator Class has already been mapped to a View Class in this context";
		public static const E_EVENTMAP_NOSNOOPING:String	= "Listening to the context eventDispatcher is not enabled for this EventMap";
		public static const E_CONTEXT_INJECTOR:String	= "The ContextBase does not specify a concrete IInjector. Please override the injector getter in your concrete or abstract Context.";
		public static const E_CONTEXT_REFLECTOR:String	= "The ContextBase does not specify a concrete IReflector. Please override the reflector getter in your concrete or abstract Context.";
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		public function ContextError(message:String = "", id:int = 0)
		{
			super(message, id);
		}
	}
}
