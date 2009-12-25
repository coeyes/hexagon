/*
 * rhombus - Application framework for web/desktop-based Flash & Flex projects.
 * 
 *  /\ RHOMBUS
 *  \/ FRAMEWORK
 * 
 * Licensed under the MIT License
 * Copyright (c) 2008 Sascha Balkau / Hexagon Star Softworks
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
package com.hexagonstar.framework.view.display 
{
	import com.hexagonstar.framework.view.IView;

	
	/**
	 * IDisplay is the base interface for all display classes.
	 * 
	 * @author Sascha Balkau
	 * @version 0.9.5
	 */
	public interface IDisplay extends IView
	{
		
		/**
		 * Can be used to start the display, if this is a requirement of the display. E.g. a
		 * display may contain animated display children that should not start playing right
		 * after the display was opened but after the start method was called.
		 */
		function start():void;
		
		
		/**
		 * Can be used to stop the display after it has been started by calling start().
		 */
		function stop():void;
		
		
		/**
		 * Used to put the display into it's initial default state as it was right after the
		 * display has been instantiated for the first time. This method should be used the
		 * reset properties in case the play can be re-used wiothout the need to be
		 * re-created.
		 */
		function reset():void;
		
		
		/**
		 * Determines if the display is enabled or disabled. On a disabled display any
		 * display children are disabled so that no user interaction may take place until
		 * the display is enabled again. Set this property to either true (enabled) or false
		 * (disabled).
		 */
		function set enabled(v:Boolean):void;
		function get enabled():Boolean;
		
		
		/**
		 * Determines if the display is paused or not. If paused any child display objects
		 * need to be paused too. This property should be used if the display needs to be
		 * pausable, for example if it contains any animation that should not run while the
		 * application is in a paused state.
		 */
		function get paused():Boolean;
		function set paused(v:Boolean):void;
	}
}
