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
package com.hexagonstar.ui.controls
{
	import com.hexagonstar.ui.containers.BaseScrollPane;
	import com.hexagonstar.ui.controls.listclasses.CellRenderer;
	import com.hexagonstar.ui.controls.listclasses.ICellRenderer;
	import com.hexagonstar.ui.core.InvalidationType;
	import com.hexagonstar.ui.data.DataProvider;
	import com.hexagonstar.ui.data.SimpleCollectionItem;
	import com.hexagonstar.ui.events.DataChangeEvent;
	import com.hexagonstar.ui.events.DataChangeType;
	import com.hexagonstar.ui.events.ListEvent;
	import com.hexagonstar.ui.events.ScrollEvent;
	import com.hexagonstar.ui.managers.IFocusManagerComponent;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;

	/**
	 * Dispatched when the user rolls the pointer off of an item in the component.
	 * @eventType fl.events.ListEvent.ITEM_ROLL_OUT
	 */
	[Event(name="itemRollOut", type="fl.events.ListEvent")]

	/**
	 * Dispatched when the user rolls the pointer over an item in the component.
	 * @eventType fl.events.ListEvent.ITEM_ROLL_OVER
	 */
	[Event(name="itemRollOver", type="fl.events.ListEvent")]

	/**
	 * Dispatched when the user rolls the pointer over the component.
	 * @eventType flash.events.MouseEvent.ROLL_OVER
	 */
	[Event(name="rollOver", type="flash.events.MouseEvent")]

	/**
	 * Dispatched when the user rolls the pointer off of the component.
	 * @eventType flash.events.MouseEvent.ROLL_OUT
	 */
	[Event(name="rollOut", type="flash.events.MouseEvent")]

	/**
	 * Dispatched when the user clicks an item in the component. 
	 *
	 * <p>The <code>click</code> event is dispatched before the value
	 * of the component is changed. To identify the row and column that were clicked,
	 * use the properties of the event object; do not use the <code>selectedIndex</code> 
	 * and <code>selectedItem</code> properties.</p>
	 *
	 * @eventType fl.events.ListEvent.ITEM_CLICK
	 */
	[Event(name="itemClick", type="fl.events.ListEvent")]

	/**
	 * Dispatched when the user clicks an item in the component twice in
	 * rapid succession. Unlike the <code>click</code> event, the doubleClick event is 
	 * dispatched after the <code>selectedIndex</code> of the component is 
	 * changed.
	 *
	 * @eventType fl.events.ListEvent.ITEM_DOUBLE_CLICK
	 */
	[Event(name="itemDoubleClick", type="fl.events.ListEvent")]

	/**
	 * Dispatched when a different item is selected in the list.
	 * @eventType flash.events.Event.CHANGE
	 */
	[Event(name="change", type="flash.events.Event")]

	/**
	 * Dispatched when the user scrolls horizontally or vertically.
	 * @eventType fl.events.ScrollEvent.SCROLL
	 */
	[Event(name="scroll", type="fl.events.ScrollEvent")]
	
	
	[Style(name="skin", type="Class")]
	[Style(name="cellRenderer", type="Class")]
	[Style(name="disabledAlpha", type="Number")]
	[Style(name="contentPadding", type="Number", format="Length")]
	
	
	/**
	 * The SelectableList is the base class for all list-based components -- for example,
	 * the List, TileList, DataGrid, and ComboBox components. This class provides methods
	 * and properties that are used for the rendering and layout of rows, and to set scroll
	 * bar styles and data providers. 
	 *
	 * <p><strong>Note:</strong> This class does not create a component; it is exposed only
	 * so that it can be extended.</p>
	 * 
	 * @see fl.controls.DataGrid
	 * @see fl.controls.List 
	 * @see fl.controls.TileList
	 * @see fl.data.DataProvider
	 */
	public class SelectableList extends BaseScrollPane implements IFocusManagerComponent
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		protected var listHolder:Sprite;
		protected var list:Sprite;
		
		protected var _dataProvider:DataProvider;
		protected var activeCellRenderers:Array;
		protected var availableCellRenderers:Array;
		protected var _selectedIndices:Array;
		protected var preChangeItems:Array;
		protected var renderedItems:Dictionary;
		protected var invalidItems:Dictionary;
		
		protected var _horizontalScrollPosition:Number;
		protected var _verticalScrollPosition:Number;
		protected var caretIndex:int = -1;
		protected var lastCaretIndex:int = -1;
		
		protected var _allowMultipleSelection:Boolean = false;
		protected var _selectable:Boolean = true;
		
		protected var rendererStyles:Object;
		protected var updatedRendererStyles:Object;
		
		private var collectionItemImport:SimpleCollectionItem;
		
		private static var defaultStyles:Object =
		{
			skin:			"List_skin",
			cellRenderer:	CellRenderer,
			contentPadding:	null,
			disabledAlpha:	null
		};
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new SelectableList instance.
		 */
		public function SelectableList()
		{
			super();
			
			activeCellRenderers = [];
			availableCellRenderers = [];
			invalidItems = new Dictionary(true);
			renderedItems = new Dictionary(true);
			_selectedIndices = [];
			
			if (dataProvider == null) dataProvider = new DataProvider();
			
			verticalScrollPolicy = ScrollPolicy.AUTO;
			rendererStyles = {};
			updatedRendererStyles = {};
		}
		
		
		/**
		 * Clears the currently selected item in the list and sets the
		 * <code>selectedIndex</code> property to -1.
		 */
		public function clearSelection():void
		{
			selectedIndex = -1;
		}
		
		
		/** 
		 * Retrieves the ICellRenderer for a given item object, if there is one.
		 * This method always returns <code>null</code>.
		 *
		 * @param item The item in the data provider.
		 * @return A value of <code>null</code>.
		 */
		public function itemToCellRenderer(item:Object):ICellRenderer
		{
			if (item != null)
			{
				// TODO index should be typed as int?
				for (var index:* in activeCellRenderers)
				{
					var renderer:ICellRenderer = ICellRenderer(activeCellRenderers[index]);
					if (renderer.data == item) return renderer;
				}
			}
			return null;
		}
		
		
		/**
		 * Appends an item to the end of the list of items. 
		 *
		 * <p>An item should contain <code>label</code> and <code>data</code> 
		 * properties; however, items that contain other properties can also 
		 * be added to the list. By default, the <code>label</code> property of 
		 * an item is used to display the label of the row; the <code>data</code> 
		 * property is used to store the data of the row. </p>
		 * 
		 * @param item The item to be added to the data provider.
		 *
		 * @see #addItemAt()
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public function addItem(item:Object):void 
		{
			_dataProvider.addItem(item);
			invalidateList();
		}

		
		/**
		 * Inserts an item into the list at the specified index location. The indices of 
		 * items at or after the specified index location are incremented by 1.
		 *
		 * @param item The item to be added to the list.
		 *
		 * @param index The index at which to add the item.
		 *
		 * @throws RangeError The specified index is less than 0 or greater than or equal to the length of the data provider.
		 *
		 * @see #addItem()
		 * @see #replaceItemAt()
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public function addItemAt(item:Object,index:uint):void 
		{
			_dataProvider.addItemAt(item, index);
			invalidateList();
		}

		
		/**
		 * Removes all items from the list. 
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public function removeAll():void 
		{
			_dataProvider.removeAll();
		}

		
		/**
		 * Retrieves the item at the specified index.
		 * 
		 * @param index The index of the item to be retrieved.
		 *
		 * @return The object at the specified index location.
		 *
		 * @throws RangeError The specified index is less than 0 or greater than or equal to the length of the data provider.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public function getItemAt(index:uint):Object 
		{
			return _dataProvider.getItemAt(index);
		}

		
		/**
		 * Removes the specified item from the list. 
		 *
		 * @param item The item to be removed.
		 *
		 * @return The item that was removed.
		 *
		 * @throws RangeError The item could not be found.
		 *
		 * @see #removeAll()
		 * @see #removeItemAt()
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */		 
		public function removeItem(item:Object):Object 
		{
			return _dataProvider.removeItem(item);
		}

		
		/**
		 * Removes the item at the specified index position. The indices of 
		 * items after the specified index location are decremented by 1.
		 *
		 * @param index The index of the item in the data provider to be removed.
		 *
		 * @return The item that was removed.
		 *
		 * @see #removeAll()
		 * @see #removeItem()
		 * @see #replaceItemAt()
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public function removeItemAt(index:uint):Object 
		{
			return _dataProvider.removeItemAt(index);
		}

		
		// V2 has order of arguments backwards.
		/**
		 * Replaces the item at the specified index location with another item. 
		 * This method modifies the data provider of the List component. If 
		 * the data provider is shared with other components, the data that is
		 * provided to those components is also updated.
		 *
		 * @param item The item to replace the item at the specified index location.
		 *
		 * @param index The index position of the item to be replaced.
		 *
		 * @return The item that was replaced.
		 *
		 * @throws RangeError The specified index is less than 0 or greater than or equal to the length of the data provider.
		 *
		 * @see #removeItemAt()
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public function replaceItemAt(item:Object, index:uint):Object 
		{
			return _dataProvider.replaceItemAt(item, index);
		}

		
		/**
		 * Invalidates the whole list, forcing the list items to be redrawn.
		 *
		 * @see #invalidateItem()
		 * @see #invalidateItemAt()
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public function invalidateList():void 
		{
			_invalidateList();
			invalidate(InvalidationType.DATA);
		}

		
		/**
		 * Invalidates a specific item renderer.
		 *
		 * @param item The item in the data provider to invalidate.
		 *
		 * @see #invalidateItemAt()
		 * @see #invalidateList()
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 *
		 * @internal [kenos] This doesn't make sense. It says the method invalidates an item renderer,
		 *                   but the param description for item says that it receives "the data provider to invalidate."
		 *                   Isn't the item renderer distinct from the item? There is a similar problem in the next method.
		 */
		public function invalidateItem(item:Object):void 
		{
			if (renderedItems[item] == null) 
			{ 
				return; 
			}
			invalidItems[item] = true;
			invalidate(InvalidationType.DATA);
		}

		
		/**
		 * Invalidates the renderer for the item at the specified index.
		 *
		 * @param index The index of the item in the data provider to invalidate.
		 *
		 * @see #invalidateItem()
		 * @see #invalidateList()
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 *
		 * @internal [kenos] This method appears to invalid an item, but it is described as
		 *                   invalidating an item renderer. What is correct?
		 */
		public function invalidateItemAt(index:uint):void 
		{
			var item:Object = _dataProvider.getItemAt(index);
			if (item != null) 
			{
				invalidateItem(item);
			}
		}

		
		/**
		 * Sorts the elements of the current data provider. This method 
		 * performs a sort based on the Unicode values of the elements. ASCII is a 
		 * subset of Unicode.
		 * 
		 * @param sortArgs The arguments against which to sort.
		 *
		 * @return The return value depends on whether any parameters are passed to 
		 *         this method. For more information, see the <code>Array.sort()</code> method. 
		 *         Note that this method returns 0 when the <code>sortArgs</code> parameter 
		 *         is set to <code>Array.UNIQUESORT</code>.
		 *
		 * @see #sortItemsOn()
		 * @see Array#sort()
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public function sortItems(...sortArgs:Array):* 
		{
			return _dataProvider.sort.apply(_dataProvider, sortArgs);
		}

		
		/**
		 * Sorts the elements of the current data provider by one or more  
		 * of its fields.
		 * 
		 * @param field The field on which to sort.
		 * @param options Sort arguments that are used to override the default sort behavior. 
		 *                Separate two or more arguments with the bitwise OR (|) operator.
		 *
		 * @return The return value depends on whether any parameters are passed to this
		 *         method. For more information, see the <code>Array.sortOn()</code> method. 
		 *         Note that this method returns 0 when the <code>sortOption</code> parameter  
		 *         is set to <code>Array.UNIQUESORT</code>.
		 *
		 * @includeExample examples/SelectableList.sortItemsOn.1.as -noswf
		 *
		 * @see #sortItems()
		 * @see fl.data.DataProvider#sortOn() DataProvider.sortOn()
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public function sortItemsOn(field:String,options:Object = null):* 
		{
			return _dataProvider.sortOn(field, options);
		}

		
		/**
		 * Checks whether the specified item is selected in the list. 
		 *
		 * @param item The item to check.
		 *
		 * @return This method returns <code>true</code> if the specified item is selected; 
		 *         otherwise, if the specified item has a value of <code>null</code> or is not
		 *         included in the list, this method returns <code>false</code>.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public function isItemSelected(item:Object):Boolean 
		{
			return selectedItems.indexOf(item) > -1;
		}

		
		/**
		 * Scrolls the list to the item at the location indicated by    
		 * the current value of the <code>selectedIndex</code> property.
		 *
		 * @see #selectedIndex
		 * @see #scrollToIndex()
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public function scrollToSelected():void 
		{
			scrollToIndex(selectedIndex);
		}

		
		/**
		 * Scrolls the list to the item at the specified index. If the index 
		 * is out of range, the scroll position does not change.
		 *
		 * @param newCaretIndex The index location to scroll to.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public function scrollToIndex(newCaretIndex:int):void 
		{
			// Handle in subclasses.	
		}		

		
		/**
		 * Returns the index of the next item in the dataProvider in which
		 * the label's first character matches a specified string character.
		 * If the search reaches the end of the dataProvider without searching
		 * all the items, it will loop back to the start.  The search does not
		 * include the startIndex.
		 * 
		 * @param firstLetter The string character to search for
		 * @param startIndex The index in the dataProvider to start at.
		 *
		 * @return The index of the next item in the dataProvider.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public function getNextIndexAtLetter(firstLetter:String, startIndex:int = -1):int 
		{
			if (length == 0) 
			{ 
				return -1; 
			}
			firstLetter = firstLetter.toUpperCase();
			var l:int = length - 1;
			for (var i:Number = 0;i < l; i++) 
			{
				var index:Number = startIndex + 1 + i;
				if (index > length - 1) 
				{
					index -= length;
				}
				var item:Object = getItemAt(index);
				if (item == null) 
				{ 
					break; 
				}
				var label:String = itemToLabel(item);
				if (label == null) 
				{ 
					continue; 
				}
				if (label.charAt(0).toUpperCase() == firstLetter) 
				{
					return index;
					break;
				}
			}
			return -1;
		}

		
		/**
		 * @private
		 */
		/**
		 * Retrieves the string that the renderer displays for the given data object 
		 * based on the <code>label</code> properties of the object.  This method
		 * is intended to be overwritten in sub-components.  For example, List has
		 * a <code>labelField</code> and a <code>labelFunction</code> to derive the
		 * label.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public function itemToLabel(item:Object):String 
		{
			return item["label"]; // Use bracket access in case object has no property.
		}		

		
		/**
		 * Sets a style on the renderers in the list.
		 *
		 * @param name The name of the style to be set.
		 * @param style The value of the style to be set.
		 *
		 * @includeExample examples/SelectableList.setRendererStyle.1.as -noswf
		 * @includeExample examples/SelectableList.setRendererStyle.2.as -noswf
		 * @includeExample examples/SelectableList.setRendererStyle.3.as -noswf
		 * @includeExample examples/SelectableList.setRendererStyle.4.as -noswf
		 *
		 * @see #clearRendererStyle()
		 * @see #getRendererStyle()
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public function setRendererStyle(name:String, style:Object, column:uint = 0):void 
		{
			if (rendererStyles[name] == style) 
			{ 
				return; 
			}
			updatedRendererStyles[name] = style;
			rendererStyles[name] = style;
			invalidate(InvalidationType.RENDERER_STYLES);
		}

		
		/**
		 * Retrieves a style that is set on the renderers in the list.
		 *
		 * @param name The name of the style to be retrieved.
		 * @param style The value of the style to be retrieved.
		 *
		 * @see #clearRendererStyle()
		 * @see #setRendererStyle()
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public function getRendererStyle(name:String, column:int = -1):Object 
		{
			return rendererStyles[name];	
		}

		
		/**
		 * Clears a style that is set on the renderers in the list.
		 *
		 * @param name The name of the style to be cleared.
		 *
		 * @see #getRendererStyle()
		 * @see #setRendererStyle()
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public function clearRendererStyle(name:String, column:int = -1):void 
		{
			delete rendererStyles[name];
			updatedRendererStyles[name] = null; // Do not delete, so it can clear the style from current renderers.
			invalidate(InvalidationType.RENDERER_STYLES);
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		
		public static function get styleDefinition():Object
		{
			return mergeStyles(defaultStyles, BaseScrollPane.styleDefinition);
		}
		
		
		/**
		 * @private
		 */
		[Inspectable(defaultValue=true, verbose=1)]
		override public function set enabled(v:Boolean):void
		{
			super.enabled = v;
			list.mouseChildren = _isEnabled;
		}
		
		
		/**
		 * Gets or sets the data model of the list of items to be viewed. A data provider 
		 * can be shared by multiple list-based components. Changes to the data provider 
		 * are immediately available to all components that use it as a data source.
		 * 
		 * @default null
		 */
		public function get dataProvider():DataProvider
		{
			/* return the original data source */
			return _dataProvider;
		}
		[Collection(collectionClass="fl.data.DataProvider", collectionItem="fl.data.SimpleCollectionItem", identifier="item")]
		public function set dataProvider(v:DataProvider):void
		{
			if (_dataProvider != null)
			{
				_dataProvider.removeEventListener(DataChangeEvent.DATA_CHANGE, handleDataChange);
				_dataProvider.removeEventListener(DataChangeEvent.PRE_DATA_CHANGE, onPreChange);
			}
			
			_dataProvider = v;
			_dataProvider.addEventListener(DataChangeEvent.DATA_CHANGE, handleDataChange, false, 0, true);
			_dataProvider.addEventListener(DataChangeEvent.PRE_DATA_CHANGE, onPreChange, false, 0, true);
			clearSelection();
			invalidateList();
		}
		
		
		/**
		 * Gets or sets the number of pixels that the list scrolls to the right when the
		 * <code>horizontalScrollPolicy</code> property is set to <code>ScrollPolicy.ON</code>.
		 *
		 * @see fl.containers.BaseScrollPane#horizontalScrollPosition
		 * @see fl.containers.BaseScrollPane#maxVerticalScrollPosition
		 */
		override public function get maxHorizontalScrollPosition():Number
		{
			return _maxHScrollPosition;
		}
		public function set maxHorizontalScrollPosition(v:Number):void
		{
			_maxHScrollPosition = v;
			invalidate(InvalidationType.SIZE);
		}
		
		
		/**
		 * Gets the number of items in the data provider.
		 */
		public function get length():uint
		{
			return _dataProvider.length;
		}
		
		
		/**
		 * Gets a Boolean value that indicates whether more than one list item 
		 * can be selected at a time. A value of <code>true</code> indicates that 
		 * multiple selections can be made at one time; a value of <code>false</code> 
		 * indicates that only one item can be selected at one time. 
		 *
		 * @default false
		 * @see #selectable
		 */		
		[Inspectable(defaultValue=false)]
		public function get allowMultipleSelection():Boolean
		{
			return _allowMultipleSelection;
		}
		public function set allowMultipleSelection(v:Boolean):void
		{
			if (v == _allowMultipleSelection) return; 
			
			_allowMultipleSelection = v;
			
			if (!v && _selectedIndices.length > 1)
			{
				_selectedIndices = [_selectedIndices.pop()];
				invalidate(InvalidationType.DATA);
			}
		}
		
		
		/**
		 * Gets or sets a Boolean value that indicates whether the items in the list 
		 * can be selected. A value of <code>true</code> indicates that the list items
		 * can be selected; a value of <code>false</code> indicates that they cannot be. 
		 * 
		 * @default true
		 * @see #allowMultipleSelection
		 */
		public function get selectable():Boolean
		{
			return _selectable;
		}
		public function set selectable(v:Boolean):void
		{
			if (v == _selectable) return; 
			if (!v) selectedIndices = []; 
			_selectable = v;
		}
		
		
		/**
		 * Gets or sets the index of the item that is selected in a single-selection
		 * list. A single-selection list is a list in which only one item can be selected 
		 * at a time. 
		 *
		 * <p>A value of -1 indicates that no item is selected; if multiple selections
		 * are made, this value is equal to the index of the item that was selected last in
		 * the group of selected items.</p>
		 *
		 * <p>When ActionScript is used to set this property, the item at the specified index
		 * replaces the current selection. When the selection is changed programmatically, 
		 * a <code>change</code> event object is not dispatched. </p>
		 *
		 * @see #selectedIndices
		 * @see #selectedItem
		 */
		public function get selectedIndex():int
		{
			return (_selectedIndices.length == 0)
				? -1
				: _selectedIndices[_selectedIndices.length - 1];
		}
		public function set selectedIndex(v:int):void
		{
			selectedIndices = (v == -1) ? null : [v];
		}
		
		
		/**
		 * Gets or sets an array that contains the items that were selected from
		 * a multiple-selection list. 
		 *
		 * <p>To replace the current selection programmatically, you can make an 
		 * explicit assignment to this property. You can clear the current selection 
		 * by setting this property to an empty array or to a value of <code>undefined</code>. 
		 * If no items are selected from the list of items, this property is 
		 * <code>undefined</code>. </p>
		 *
		 * <p>The sequence of values in the array reflects the order in which the items
		 * were selected from the multiple-selection list. For example, if you click the second 
		 * item from the list, then the third item, and finally the first item, this property 
		 * contains an array of values in the following sequence: <code>[1,2,0]</code>.</p>
		 *
		 * @see #allowMultipleSelection
		 * @see #selectedIndex
		 * @see #selectedItems
		 */
		public function get selectedIndices():Array
		{
			return _selectedIndices.concat();
		}
		public function set selectedIndices(v:Array):void
		{
			if (!_selectable) return; 
			_selectedIndices = (v == null) ? [] : v.concat();
			invalidate(InvalidationType.SELECTED);
		}
		
		
		/**
		 * Gets or sets the item that was selected from a single-selection list. For a 
		 * multiple-selection list in which multiple items are selected, this property
		 * contains the item that was selected last. 
		 * <p>If no selection is made, the value of this property is <code>null</code>.</p>
		 *
		 * @see #selectedIndex
		 * @see #selectedItems
		 */
		public function get selectedItem():Object
		{
			return (_selectedIndices.length == 0)
				? null
				: _dataProvider.getItemAt(selectedIndex);
		}
		public function set selectedItem(v:Object):void
		{
			var index:int = _dataProvider.getItemIndex(v);
			selectedIndex = index;
		}
		
		
		/**
		 * Gets or sets an array that contains the objects for the  
		 * items that were selected from the multiple-selection list. 
		 *
		 * <p>For a single-selection list, the value of this property is an 
		 * array containing the one selected item. In a single-selection 
		 * list, the <code>allowMultipleSelection</code> property is set to 
		 * <code>false</code>.</p>
		 *
		 * @see #allowMultipleSelection
		 * @see #selectedIndices
		 * @see #selectedItem
		 */
		public function get selectedItems():Array
		{
			var items:Array = [];
			for (var i:int = 0; i < _selectedIndices.length; i++)
			{
				items.push(_dataProvider.getItemAt(_selectedIndices[i]));
			}
			return items;
		}
		public function set selectedItems(v:Array):void
		{
			if (v == null)
			{
				selectedIndices = null;
				return;
			}
			
			var indices:Array = [];
			for (var i:uint = 0;i < v.length; i++)
			{
				var index:int = _dataProvider.getItemIndex(v[i]);
				if (index != -1) indices.push(index);
			}
			selectedIndices = indices;
		}
		
		
		/**
		 * Gets the number of rows that are at least partially visible in the list.
		 * <p><strong>Note:</strong> This property must be overridden in any class
		 * that extends SelectableList.</p>
		 * 
		 * @default 0
		 */
		public function get rowCount():uint
		{
			return 0;
		}
		
		

		
		/**
		 * @private (protected)
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		override protected function configUI():void 
		{
			super.configUI();
			
			listHolder = new Sprite();
			addChild(listHolder);
			listHolder.scrollRect = _contentScrollRect;
			
			list = new Sprite();
			listHolder.addChild(list);
		}

		
		/**
		 * @private (protected)
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		protected function _invalidateList():void 
		{
			availableCellRenderers = [];
			while (activeCellRenderers.length > 0) 
			{
				list.removeChild(activeCellRenderers.pop() as DisplayObject);
			}
		}

		
		/**
		 * @private (protected)
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		protected function handleDataChange(event:DataChangeEvent):void 
		{
			var startIndex:int = event.startIndex;
			var endIndex:int = event.endIndex;
			var changeType:String = event.changeType;
			var i:uint;
			if (changeType == DataChangeType.INVALIDATE_ALL) 
			{
				clearSelection();
				invalidateList();
			} else if (changeType == DataChangeType.INVALIDATE) 
			{
				for (i = 0;i < event.items.length; i++) 
				{
					invalidateItem(event.items[i]);
				}
			} else if (changeType == DataChangeType.ADD) 
			{
				for (i = 0;i < _selectedIndices.length; i++) 
				{
					if (_selectedIndices[i] >= startIndex) 
					{
						_selectedIndices[i] += startIndex - endIndex;
					}
				}
			} else if (changeType == DataChangeType.REMOVE) 
			{
				for (i = 0;i < _selectedIndices.length; i++) 
				{
					if (_selectedIndices[i] >= startIndex) 
					{
						if (_selectedIndices[i] <= endIndex) 
						{
							delete(_selectedIndices[i]);
						} 
						else 
						{
							_selectedIndices[i] -= startIndex - endIndex + 1;
						}
					}
				}
			} else if (changeType == DataChangeType.REMOVE_ALL) 
			{
				clearSelection();
			} else if (changeType == DataChangeType.REPLACE) {
				// doesn't need to do anything.
			} 
			else 
			{
				// Using preChangeItems to remember selection
				//clearSelection();
				selectedItems = preChangeItems;
				preChangeItems = null;
			}
			invalidate(InvalidationType.DATA);
		}
		
		
		/**
		 * @private
		 */
		protected function handleCellRendererMouseEvent(e:MouseEvent):void
		{
			var renderer:ICellRenderer = ICellRenderer(e.target);
			var type:String = (e.type == MouseEvent.ROLL_OVER)
				? ListEvent.ITEM_ROLL_OVER
				: ListEvent.ITEM_ROLL_OUT;
			dispatchEvent(new ListEvent(type, false, false, renderer.listData.column,
				renderer.listData.row, renderer.listData.index, renderer.data));
		}
		
		
		/**
		 * @private
		 */
		protected function handleCellRendererClick(e:MouseEvent):void
		{
			if (!_isEnabled) return; 
			
			var renderer:ICellRenderer = e.currentTarget as ICellRenderer;
			var itemIndex:uint = renderer.listData.index;
			
			// this event is cancellable:
			if (!dispatchEvent(new ListEvent(ListEvent.ITEM_CLICK, false, true,
				renderer.listData.column, renderer.listData.row, itemIndex, renderer.data))
				|| !_selectable)
			{
				return;
			}
			
			var selectIndex:int = selectedIndices.indexOf(itemIndex);
			var i:int;
			
			if (!_allowMultipleSelection) 
			{
				if (selectIndex != -1) 
				{
					return;
				} 
				else 
				{
					renderer.selected = true;
					_selectedIndices = [itemIndex];
				}
				lastCaretIndex = caretIndex = itemIndex;
			} 
			else 
			{
				if (e.shiftKey) 
				{
					var oldIndex:uint = (_selectedIndices.length > 0)
					? _selectedIndices[0]
					: itemIndex;
					
					_selectedIndices = [];
					
					if (oldIndex > itemIndex) 
					{
						for (i = oldIndex;i >= itemIndex; i--) 
						{
							_selectedIndices.push(i);
						}
					} 
					else 
					{
						for (i = oldIndex;i <= itemIndex; i++) 
						{
							_selectedIndices.push(i);
						}
					}
					caretIndex = itemIndex;
				} else if (e.ctrlKey) 
				{
					if (selectIndex != -1) 
					{
						renderer.selected = false;
						_selectedIndices.splice(selectIndex, 1);
					} 
					else 
					{
						renderer.selected = true;
						_selectedIndices.push(itemIndex);
					}
					caretIndex = itemIndex;
				} 
				else 
				{
					_selectedIndices = [itemIndex];
					lastCaretIndex = caretIndex = itemIndex;
				}
			}
			dispatchEvent(new Event(Event.CHANGE));
			invalidate(InvalidationType.DATA);
		}

		
		/**
		 * @private (protected)
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		protected function handleCellRendererChange(event:Event):void 
		{
			var renderer:ICellRenderer = event.currentTarget as ICellRenderer;
			var itemIndex:uint = renderer.listData.index;
			_dataProvider.invalidateItemAt(itemIndex);
		}

		
		/**
		 * @private (protected)
		 */
		protected function handleCellRendererDoubleClick(event:MouseEvent):void 
		{
			if (!_isEnabled) return; 
			
			var renderer:ICellRenderer = event.currentTarget as ICellRenderer;
			var itemIndex:uint = renderer.listData.index;
			dispatchEvent(new ListEvent(ListEvent.ITEM_DOUBLE_CLICK, false, true, renderer.listData.column, renderer.listData.row, itemIndex, renderer.data));
		}

		
		/**
		 * @private (protected)
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		override protected function setHorizontalScrollPosition(scroll:Number,fireEvent:Boolean = false):void 
		{
			if (scroll == _horizontalScrollPosition) 
			{ 
				return; 
			}
			var delta:Number = scroll - _horizontalScrollPosition;
			_horizontalScrollPosition = scroll;
			if (fireEvent) 
			{
				dispatchEvent(new ScrollEvent(ScrollBarDirection.HORIZONTAL, delta, scroll));
			}
		}

		
		/**
		 * @private (protected)
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		override protected function setVerticalScrollPosition(scroll:Number,fireEvent:Boolean = false):void 
		{
			if (scroll == _verticalScrollPosition) 
			{ 
				return; 
			}
			var delta:Number = scroll - _verticalScrollPosition;
			_verticalScrollPosition = scroll;
			if (fireEvent) 
			{
				dispatchEvent(new ScrollEvent(ScrollBarDirection.VERTICAL, delta, scroll));
			}
		}

		
		/**
		 * @private (protected)
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		override protected function draw():void 
		{
			// this method is overridden in List implementations.
			super.draw();
		}

		
		/**
		 * @private (protected)
		 */
		override protected function drawLayout():void 
		{
			super.drawLayout();
			
			_contentScrollRect = listHolder.scrollRect;
			_contentScrollRect.width = _availableWidth;
			_contentScrollRect.height = _availableHeight;
			listHolder.scrollRect = _contentScrollRect;
		}
		
		
		/**
		 * @private (protected)
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		protected function updateRendererStyles():void 
		{
			var renderers:Array = availableCellRenderers.concat(activeCellRenderers);
			var l:uint = renderers.length;
			for (var i:uint = 0;i < l; i++) 
			{
				if (renderers[i].setStyle == null) 
				{ 
					continue; 
				}
				for (var n:String in updatedRendererStyles) 
				{
					renderers[i].setStyle(n, updatedRendererStyles[n]);
				}
				renderers[i].drawNow();
			}
			updatedRendererStyles = {};
		}

		
		/**
		 * @private (protected)
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		protected function drawList():void 
		{
			// this method is overridden in List implementations.
		}

		
		/**
		 * @private (protected)
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		override protected function onKeyFocusDown(event:KeyboardEvent):void 
		{
			if (!selectable) 
			{ 
				return; 
			}
			
			switch (event.keyCode) 
			{
				case Keyboard.UP:
				case Keyboard.DOWN:
				case Keyboard.END:
				case Keyboard.HOME:
				case Keyboard.PAGE_UP:
				case Keyboard.PAGE_DOWN:
					moveSelectionVertically(event.keyCode, event.shiftKey && _allowMultipleSelection, event.ctrlKey && _allowMultipleSelection);
					event.stopPropagation();
					break;
				case Keyboard.LEFT:
				case Keyboard.RIGHT:
					moveSelectionHorizontally(event.keyCode, event.shiftKey && _allowMultipleSelection, event.ctrlKey && _allowMultipleSelection);
					event.stopPropagation();
					break;
			}
		}

		
		/**
		 * @private (protected)
		 *  Moves the selection in a horizontal direction in response
		 *  to the user selecting items using the left-arrow or right-arrow
		 *  keys and modifiers such as  the Shift and Ctrl keys.
		 *
		 *  <p>Not implemented in List because the default list
		 *  is single column and therefore doesn't scroll horizontally.</p>
		 *
		 *  @param code The key that was pressed (e.g. Keyboard.LEFT)
		 *
		 *  @param shiftKey <code>true</code> if the shift key was held down when
		 *         the keyboard key was pressed.
		 *
		 *  @param ctrlKey <code>true</code> if the ctrl key was held down when
		 *         the keyboard key was pressed
		 *
		 */
		protected function moveSelectionHorizontally(code:uint, shiftKey:Boolean, ctrlKey:Boolean):void 
		{
		}

		
		/**
		 * @private (protected)
		 *  Moves the selection in a vertical direction in response
		 *  to the user selecting items using the up-arrow or down-arrow
		 *  Keys and modifiers such as the Shift and Ctrl keys.
		 *
		 *  @param code The key that was pressed (e.g. Keyboard.DOWN)
		 *
		 *  @param shiftKey <code>true</code> if the shift key was held down when
		 *         the keyboard key was pressed.
		 *
		 *  @param ctrlKey <code>true</code> if the ctrl key was held down when
		 *         the keyboard key was pressed
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		protected function moveSelectionVertically(code:uint, shiftKey:Boolean, ctrlKey:Boolean):void 
		{
		}

		
		/**
		 * @private (protected)
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		protected function onPreChange(event:DataChangeEvent):void 
		{
			switch (event.changeType) 
			{
				case DataChangeType.REMOVE:
				case DataChangeType.ADD:
				case DataChangeType.INVALIDATE:
				case DataChangeType.REMOVE_ALL:
				case DataChangeType.REPLACE:
				case DataChangeType.INVALIDATE_ALL:
					break;
				default:
					preChangeItems = selectedItems;	
					break;
			}
		}
	}
}
