/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.io.file.loaders{	import com.hexagonstar.data.types.Byte;	import com.hexagonstar.env.exception.FileNotLoadedException;	import com.hexagonstar.io.file.types.IFile;	import flash.events.Event;	import flash.net.URLLoader;	import flash.net.URLLoaderDataFormat;		/**	 * BinaryFileLoader is an implementation of FileLoader for binary resources.	 */	public class BinaryFileLoader extends AbstractFileTypeLoader implements IFileTypeLoader	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				protected var _urlLoader:URLLoader;		protected var _dataFormat:String;				////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new BinaryFileLoader instance.		 */		public function BinaryFileLoader(file:IFile)		{			super(file);			_dataFormat = URLLoaderDataFormat.BINARY;		}						/**		 * Loads a binary file.		 *		 * @param filePath location of the file to load.		 */		override public function load(filePath:String):void		{			super.load(filePath);			_urlLoader = new URLLoader();			_urlLoader.dataFormat = _dataFormat;			addEventListeners(_urlLoader);			_urlLoader.load(_urlRequest);		}						/**		 * Aborts the file loading process.		 */		public function abort():void		{			if (_isLoading)			{				_urlLoader.close();				removeEventListeners(_urlLoader);				_isAborted = true;			}		}						/**		 * Cleans up Objects used by the FileReader.		 */		override public function dispose():void		{			super.dispose();			_urlLoader = null;		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Returns the total amount of bytes that have been loaded.		 * 		 * @return amount of bytes that have been loaded.		 */		override public function get bytesLoaded():Byte		{			return new Byte(_urlLoader.bytesLoaded);		}						/**		 * Returns the total amount of bytes that will approximately be loaded.		 * 		 * @return amount of bytes to load.		 */		override public function get bytesTotal():Byte		{			return new Byte(_urlLoader.bytesTotal);		}						/**		 * Returns the content of the loaded file.		 * 		 * @return the loaded resource.		 * @throws FileNotLoadedException if the resource has not been loaded yet.		 */		override public function get fileContent():*		{			if (_urlLoader.data == null)			{				throw new FileNotLoadedException("No File has been loaded yet.");			}			return _urlLoader.data;		}						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * onComplete Event Handler is called after a file finished loading.		 * @private		 */		override protected function onFileComplete(e:Event):void		{			_file.content = fileContent;			_file.size = bytesLoaded;			super.onFileComplete(e);		}	}}