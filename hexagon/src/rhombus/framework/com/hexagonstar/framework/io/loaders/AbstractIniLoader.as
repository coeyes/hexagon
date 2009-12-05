/* * rhombus - Application framework for web/desktop-based Flash & Flex projects. *  *  /\ RHOMBUS *  \/ FRAMEWORK *  * Licensed under the MIT License * Copyright (c) 2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.framework.io.loaders{	import com.hexagonstar.event.FileIOEvent;	import com.hexagonstar.framework.io.parsers.IFileParser;	import com.hexagonstar.io.file.types.TextFile;	import flash.events.Event;		/**	 * Abstract class that is used for loaders that want to load ini-type text files.	 * An ini file is a file which consists of lines of key-value pairs. Every key	 * and it's value are divided by an equals character (=).<p>	 * Typical implementations for this are config and locale loaders.	 * 	 * @author Sascha Balkau	 * @version 1.0.0	 */	public class AbstractIniLoader extends AbstractLoader	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				/** @private */		protected var _file:TextFile;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new AbstractIniLoader instance.		 */		public function AbstractIniLoader(filePath:String, fileID:String = null)		{			super();			_file = new TextFile(filePath, fileID);		}						/**		 * Loads the application configuration file.		 * 		 */		override public function load():void		{			super.load();						_loader.addFile(_file);			_loader.load();		}						/**		 * Not used by ini loaders because they parse data on their own but we		 * put it here since ini loaders need to implement the Iloader interface.		 */		public function addParser(parser:IFileParser):void		{		}						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Initiates parsing of the loaded ini file into the model object.		 * @private		 */		override public function onComplete(e:FileIOEvent):void		{			super.onComplete(e);						if (e.file.isValid)			{				parse(TextFile(e.file));			}			else			{				notifyError("File invalid or not found <" + e.file.toString() + "> ("					+ e.file.errorStatus + ")");			}		}						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Parses text from a text-based ini file.		 * @private		 */		protected function parse(file:TextFile):void		{			var text:String = file.contentAsString;			var lines:Array = text.match(/^.+$/gm);			var key:String;			var val:String;						for each (var l:String in lines)			{				var firstChar:String = trim(l).substr(0, 1);								/* Ignore lines that are comments or headers */				if (firstChar != "#" && firstChar != "[")				{					var pos:int = l.indexOf("=");					key = trim(l.substring(0, pos));					val = trim(l.substring(pos + 1, l.length));					parseProperty(key, val);				}			}						dispatchEvent(new Event(Event.COMPLETE));		}						/**		 * @private		 */		protected function parseProperty(key:String, val:String):void		{			/* Abstract method! */		}	}}