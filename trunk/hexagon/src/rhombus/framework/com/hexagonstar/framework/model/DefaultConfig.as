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
package com.hexagonstar.framework.model
{
	/**
	 * A data model that is used to store config properties loaded by ConfigLoader
	 * from the application config file (app.ini). This class must define all the
	 * properties matching the properties added to the config file!
	 * If a property was not defined or did not match, an error is sent by default
	 * to the debug console.<p>
	 * 
	 * Ideally every defined property should have a default value assigned in case
	 * the config file could not be loaded.
	 * 
	 * @author Sascha Balkau
	 */
	public class DefaultConfig
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Config Data                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/* Logging */
		public var loggingEnabled:Boolean;
		public var loggingFilterLevel:int;
		
		/* Console */
		public var consoleEnabled:Boolean;
		public var consoleAutoOpen:Boolean;
		public var consoleKey:String;
		public var consoleSize:int;
		public var consoleTransparency:Number;
		public var consoleFontSize:int;
		public var consoleMaxBufferSize:int;
		
		/* FPS Moniror */
		public var fpsMonitorEnabled:Boolean;
		public var fpsMonitorPollInterval:Number;
		public var fpsMonitorKey:String;
		
		/* Screen */
		public var useFullscreen:Boolean;
		
		/* IO */
		public var useAbsoluteFilePath:Boolean;
		public var preventFileCaching:Boolean;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * initializes the model data.
		 */
		public function init():void
		{
			loggingEnabled = true;
			loggingFilterLevel = 0;
			
			consoleEnabled = true;
			consoleAutoOpen = false;
			consoleKey = "F8";
			consoleSize = 2;
			consoleTransparency = 0.8;
			consoleFontSize = 11;
			consoleMaxBufferSize = 40000;
			
			fpsMonitorEnabled = true;
			fpsMonitorPollInterval = 0.5;
			fpsMonitorKey = "SHIFT+F8";
			
			useFullscreen = false;
			
			useAbsoluteFilePath = true;
			preventFileCaching = false;
		}
	}
}
