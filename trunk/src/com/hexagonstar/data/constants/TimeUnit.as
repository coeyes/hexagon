/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.data.constants{	/**	 * Provides static constants for time measurement units.	 */	public class TimeUnit	{		////////////////////////////////////////////////////////////////////////////////////////		// Constants                                                                          //		////////////////////////////////////////////////////////////////////////////////////////				public static const MILLISECOND:Number				= 1;		public static const SECOND:Number					= MILLISECOND * 1000;		public static const MINUTE:Number					= SECOND * 60;		public static const HOUR:Number						= MINUTE * 60;		public static const DAY:Number						= HOUR * 24;		public static const WEEK:Number						= DAY * 7;		public static const YEAR:Number						= DAY * 365;				public static const SYMBOL_MILLISECOND:String		= "ms";		public static const SYMBOL_SECOND:String				= "s";		public static const SYMBOL_MINUTE:String				= "m";		public static const SYMBOL_HOUR:String				= "h";		public static const SYMBOL_DAY:String				= "d";		public static const SYMBOL_WEEK:String				= "w";		public static const SYMBOL_YEAR:String				= "y";				public static const SYMBOL_LONG_MILLISECOND:String	= "millisecond";		public static const SYMBOL_LONG_SECOND:String		= "second";		public static const SYMBOL_LONG_MINUTE:String		= "minute";		public static const SYMBOL_LONG_HOUR:String			= "hour";		public static const SYMBOL_LONG_DAY:String			= "day";		public static const SYMBOL_LONG_WEEK:String			= "week";		public static const SYMBOL_LONG_YEAR:String			= "year";	}}