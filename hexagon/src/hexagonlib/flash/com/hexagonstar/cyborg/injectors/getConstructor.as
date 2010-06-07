/*
 * cyborg - ActionScript3 application framework based on robotlegs.
 * 
 *  ___   |_  __    __
 * |___\_||_|(__)|/|__|
 *      _|           _|
 *  
 * Licensed under the MIT License
 * 
 * Copyright (c) 2010 Hexagon Star Softworks
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
package com.hexagonstar.cyborg.injectors
{
	import flash.utils.Proxy;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	
	internal function getConstructor(v:Object):Class
	{
		/*
		 * There are several types for which the 'constructor' property doesn't work:
		 * - instances of Proxy, XML and XMLList throw exceptions when trying to access 'constructor'
		 * - int and uint return Number as their constructor
		 * For these, we have to fall back to more verbose ways of getting the constructor.
		 *
		 * Additionally, Vector instances always return Vector.<*> when queried for their constructor.
		 * Ideally, that would also be resolved, but the SwiftSuspenders wouldn't be compatible with
		 * Flash Player < 10, anymore.
		 * 
		 * TODO Add Vector support (since we only support FP10+ anyway)!
		 */
		if (v is Proxy || v is Number || v is XML || v is XMLList)
		{
			var fqcn:String = getQualifiedClassName(v);
			return Class(getDefinitionByName(fqcn));
		}
		return v.constructor as Class;
	}
}
