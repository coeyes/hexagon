/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.io.file.types{	import com.hexagonstar.data.types.Byte;	import com.hexagonstar.io.file.FileErrorStatus;		import flash.utils.ByteArray;			/**	 * BinaryFile class	 */	public class BinaryFile extends AbstractFile implements IFile	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				private var _content:ByteArray;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new BinaryFile instance.		 * 		 * @param path The path of the Binary File.		 */		public function BinaryFile(path:String = "")		{			super(path);			_content = new ByteArray();		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				override public function get content():*		{			return contentAsBinary;		}						public function set content(v:*):void		{			contentAsBinary = (v as ByteArray);		}						public function get contentAsBinary():ByteArray		{			_content.position = 0;			return _content;		}						public function set contentAsBinary(v:ByteArray):void		{			try			{				_content = new ByteArray();				_content.writeBytes(v);				_content.position = 0;				_isValid = true;				_errorStatus = FileErrorStatus.OK;			}			catch (e:Error)			{				_isValid = false;				_errorStatus = e.toString();			}						if (_isValid) _size = new Byte(_content.length);		}						public function get fileTypeID():int		{			return FileTypeIndex.BINARY_FILE_ID;		}	}}