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
package command.file
{
	import com.hexagonstar.framework.command.file.AbstractLoadCommand;
	import com.hexagonstar.framework.io.loaders.DataFileLoader;
	import com.hexagonstar.framework.io.parsers.NullDataFileParser;

	
	/**
	 * @author Sascha Balkau
	 * @version 1.0.0
	 */
	public class LoadDataCommand extends AbstractLoadCommand
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new LoadDataCommand instance.
		 */
		public function LoadDataCommand()
		{
			super();
		}
		
		
		/**
		 * Execute the command.
		 */ 
		override public function execute():void
		{
			/* Initlialize main data model before anything is loaded. */
			Main.data.init();
			
			_loader = new DataFileLoader(Main.config.dataIndexFile);
			_loader.addParser(new NullDataFileParser());
			
			super.execute();
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		
		override public function get name():String
		{
			return "loadData";
		}
	}
}
