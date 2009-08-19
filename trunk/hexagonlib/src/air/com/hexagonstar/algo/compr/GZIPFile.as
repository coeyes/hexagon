/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.algo.compr{	import flash.utils.ByteArray;		/**	 * GZIPFile Class	 */	public class GZIPFile	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				private var _gzipFileName:String;		private var _compressedData:ByteArray;		private var _headerFileName:String;		private var _headerComment:String;		private var _fileModificationTime:Date;		private var _originalFileSize:uint;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new GZIPFile instance.		 */		public function GZIPFile(compressedData:ByteArray, 									originalFileSize:uint, 									fileModificationTime:Date, 									gzipFileName:String="", 									headerFileName:String=null,									headerComment:String=null)		{			_compressedData = compressedData;			_originalFileSize = originalFileSize;			_fileModificationTime = fileModificationTime;			_gzipFileName = gzipFileName;			_headerFileName = headerFileName;			_headerComment = headerComment;		}						/**		 * Retrieves a copy of the compressed data bytes extracted from the GZIP file.		 * Modifications to the result ByteArray, including uncompressing, do not		 * alter the result of future calls to this method.		 * 		 * @returns	A copy of the compressed data bytes contained in the ByteArray.		 * 			Call the <code>ByteArray.inflate()</code> method on the result		 * 			for the uncompressed data.		 * 		 * @see flash.data.ByteArray#inflate()		 */		public function getCompressedData():ByteArray		{			var result:ByteArray = new ByteArray();			_compressedData.position = 0;			_compressedData.readBytes(result, 0, _compressedData.length);			return result;		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				public function get gzipFileName():String		{			return _gzipFileName;		}						public function get headerFileName():String		{			return _headerFileName;		}						public function get headerComment():String		{			return _headerComment;		}						public function get fileModificationTime():Date		{			return _fileModificationTime;		}						public function get originalFileSize():uint		{			return _originalFileSize;		}	}}