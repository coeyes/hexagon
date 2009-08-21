/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.util{	import flash.utils.ByteArray;		/**	 * ChecksumUtil Class	 */	public class ChecksumUtil	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				private static var _crcTable:Vector.<uint>;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a checksum table needed for CRC checksum generation.		 * 		 * @return Vector with uints.		 */		public static function createCRCTable():Vector.<uint>		{			_crcTable = new Vector.<uint>(256, true);			var val:uint;						for (var i:int = 0;i < 256; i++)			{				val = i;				for (var j:int = 0;j < 8; j++)				{					if ((val & 1) != 0)					{						val = 0xEDB88320 ^ (val >>> 1);					}					else					{						val >>>= 1;					}				}				_crcTable[i] = val;			}						return _crcTable;		}						/**		 * Generates a CRC32 checksum for the specified buffer.		 * 		 * @see http://www.w3.org/TR/PNG/#D-CRCAppendix		 * @param data 		 * @param start		 * @param len		 * @return CRC-32 checksum		 */		public static function generateCRC32(data:ByteArray,												  start:uint = 0,												  len:uint = 0):uint		{			if (!_crcTable)			{				createCRCTable();			}						if (start >= data.length) start = data.length;			if (len == 0) len = data.length - start;			if (len + start > data.length) len = data.length - start;						var c:uint = 0xFFFFFFFF;			for (var i:int = start; i < len; i++)			{				c = _crcTable[(c ^ data[i]) & 0xFF] ^ (c >>> 8);			}						return (c ^ 0xFFFFFFFF);		}						/**		 * Calculates an Adler-32 checksum over a ByteArray		 * 		 * @see http://en.wikipedia.org/wiki/Adler-32#Example_implementation		 * @param data 		 * @param start		 * @param len		 * @return Adler-32 checksum		 */				public static function generateAdler32(data:ByteArray,													start:uint = 0,													len:uint = 0):uint		{			if (start >= data.length) start = data.length;			if (len == 0) len = data.length - start;			if (len + start > data.length) len = data.length - start;						var i:int = start;			var a:uint = 1;			var b:uint = 0;						while (len) 			{				var tlen:uint = (len > 5550) ? 5550 : len;				len -= tlen;								do 				{					a += data[i++];					b += a;				}				while (--tlen);								a = (a & 0xFFFF) + (a >> 16) * 15;				b = (b & 0xFFFF) + (b >> 16) * 15;			}						if (a >= 65521) a -= 65521; 			b = (b & 0xFFFF) + (b >> 16) * 15;			if (b >= 65521) b -= 65521;						return (b << 16) | a;		}	}}