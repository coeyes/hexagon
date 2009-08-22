/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.io.file.types{	import com.hexagonstar.data.types.Byte;	import com.hexagonstar.io.file.FileErrorStatus;	import flash.display.Loader;	import flash.display.LoaderInfo;	import flash.utils.ByteArray;		/**	 * MediaFile class	 */	public class MediaFile extends AbstractFile implements IFile	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				protected var _container:Loader;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new MediaFile instance.		 */		public function MediaFile(path:String = "", id:String = null)		{			super(path, id);			_container = new Loader();		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				override public function set size(v:Byte):void		{			_size = v;						/* for the MediaFile we set valid state here because it's content is loaded			 * via the Loader container and there is no way to set the content via "set			 * content". */			if (_size.bytes > 0) _isValid = true;		}				override public function get content():*		{			return _container.content;		}						public function set content(v:*):void		{			var bytes:ByteArray = new ByteArray();			bytes.writeObject(v);			bytes.position = 0;			contentAsBytes = bytes;		}						public function get contentAsBytes():ByteArray		{			var result:ByteArray = new ByteArray();			result.writeObject(content);			result.position = 0;			return result;		}						public function set contentAsBytes(v:ByteArray):void		{			try			{				_container.loadBytes(v);				_isValid = true;				_errorStatus = FileErrorStatus.OK;			}			catch (e:Error)			{				_isValid = false;				_errorStatus = e.toString();			}						if (_isValid) _size = new Byte(_container.contentLoaderInfo.bytesLoaded);		}						public function get contentLoaderInfo():LoaderInfo		{			return _container.contentLoaderInfo;		}						public function get container():Loader		{			return _container;		}						public function set container(v:Loader):void		{			_container = v;		}						public function get fileTypeID():int		{			return FileTypeIndex.MEDIA_FILE_ID;		}	}}