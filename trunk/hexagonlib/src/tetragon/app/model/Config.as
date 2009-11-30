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
 */
package model
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
	public class Config
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Config Data                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////
		
		public var loggingEnabled:Boolean;
		public var loggingFilterLevel:int;
		
		public var consoleEnabled:Boolean;
		public var consoleAutoOpen:Boolean;
		public var consoleKey:String;
		public var consoleTransparency:Number;
		public var consoleFontSize:int;
		public var consoleMaxBufferSize:int;
		
		public var fpsMonitorEnabled:Boolean;
		public var fpsMonitorPollInterval:Number;
		public var fpsMonitorKey:String;
		
		public var localePath:String;
		public var defaultLocale:String;
		public var currentLocale:String;
		
		public var dataIndexFile:String;
		
		/* AIR app only settings */
		public var autoCheckForUpdates:Boolean;
		public var updateURL:String;
		public var useFullscreen:Boolean;
		
		
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
			consoleTransparency = 0.8;
			consoleFontSize = 11;
			consoleMaxBufferSize = 40000;
			
			fpsMonitorEnabled = true;
			fpsMonitorPollInterval = 0.5;
			fpsMonitorKey = "F9";
			
			localePath = "locale";
			defaultLocale = Locale.ENGLISH;
			currentLocale = defaultLocale;
			
			dataIndexFile = "data/datafiles.xml";
			
			autoCheckForUpdates = true;
			updateURL = "";
			
			useFullscreen = false;
		}
	}
}
