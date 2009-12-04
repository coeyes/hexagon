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
package com.hexagonstar.framework.io.parsers
{
	import com.hexagonstar.io.file.types.IFile;
	import com.hexagonstar.io.file.types.XMLFile;

	
	/**
	 * ExampleDataFileParser Class
	 * 
	 * @author Sascha Balkau
	 * @version 1.0.0
	 */
	public class ExampleDataFileParser extends AbstractFileParser implements IFileParser
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new ExampleDataFileParser instance.
		 */
		public function ExampleDataFileParser()
		{
			super();
		}
		
		
		/**
		 * parse
		 */
		override public function parse(file:IFile):void
		{
			super.parse(file);
			
			var xml:XML = XMLFile(file).contentAsXML;
			
			for each (var x:XML in xml.entry)
			{
				/* Create a new object instance of the data model you're using for
				 * the parsed data and fill it in from the parsed xml here, e.g.:
				 * 
				 * var d:DataModel = new DataModel();
				 * d.id = x.@id;
				 * d.text = x;
				 * 
				 * After that add the data model object to a data container in the
				 * main data model:
				 * 
				 * _data.exampleDataModels.push(d);
				 */
			}
			
			complete();
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Returns the ID of the parser that is used to identify which loaded
		 * files should be parsed with which parser.
		 */
		override public function get id():String
		{
			return "example";
		}
	}
}
