/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.io.file.loaders{	import com.hexagonstar.data.types.Byte;	import com.hexagonstar.exception.FileNotLoadedException;	import com.hexagonstar.io.file.types.IFile;	import com.hexagonstar.io.file.types.MediaFile;	import flash.display.Loader;	import flash.events.Event;		/**	 * MediaFileTypeLoader is an implementation of FileTypeLoader for media resources.	 * 	 * @author Sascha Balkau	 * @version 1.0.0	 */	public class MediaFileTypeLoader extends AbstractFileTypeLoader		implements IFileTypeLoader	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				/** @private */		protected var _loader:Loader;				////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new MediaFileTypeLoader instance.		 */		public function MediaFileTypeLoader(file:IFile)		{			super(file);		}						/**		 * Loads a media file.		 *		 * @param path location of the file to load.		 */		override public function load(filePath:String):void		{			super.load(filePath);			_loader = MediaFile(_file).container;			addEventListeners(_loader.contentLoaderInfo);			_loader.load(_urlRequest);		}						/**		 * Aborts the file loading process.		 */		public function abort():void		{			if (_loading)			{				try				{					_loader.close();				}				catch (e:Error)				{				}				removeEventListeners(_loader.contentLoaderInfo);				_aborted = true;			}		}						/**		 * Cleans up Objects used by the FileReader.		 */		override public function dispose():void		{			super.dispose();						if (_loader)			{				removeEventListeners(_loader.contentLoaderInfo);				_loader = null;			}		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Returns the total amount of bytes that have been loaded.		 * 		 * @return amount of bytes that have been loaded.		 */		override public function get bytesLoaded():Byte		{			return new Byte(_loader.contentLoaderInfo.bytesLoaded);		}						/**		 * Returns the total amount of bytes that will approximately be loaded.		 * 		 * @return amount of bytes to load.		 */		override public function get bytesTotal():Byte		{			return new Byte(_loader.contentLoaderInfo.bytesTotal);		}						/**		 * Returns the content of the loaded file.		 * 		 * @return the loaded resource.		 * @throws FileNotLoadedException if the resource has not been loaded yet.		 */		override public function get fileContent():*		{			if (_loader.content == null)			{				throw new FileNotLoadedException("No File has been loaded yet.");			}			return _loader.content;		}						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * onComplete Event Handler is called after a file finished loading.		 * @private		 */		override protected function onFileComplete(e:Event):void		{			_file.size = bytesLoaded;			super.onFileComplete(e);		}	}}