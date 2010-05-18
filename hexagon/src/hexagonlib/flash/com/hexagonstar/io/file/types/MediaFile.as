/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.io.file.types{	import com.hexagonstar.data.types.Byte;	import com.hexagonstar.exception.Exception;	import com.hexagonstar.io.file.FileErrorStatus;	import flash.display.Loader;	import flash.display.LoaderInfo;	import flash.utils.ByteArray;		/**	 * MediaFile class	 * 	 * @see #ImageFile	 * @see #SWFFile	 * @author Sascha Balkau	 * @version 1.0.0	 */	public class MediaFile extends AbstractFile implements IFile	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				/** @private */		protected var _container:Loader;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new MediaFile instance.		 * 		 * @param path The path where the file is located.		 * @param id An optional ID string for the file.		 */		public function MediaFile(path:String = "", id:String = null)		{			super(path, id);		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Sets the size of the Media file.		 */		override public function set size(v:Byte):void		{			_size = v;						/* for the MediaFile we set valid state here because it's content is loaded			 * via the Loader container and there is no way to set the content via "set			 * content". */			if (_size.byte > 0) _isValid = true;		}						/**		 * The content of the media file. The returned object is of type DisplayObject.		 */		override public function get content():*		{			if (_container) return _container.content;			return null;		}		public function set content(v:*):void		{			var bytes:ByteArray = new ByteArray();			bytes.writeObject(v);			bytes.position = 0;			contentAsBytes = bytes;		}						/**		 * The content of the media file as a ByteArray.		 */		public function get contentAsBytes():ByteArray		{			var result:ByteArray = new ByteArray();			result.writeObject(content);			result.position = 0;			return result;		}		public function set contentAsBytes(v:ByteArray):void		{			if (!_container) _container = new Loader();			try			{				_container.loadBytes(v);				_isValid = true;				_errorStatus = FileErrorStatus.OK;			}			catch (e:Exception)			{				_isValid = false;				_errorStatus = e.toString();				_container = null;			}						if (_isValid)			{				_size = new Byte(_container.contentLoaderInfo.bytesLoaded);			}		}						/**		 * The contentLoaderInfo of the Loader used in the MediaFile.		 */		public function get contentLoaderInfo():LoaderInfo		{			if (_container) return _container.contentLoaderInfo;			return null;		}						/**		 * The Loader used in the MediaFile.		 */		public function get container():Loader		{			if (!_container) _container = new Loader();			return _container;		}		public function set container(v:Loader):void		{			_container = v;		}						/**		 * The filetype ID of the file.		 * 		 * @see #FileTypeIndex		 */		public function get fileTypeID():int		{			return FileTypeIndex.MEDIA_FILE_ID;		}	}}