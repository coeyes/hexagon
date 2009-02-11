/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.flex.controls{	import mx.collections.ListCollectionView;	import mx.controls.ComboBox;	import mx.core.UIComponent;		import flash.events.Event;	import flash.events.FocusEvent;	import flash.events.KeyboardEvent;	import flash.net.SharedObject;	import flash.ui.Keyboard;			/**	 * Dispatched when the <code>filterFunction</code> property changes.	 * You can listen for this event and update the component	 * when the <code>filterFunction</code> property changes.</p>	 * @eventType flash.events.Event	 */	[Event(name="filterFunctionChange", type="flash.events.Event")]		/**	 * Dispatched when the <code>typedText</code> property changes.	 * You can listen for this event and update the component	 * when the <code>typedText</code> property changes.</p>	 * @eventType flash.events.Event	 */	[Event(name="typedTextChange", type="flash.events.Event")]			[Exclude(name="editable", kind="property")]			/**	 * AutoCompleteInput Class	 */	public class AutoCompleteInput extends ComboBox	{		////////////////////////////////////////////////////////////////////////////////////////		// Constants                                                                          //		////////////////////////////////////////////////////////////////////////////////////////				public static const FILTERFUNCTION_CHANGE:String = "filterFunctionChange";		public static const TYPEDTEXT_CHANGE:String = "typedTextChange";						////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				protected var _tempCollection:Object;		protected var _typedText:String = "";		protected var _filterFunction:Function = defaultFilterFunction;		protected var _cursorPos:int = 0;		protected var _prevIndex:int = -1;				protected var _isRemoveHighlight:Boolean = false;		protected var _isShowDropdown:Boolean = false;		protected var _isShowingDropdown:Boolean = false;		protected var _isUsingLocalHistory:Boolean = false;		protected var _isDropdownClosed:Boolean = true;				protected var _isFilterFunctionChanged:Boolean = true;		protected var _isKeepLocalHistoryChanged:Boolean = true;		protected var _keepLocalHistory:Boolean = false;		protected var _lookAhead:Boolean = false;		protected var _isLookAheadChanged:Boolean;		protected var _isTypedTextChanged:Boolean;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new AutoCompleteInput instance.		 */		public function AutoCompleteInput()		{		    super();					    /* Make ComboBox look like a normal text field */		    editable = true;		    if (keepLocalHistory) addEventListener("focusOut", focusOutHandler);		    setStyle("arrowButtonWidth", 0);			setStyle("fontWeight", "normal");			setStyle("cornerRadius", 0);			setStyle("paddingLeft", 0);			setStyle("paddingRight", 0);			rowCount = 7;		}						/**		 * @private		 */		override public function getStyle(styleProp:String):*		{			if (styleProp != "openDuration")			{				return super.getStyle(styleProp);			}			else			{		     	if (_isDropdownClosed) return super.getStyle(styleProp);		 		else return 0;			}		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				/**		 *  @private		 */	 	override public function set editable(v:Boolean):void		{		    /* This is done to prevent user from resetting the value to false */		    super.editable = true;		}				/**		 * @private		 */	 	override public function set dataProvider(v:Object):void		{			super.dataProvider = v;			if (!_isUsingLocalHistory) _tempCollection = v;		}						/**		 *  @private		 */	 	override public function set labelField(v:String):void		{			super.labelField = v;			invalidateProperties();			invalidateDisplayList();		}						[Bindable("filterFunctionChange")]		[Inspectable(category="General")]		/**		 * A function that is used to select items that match the		 * function's criteria. 		 * A filterFunction is expected to have the following signature:		 *		 * <pre>f(item:~~, text:String):Boolean</pre>		 *		 * where the return value is <code>true</code> if the specified item		 * should displayed as a suggestion. 		 * Whenever there is a change in text in the AutoComplete control, this 		 * filterFunction is run on each item in the <code>dataProvider</code>.		 *  		 * <p>The default implementation for filterFunction works as follows:<br>		 * If "AB" has been typed, it will display all the items matching 		 * "AB~~" (ABaa, ABcc, abAc etc.).</p>		 *		 * <p>An example usage of a customized filterFunction is when text typed		 * is a regular expression and we want to display all the		 * items which come in the set.</p>		 *		 * @example		 * <pre>		 * public function myFilterFunction(item:~~, text:String):Boolean		 * {		 *    public var regExp:RegExp = new RegExp(text,"");		 *    return regExp.test(item);		 * }		 * </pre>		 */		public function get filterFunction():Function		{			return _filterFunction;		}				/**		 * @private		 */		public function set filterFunction(v:Function):void		{			/* An empty filterFunction is allowed but not a null filterFunction */			if (v != null)			{				_filterFunction = v;				_isFilterFunctionChanged = true;								invalidateProperties();				invalidateDisplayList();								dispatchEvent(new Event(FILTERFUNCTION_CHANGE));			}			else			{				_filterFunction = defaultFilterFunction;			}		}						[Bindable("keepLocalHistoryChange")]		[Inspectable(category="General")]		/**		 * When true, this causes the control to keep track of the entries that are		 * typed into the control, and saves the history as a local shared object.		 * When true, the completionFunction and dataProvider are ignored.		 */		public function get keepLocalHistory():Boolean		{			return _keepLocalHistory;		}				/**		 * @private		 */		public function set keepLocalHistory(v:Boolean):void		{			_keepLocalHistory = v;		}						[Bindable("lookAheadChange")]		[Inspectable(category="Data")]		/**		 * lookAhead decides whether to auto complete the text in the text field		 * with the first item in the drop down list or not. 		 */		public function get lookAhead():Boolean		{			return _lookAhead;		}				/**		 * @private		 */		public function set lookAhead(v:Boolean):void		{			_lookAhead = v;			_isLookAheadChanged = true;		}						[Bindable("typedTextChange")]		[Inspectable(category="Data")]		/**		 * A String to keep track of the text changed as a result of user interaction.		 */		public function get typedText():String		{		    return _typedText;		}				/**		 * @private		 */		public function set typedText(v:String):void		{		    _typedText = v;		    _isTypedTextChanged = true;					    invalidateProperties();			invalidateDisplayList();			dispatchEvent(new Event(TYPEDTEXT_CHANGE));		}						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @private		 */		override protected function focusOutHandler(e:FocusEvent):void		{			super.focusOutHandler(e);			if (keepLocalHistory && dataProvider.length == 0) addToLocalHistory();		}						/**		 * @private		 */		override protected function keyDownHandler(e:KeyboardEvent):void		{		    super.keyDownHandler(e);					    if (!e.ctrlKey)			{			    //An UP "keydown" event on the top-most item in the drop-down			    //or an ESCAPE "keydown" event should change the text in text			    // field to original text			    if (e.keyCode == Keyboard.UP && _prevIndex == 0)				{		 		    textInput.text = _typedText;				    textInput.setSelection(textInput.text.length, textInput.text.length);				    selectedIndex = -1; 				}			    else if (e.keyCode == Keyboard.ESCAPE && _isShowingDropdown)				{		 		    textInput.text = _typedText;				    textInput.setSelection(textInput.text.length, textInput.text.length);				    _isShowingDropdown = false;				    _isDropdownClosed = true;				}				else if (e.keyCode == Keyboard.ENTER)				{					if (keepLocalHistory && dataProvider.length == 0)						addToLocalHistory();				}				else if (lookAhead && e.keyCode ==  Keyboard.BACKSPACE					|| e.keyCode == Keyboard.DELETE)				{				    _isRemoveHighlight = true;				}		 	}		 	else		 	{			    if (e.ctrlKey && e.keyCode == Keyboard.UP) _isDropdownClosed = true;		 	}		 			    _prevIndex = selectedIndex;		}						/**		 * @private		 */		override protected function textInput_changeHandler(e:Event):void		{		    super.textInput_changeHandler(e);		    /* Stores the text typed by the user in a variable */		    typedText = text;		}						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 *  @private		 */		override protected function commitProperties():void		{		    super.commitProperties();					    if (!dropdown) selectedIndex = -1;		    if (dropdown)			{			    if (_isTypedTextChanged)			    {				    _cursorPos = textInput.selectionBeginIndex;					updateDataProvider();						    /* In case there are no suggestions there is no need to show the dropdown */				    if (collection.length == 0 || typedText == ""|| typedText == null)				    {				    	_isDropdownClosed = true;				    	_isShowDropdown = false;				    }					else					{						_isShowDropdown = true;						selectedIndex = 0;			    	}			    }			}		}						/**		 * @private		 */		override protected function measure():void		{			super.measure();			measuredWidth = UIComponent.DEFAULT_MEASURED_WIDTH;		}						/**		 * @private		 */		override protected function updateDisplayList(unscaledWidth:Number,			unscaledHeight:Number):void		{			super.updateDisplayList(unscaledWidth, unscaledHeight);						// An UP "keydown" event on the top-most item in the drop 			// down list otherwise changes the text in the text field to ""			if (selectedIndex == -1) textInput.text = typedText;						if (dropdown)			{				if (_isTypedTextChanged)				{					// This is needed because a call to super.updateDisplayList() set the text					// in the textInput to "" and thus the value typed by the user losts					if (lookAhead && _isShowDropdown && typedText != "" && !_isRemoveHighlight)					{						var label:String = itemToLabel(collection[0]);						var index:Number = label.toLowerCase().indexOf(_typedText.toLowerCase());												if (index == 0)						{							textInput.text = _typedText + label.substr(_typedText.length);							textInput.setSelection(textInput.text.length, _typedText.length);						}						else						{							textInput.text = _typedText;							textInput.setSelection(_cursorPos, _cursorPos);							_isRemoveHighlight = false;						}					}					else					{						textInput.text = _typedText;						textInput.setSelection(_cursorPos, _cursorPos);						_isRemoveHighlight = false;					}					_isTypedTextChanged= false;				}				else if (typedText)				{					// Sets the selection when user navigates the suggestion list through					// arrows keys.					textInput.setSelection(_typedText.length, textInput.text.length);				}			}						if (_isShowDropdown && !dropdown.visible)			{				// This is needed to control the open duration of the dropdown				super.open();				_isShowDropdown = false;				_isShowingDropdown = true;				if (_isDropdownClosed) _isDropdownClosed = false;			}		}						/**		 * If keepLocalHistory is enabled, stores the text typed 		 * by the user in the local history on the client machine		 * @private		 */		protected function addToLocalHistory():void		{			if (id != null && id != "" && text != null && text != "")			{				var so:SharedObject = SharedObject.getLocal("AutoCompleteData");				var savedData:Array = so.data["suggestions"];								/* No shared object has been created so far */				if (savedData == null) savedData = [];								var i:int = 0;				var flag:Boolean = false;								/* Check if this entry is there in the previously saved shared object data */				for (i = 0; i < savedData.length; i++)				{					if (savedData[i] == text)					{						flag = true;						break;					}				}								if (!flag)				{					/* Also ensure it is not there in the dataProvider */					for (i = 0; i < collection.length; i++)					{						if (defaultFilterFunction(itemToLabel(							(collection as ListCollectionView).getItemAt(i)),text))						{							flag = true;							break;						}					}				}								if (!flag) savedData.push(text);								/* write the shared object in the .sol file */				so.data["suggestions"] = savedData;				so.flush();			}		}						/**		 * @private		 */		protected function defaultFilterFunction(element:*, text:String):Boolean		{			var label:String = itemToLabel(element);			return (label.toLowerCase().substring(0,text.length) == text.toLowerCase());		}						/**		 * @private		 */		protected function templateFilterFunction(element:*):Boolean		{			var flag:Boolean = false;			if (filterFunction != null) flag = this["filterFunction"](element, typedText);			return flag;		}						/**		 * Updates the dataProvider used for showing suggestions		 * @private		 */		protected function updateDataProvider():void		{			dataProvider = _tempCollection;			collection.filterFunction = templateFilterFunction;			collection.refresh();					/* In case there are no suggestions, check there is something in the localHistory */			if (collection.length == 0 && keepLocalHistory)			{				var so:SharedObject = SharedObject.getLocal("AutoCompleteData");				_isUsingLocalHistory = true;				dataProvider = so.data["suggestions"];				_isUsingLocalHistory = false;				collection.filterFunction = templateFilterFunction;				collection.refresh();			}		}	}}