/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.data.structures.lists{	import com.hexagonstar.data.structures.ICollection;			/**	 * IList Interface	 */	public interface IList extends ICollection	{		////////////////////////////////////////////////////////////////////////////////////////		// Query Operations                                                                   //		////////////////////////////////////////////////////////////////////////////////////////				function getElementAt(index:int):*;		function indexOf(element:*):int;		function join(separator:String = ""):String;						////////////////////////////////////////////////////////////////////////////////////////		// Modification Operations                                                            //		////////////////////////////////////////////////////////////////////////////////////////				function append(...elements):Boolean;		function prepend(...elements):Boolean;		function insert(index:int, element:*):Boolean;		function replace(index:int, element:*):*;		function removeByIndex(index:int):*;		function removeFirst():*;		function removeLast():*;						////////////////////////////////////////////////////////////////////////////////////////		// Bulk Operations                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				function insertAll(index:int, collection:ICollection):Boolean;		function replaceAll(index:int, collection:ICollection):Boolean;	}}