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
package com.hexagonstar.framework.io.loaders
{
	import com.hexagonstar.data.structures.IIterator;
	import com.hexagonstar.data.structures.queues.Queue;
	import com.hexagonstar.event.FileIOEvent;
	import com.hexagonstar.framework.io.parsers.IFileParser;
	import com.hexagonstar.io.file.types.IFile;
	import com.hexagonstar.io.file.types.XMLFile;

	import flash.events.Event;
	import flash.utils.Dictionary;

	
	/**
	 * Can be used to load a set of XML data files that are parsed into data model objects
	 * by use of a specific data file parser. You provide the path to an index XML file
	 * which contains entries with a parserID and a path to any of the files that are
	 * being loaded and parsed.
	 * 
	 * @author Sascha Balkau
	 * @version 1.0.0
	 */
	public class DataFileLoader extends AbstractLoader implements ILoader
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/** @private */
		protected var _indexFilePath:String;
		/** @private */
		protected var _indexFileID:String;
		/** @private */
		protected var _indexFile:XMLFile;
		/** @private */
		protected var _files:Queue;
		/** @private */
		protected var _parsers:Dictionary;
		/** @private */
		protected var _parser:IFileParser;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new instance of the class.
		 * 
		 * @param indexFilePath The path to the index file that is used to load
		 *         data files with this loader.
		 * @param indexFileID An optional ID used to identify the index file. It is
		 *         not necessary to change this unless the index file should be
		 *         accessed outside the data file loader.
		 */
		public function DataFileLoader(indexFilePath:String,
										   indexFileID:String = "indexFile")
		{
			_indexFilePath = indexFilePath;
			_indexFileID = indexFileID;
			_parsers = new Dictionary();
			
			super();
		}
		
		
		/**
		 * Before using the data file loader, parsers need to be added to it for
		 * every data file type that its going to load. The ID of the parser
		 * must equal the ID for the file used in the index file.
		 */
		public function addParser(parser:IFileParser):void
		{
			_parsers[parser.id] = parser;
		}
		
		
		/**
		 * Loads the data files.
		 */
		override public function load():void
		{
			super.load();
			
			/* Load the data index file which contains IDs and paths to all data files */
			_indexFile = new XMLFile(_indexFilePath, _indexFileID);
			_loader.addFile(_indexFile);
			_loader.load();
		}
		
		
		/**
		 * Returns a String Representation of DataLoader.
		 * @return A String Representation of DataLoader.
		 */
		override public function toString():String
		{
			return "[DataFileLoader]";
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Event Handlers                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Called everytime after a file load has been completed.
		 * @private
		 */
		override public function onFileComplete(e:FileIOEvent):void
		{
			super.onFileComplete(e);
		}
		
		
		/**
		 * Called after all file loads have been completed. this method gets
		 * called twice since we are loading the data file index and the queue
		 * with data files with the same loader.
		 * @private
		 */
		override public function onComplete(e:FileIOEvent):void
		{
			super.onComplete(e);
			
			if (e.file.id == _indexFileID)
			{
				createDataFiles(e.file);
			}
			else
			{
				parseDataFiles();
			}
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a queue with all data files after the data file index
		 * has been loaded.
		 * @private
		 */
		protected function createDataFiles(file:IFile):void
		{
			if (file.isValid && file is XMLFile)
			{
				var xml:XML = XMLFile(file).contentAsXML;
				_files = new Queue();
				
				for each (var x:XML in xml.file)
				{
					var id:String = x.@parserID;
					var path:String = x.@path;
					var dataFile:XMLFile = new XMLFile(path, id);
					_files.enqueue(dataFile);
				}
				
				loadDataFiles();
			}
			else
			{
				notifyError("XML structure of <" + file.path + "> is invalid. ("
					+ file.errorStatus + ").");
			}
		}
		
		
		/**
		 * loadDataFiles
		 * @private
		 */
		protected function loadDataFiles():void
		{
			if (_files.size > 0)
			{
				_loader.fileQueue = _files;
				_loader.load();
			}
			else
			{
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		
		/**
		 * Parses the data of all loaded data files into their respective
		 * data models using the correct data file parser.
		 * @private
		 */
		protected function parseDataFiles():void
		{
			var i:IIterator = _files.iterator();
			while (i.hasNext)
			{
				var file:XMLFile = i.next;
				_parser = _parsers[file.id];
				
				if (_parser)
				{
					_parser.parse(file);
				}
				else
				{
					notifyError("Parsing error: no file parser with the ID [" + file.id
						+ "] was added to the loader.");
				}
			}
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}
