/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.util{	import flash.text.Font;			/**	 * Provides utility methods for working with fonts.	 */	public class FontUtil	{		////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Returns an Array with the names of fonts that are installed on		 * the user's system.		 * 		 * @param includeDeviceFonts true if all fonts, incl. device fonts are		 *         included. If this is false only embedded fonts will be included.		 * @return An Array with installed font names.		 */		public static function getFontList(includeDeviceFonts:Boolean = true):Array		{			return Font.enumerateFonts(includeDeviceFonts);		}						/**		 * Checks if the specified fontName is available among the installed		 * fonts on the user's system.		 * 		 * @param fontName the font name to check for.		 * @return true if the font is available, otherwise false.		 */		public static function isFontAvailable(fontName:String,			includeDeviceFonts:Boolean = true):Boolean		{			var a:Array = FontUtil.getFontList(includeDeviceFonts);			for each (var f:Font in a)			{				if (f.fontName == fontName) return true;			}			return false;		}	}}