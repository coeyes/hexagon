/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.core{	import flash.utils.getQualifiedClassName;		/**	 * BasicClass can be used as the superclass for classes that do not extend other	 * classes and that should have a base set of common methods like the custom	 * toString method.	 * 	 * @author Sascha Balkau	 * @version 1.0.0	 */	public class BasicClass implements IBasicClass	{		////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Returns a string representation of the Class. Optionally a number of arguments		 * can be specified, typically class properties that are output together with the		 * class name to provide additional information about the class.<p>		 * 		 * @example		 * <pre>		 *    // overriden toString method to include a size property:		 *    override public function toString(...args):String		 *    {		 *        return super.toString("size=" + size);		 *    }		 * </pre>		 * 		 * @param args an optional, comma-delimited list of class properties that should be		 *            output together with the class name.		 * @return A string representation of the class.		 */		public function toString(...args):String		{			var s:String = "";			for each (var i:String in args) s += ", " + i;			return "[" + getQualifiedClassName(this).match("[^:]*$")[0] + s + "]";		}	}}