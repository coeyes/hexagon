/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.io.file.types{	import com.hexagonstar.data.types.Byte;	import com.hexagonstar.io.file.FileErrorStatus;	import flash.utils.ByteArray;		/**	 * Can be used to load XML-based files.	 * 	 * @author Sascha Balkau	 * @version 1.0.0	 */	public class XMLFile extends TextFile implements IFile	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				/** @private */		protected var _xml:XML;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new XMLFile instance.		 * 		 * @param path The path to the XML File.		 * @param id An optional file ID.		 */		public function XMLFile(path:String = "", id:String = null)		{			super(path, id);			_xml = new XML();		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * The XMLFile's content.		 */		override public function get content():*		{			return contentAsXML;		}		override public function set content(v:*):void		{			try			{				_xml = new XML(v);				_isValid = true;				_errorStatus = FileErrorStatus.OK;			}			catch (e:Error)			{				_isValid = false;				_errorStatus = e.toString();			}						if (_isValid) _size = new Byte(_xml.length());		}						/**		 * The XMLFile's content in typed form as ByteArray. The xml is		 * written into the resulting ByteArray as UTF bytes.		 */		override public function get contentAsBytes():ByteArray		{			var result:ByteArray = new ByteArray();			result.writeUTFBytes(_xml.toString());			result.position = 0;			return result;		}		override public function get contentAsString():String		{			return _xml.toString();		}						/**		 * The XMLFile's content in typed form as XML.		 */		public function get contentAsXML():XML		{			return _xml;		}						/**		 * The filetype ID of the file.		 * 		 * @see #FileTypeIndex		 */		override public function get fileTypeID():int		{			return FileTypeIndex.XML_FILE_ID;		}	}}