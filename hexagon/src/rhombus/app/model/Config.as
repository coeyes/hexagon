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
package model
{
	import com.hexagonstar.framework.model.DefaultConfig;

	
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
	public class Config extends DefaultConfig
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Config Data                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/* AIR app only settings */
		public var updateEnabled:Boolean;
		public var updateURL:String;
		public var updateAutoCheck:Boolean;
		public var updateCheckInterval:Number;
		public var updateCheckVisible:Boolean;
		public var updateDownloadProgressVisible:Boolean;
		public var updateDownloadUpdateVisible:Boolean;
		public var updateFileUpdateVisible:Boolean;
		
		public var localePath:String;
		public var defaultLocale:String;
		public var currentLocale:String;
		
		public var dataIndexFile:String;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Initializes the model data. Be sure to call super.init first!
		 */
		override public function init():void
		{
			super.init();
			
			updateEnabled = false;
			updateURL = "";
			updateAutoCheck = true;
			updateCheckInterval = 1;
			updateCheckVisible = false;
			updateDownloadProgressVisible = true;
			updateDownloadUpdateVisible = true;
			updateFileUpdateVisible = true;
			
			localePath = "locale";
			defaultLocale = Locale.ENGLISH;
			currentLocale = defaultLocale;
			
			dataIndexFile = "data/dataindex.xml";
		}
	}
}
