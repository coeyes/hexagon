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
package com.hexagonstar.ui.events 
{

	
	/**
	 * The DataChangeType class defines constants for the <code>DataChangeEvent.changeType</code>
	 * event. These constants are used by the DataChangeEvent class to identify the type
	 * of change that was applied to the data in a list-based component such as a List, ComboBox,
	 * TileList, or DataGrid.
	 *
	 * @see DataChangeEvent#changeType
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	public class DataChangeType 
	{
		/**
		 * A change was made to the component data. This value does not affect the
		 * component data that it describes.
		 *
		 * @eventType change
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public static const CHANGE:String = "change";
		/**
		 * A change was made to the data contained in an item.
		 *
		 * @eventType invalidate
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public static const INVALIDATE:String = "invalidate";
		/**
		 * The data set is invalid.
		 *
		 * @eventType invalidateAll
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public static const INVALIDATE_ALL:String = "invalidateAll";
		/**
		 * Items were added to the data provider.
		 *
		 * @eventType add
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 * @internal The word "model" was replaced with "data provider" above. What should it say?
		 * @internal If this indicates "one or more" items were added, we should use that string.
		 */
		public static const ADD:String = "add";
		/**
		 * Items were removed from the data provider.
		 *
		 * @eventType remove
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 * @internal The word "model" was replaced with "data provider" above. What should it say?
		 * @internal If this indicates "one or more" items were removed, we should use that string.
		 */
		public static const REMOVE:String = "remove";
		/**
		 * All items were removed from the data provider.
		 *
		 * @eventType removeAll
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 * @internal The word "model" was replaced with "data provider" above. What should it say?
		 */
		public static const REMOVE_ALL:String = "removeAll";
		/**
		 * The items in the data provider were replaced by new items.
		 *
		 * @eventType replace
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 * @internal I used "data provider" here instead of the word "model". Correct?
		 */
		public static const REPLACE:String = "replace";
		/**
		 * The data provider was sorted. This constant is used to indicate
		 * a change in the order of the data, not a change in
		 * the data itself.
		 *
		 * @eventType sort
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 * @internal The word "model" was replaced with "data provider" above. What should it say?
		 */
		public static const SORT:String = "sort";
	}
}
