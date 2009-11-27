/*
 * tetragon - Application framework for Flash, Flash/AIR, Flex & Flex/AIR.
 * 
 * Licensed under the MIT License
 * Copyright (c) 2008-2009 Sascha Balkau / Hexagon Star Softworks
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
 */package com.hexagonstar.framework.view 
{
	import flash.events.IEventDispatcher;

	
	/**
	 * IView is the base interface for all view classes.
	 * 
	 * @author Sascha Balkau
	 * @version 1.0.0
	 */
	public interface IView extends IEventDispatcher
	{
		/**
		 * Updates the view. This method should be called only if children
		 * of the view need to be updated, e.g. after localization has been
		 * changed or if the children need to be re-layouted.
		 */
		function update():void;
		
		
		/**
		 * Disposes the view to clean up resources that are no longer in use.
		 */
		function dispose():void;
		
		
		/**
		 * Returns a String Representation of the view.
		 * 
		 * @return A String Representation of the view.
		 */
		function toString():String;
	}
}
