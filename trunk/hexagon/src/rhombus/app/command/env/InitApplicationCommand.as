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
package command.env
{
	import com.hexagonstar.framework.command.file.LoadConfigCommand;
	import com.hexagonstar.framework.command.file.LoadLocaleCommand;
	import com.hexagonstar.pattern.cmd.CompositeCommand;

	
	/**
	 * This composite command is used to execute the initialization of the application.
	 * The following tasks are taken care of by this command in order:
	 * 1. Load App Config
	 * 2. Load Locale
	 * 3. Init KeyManager
	 * 
	 * @author Sascha Balkau
	 * @version 1.0.0
	 */
	public class InitApplicationCommand extends CompositeCommand
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new InitApplicationCommand instance.
		 */
		public function InitApplicationCommand()
		{
			super();
		}
		
		
		/**
		 * Execute the application initialization command.
		 */ 
		override public function execute():void
		{
			/* Ignore whitespace on all XML data files. */
			XML.ignoreWhitespace = true;
			
			/* Initlialize main data model before anything is loaded. */
			Main.data.init();
			
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
			return "appInit";
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		override protected function enqueueCommands():void
		{
			enqueue(new LoadConfigCommand(), "Config file loading complete.");
			enqueue(new LoadLocaleCommand(), "Locale loading complete.");
			enqueue(new InitKeyManagerCommand(), "KeyManager initialization complete.");
		}
	}
}
