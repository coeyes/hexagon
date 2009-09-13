/*
 * hexagonlib - Multi-Purpose ActionScript 3 Library.
 *       __    __
 *    __/  \__/  \__    __
 *   /  \__/HEXAGON \__/  \
 *   \__/  \__/  LIBRARY _/
 *            \__/  \__/
 *
 * Licensed under the MIT License
 * 
 * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks
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
package com.hexagonstar.ui.data 
{

	
	/**
	 * The SimpleCollectionItem class defines a single item in an inspectable
	 * property that represents a data provider. A SimpleCollectionItem object
	 * is a collection list item that contains only <code>label</code> and
	 * <code>data</code> properties--for example, a ComboBox or List component.
	 *
	 * @internal Is this revised description correct?
	 * Adobe: [LM} Yes, its ok.
	 *
	 * @includeExample examples/SimpleCollectionItemExample.as
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	dynamic public class SimpleCollectionItem 
	{

		[Inspectable()]
		/**
		 * The <code>label</code> property of the object.
		 *
		 * The default value is <code>label(<em>n</em>)</code>, where <em>n</em> is the ordinal index.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public var label:String;

		[Inspectable()]
		/**
		 * The <code>data</code> property of the object.
		 *
		 * @default null
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public var data:String;

		
		/**
		 * Creates a new SimpleCollectionItem object.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public function SimpleCollectionItem() 
		{
		}	

		
		/**
		 * @private
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public function toString():String 
		{
			return "[SimpleCollectionItem: " + label + "," + data + "]";	
		}
	}	
}
