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
	import flash.display.DisplayObjectContainer;
	
	/**
	 * The ViewMap contract. All IViewMap automatic injections occur AFTER the
	 * view components are added to the stage.
	 */
	public interface IViewMap
	{
		/**
		 * Map an entire package (including sub-packages) for automatic injection
		 * 
		 * @param packageName The substring to compare
		 */		
		function mapPackage(packageName:String):void;
		
		
		/**
		 * Unmap a package
		 * 
		 * @param packageName The substring to compare
		 */		
		function unmapPackage(packageName:String):void;
		
		
		/**
		 * Check if a package has been registered for automatic injection
		 *
		 * @param packageName The substring to compare
		 * @return Whether a package has been registered for automatic injection
		 */
		function hasPackage(packageName:String):Boolean;
		
		
		/**
		 * Map a view component class or interface for automatic injection
		 *
		 * @param type The concrete view Interface
		 */
		function mapType(type:Class):void;
		
		
		/**
		 * Unmap a view component class or interface
		 *
		 * @param type The concrete view Interface
		 */
		function unmapType(type:Class):void;
		
		
		/**
		 * Check if a class or interface has been registered for automatic injection
		 *
		 * @param type The concrete view interface 
		 * @return Whether an interface has been registered for automatic injection
		 */
		function hasType(type:Class):Boolean;
		
		
		/**
		 * The <code>IViewMap</code>'s <code>DisplayObjectContainer</code>
		 *
		 * @return view The <code>DisplayObjectContainer</code> to use as scope
		 * for this <code>IViewMap</code>
		 */
		function get contextView():DisplayObjectContainer;
		
		
		/**
		 * The <code>IViewMap</code>'s <code>DisplayObjectContainer</code>
		 *
		 * @param v The <code>DisplayObjectContainer</code> to use as scope
		 * for this <code>IViewMap</code>
		 */
		function set contextView(v:DisplayObjectContainer):void;
		
		
		/**
		 * The <code>IViewMap</code>'s enabled status
		 *
		 * @return Whether the <code>IViewMap</code> is enabled
		 */
		function get enabled():Boolean;
		
		
		/**
		 * The <code>IViewMap</code>'s enabled status
		 *
		 * @param v Whether the <code>IViewMap</code> should be enabled
		 */
		function set enabled(v:Boolean):void;
	}
}
