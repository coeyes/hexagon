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
package com.hexagonstar.framework.command.file
{
	import model.Locale;

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
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new LoadConfigCommand instance.
		 */
		public function LoadLocaleCommand()
		{
			super();
		}
		
		
		/**
		 * Execute the command.
		 */ 
		override public function execute():void
		{
			/* Initialize the locale model before we load any locale data */
			Locale.init();
			
			var path:String = Main.config.localePath + "/"
				+ Main.config.currentLocale + ".locale";
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
	}
}
