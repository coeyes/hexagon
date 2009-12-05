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
package com.hexagonstar.framework.command.file
{
	import com.hexagonstar.framework.io.loaders.LocaleLoader;

	
	/**
	 * A command that is responsible for loading the default locale file. This command
	 * is automatically used by the application init command and does not need to be
	 * executed manually.
	 * 
	 * @see com.hexagonstar.framework.command.env.InitApplicationCommand
	 * @author Sascha Balkau
	 * @version 1.0.0
	 */
	public class LoadLocaleCommand extends AbstractLoadCommand
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/** @private */
		protected var _localeID:String;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new LoadConfigCommand instance.
		 * 
		 * @param localeID Optional locale ID String. If this is empty the loader
		 *         uses the defaultLocale property from the app config.
		 */
		public function LoadLocaleCommand(localeID:String = "")
		{
			_localeID = localeID;
			super();
		}
		
		
		/**
		 * Execute the command.
		 */ 
		override public function execute():void
		{
			/* Initialize the locale model before we load any locale data. */
			Main.locale.init();
			
			/* If no locale id was provided we use the default one. */
			if (_localeID == "")
			{
				_localeID = Main.config.currentLocale;
			}
			
			var path:String = Main.config.localePath + "/" + _localeID + ".locale";
			_loader = new LocaleLoader(path, "localeFile");
			
			super.execute();
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		override public function get name():String
		{
			return "loadLocale";
		}
		
		
		/**
		 * Locale ID with that the loader loaded the locale file.
		 */
		public function get localeID():String
		{
			return _localeID;
		}
	}
}
