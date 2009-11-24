/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.display.ui.managers{	import com.hexagonstar.display.ui.controls.Button;	import com.hexagonstar.display.ui.core.UIComponent;	import flash.display.DisplayObject;	import flash.display.DisplayObjectContainer;	import flash.display.InteractiveObject;	import flash.display.SimpleButton;	import flash.display.Stage;	import flash.events.Event;	import flash.events.FocusEvent;	import flash.events.KeyboardEvent;	import flash.events.MouseEvent;	import flash.text.TextField;	import flash.text.TextFieldType;	import flash.ui.Keyboard;	import flash.utils.Dictionary;		/**	 * The FocusManager class manages focus for a set of components that are navigated	 * by mouse or keyboard as a <em>tab loop</em>.	 *	 * <p>A tab loop is typically navigated by using the Tab key; focus moves between	 * the components in the tab loop in a circular pattern from the first component	 * that has focus, to the last, and then back again to the first. A tab loop includes	 * all the components and tab-enabled components in a container. An application can	 * contain numerous tab loops.</p>	 *  	 * <p>A FocusManager instance is responsible for a single tab loop; an application uses	 * a different FocusManager instance to manage each tab loop that it contains, although	 * a main application is always associated with at least one FocusManager instance. An	 * application may require additional FocusManager instances if it includes a popup window,	 * for example, that separately contains one or more tab loops of components.</p>	 * 	 * <p>All components that can be managed by a FocusManager instance must implement the	 * IFocusManagerComponent interface. Objects for which Flash Player manages focus are	 * not required to implement the IFocusManagerComponent interface.</p>	 *	 * <p>The FocusManager class also manages how the default button is implemented. A	 * default button dispatches a <code>click</code> event when the Enter key is pressed	 * on a form, depending on where focus is at the time.  The default button does not	 * dispatch the <code>click</code> event if a text area has focus or if a value is	 * being edited in a component, for example, in a ComboBox or NumericStepper component.</p>	 * 	 * @see IFocusManager	 * @see IFocusManagerComponent	 */	public class FocusManager implements IFocusManager	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				private static var _isKeyFocus:Boolean = false;				private var _form:DisplayObjectContainer;		private var _focusableObjects:Dictionary;		private var _focusableCandidates:Array;		private var _lastFocus:InteractiveObject;		private var _lastAction:String;		private var _defButton:Button;		private var _defaultButton:Button;		private var _isActivated:Boolean = false;		private var _calculateCandidates:Boolean = true;		private var _showFocusIndicator:Boolean = true;		private var _defaultButtonEnabled:Boolean = true;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new FocusManager instance.		 * 		 * <p>A focus manager manages focus within the children of a		 * DisplayObjectContainer object.</p>		 * 		 * @param container A DisplayObjectContainer that hosts the focus manager,		 *         or <code>stage</code>.		 */		public function FocusManager(container:DisplayObjectContainer)		{			_focusableObjects = new Dictionary(true);						if (container)			{				_form = container;				addFocusables(DisplayObject(container));				container.addEventListener(Event.ADDED, onChildrenAdded);				container.addEventListener(Event.REMOVED, onChildrenRemoved);				activate();			}		}						/**		 * Activates the FocusManager instance.		 * <p>The FocusManager instance adds event handlers that allow it to monitor		 * focus-related keyboard and mouse activity.</p>		 */		public function activate():void		{			if (_isActivated) return;						/* Listen for focus changes, use weak references for the stage. */			_form.stage.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,				onMouseFocusChange, false, 0, true);			_form.stage.addEventListener(FocusEvent.KEY_FOCUS_CHANGE,				onKeyFocusChange, false, 0, true);			_form.addEventListener(FocusEvent.FOCUS_IN, onFocusIn, true);			_form.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut, true);			_form.stage.addEventListener(Event.ACTIVATE, onActivate, false, 0, true);			_form.stage.addEventListener(Event.DEACTIVATE, onDeactivate, false, 0, true);			_form.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);			_form.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, true);			_isActivated = true;						/* Restore focus to the last component that had it if there was one. */			if (_lastFocus) setFocus(_lastFocus);		}						/**		 * Deactivates the FocusManager.		 * <p>The FocusManager removes the event handlers that allow it to monitor		 * focus-related keyboard and mouse activity.</p>		 */		public function deactivate():void		{			_form.stage.removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,				onMouseFocusChange);			_form.stage.removeEventListener(FocusEvent.KEY_FOCUS_CHANGE,				onKeyFocusChange);			_form.removeEventListener(FocusEvent.FOCUS_IN, onFocusIn, true);			_form.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOut, true);			_form.stage.removeEventListener(Event.ACTIVATE, onActivate);			_form.stage.removeEventListener(Event.DEACTIVATE, onDeactivate);			_form.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown); 			_form.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, true);			_isActivated = false;		}						/**		 * Call this method to make the system		 * think the Enter key was pressed and the default button was clicked.		 * @private		 */		public function sendDefaultButtonEvent():void		{			_defButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));		}						/**		 * Gets the interactive object that currently has focus.		 * Adobe recommends calling this method instead of using the Stage object 		 * because this method indicates which component has focus.		 * The Stage might return a subcomponent in that component.		 *		 * @return The interactive object that currently has focus.		 */		public function getFocus():InteractiveObject		{			var o:InteractiveObject = _form.stage.focus;			return findFocusManagerComponent(o);		}						/**		 * Sets focus on an IFocusManagerComponent component. This method does		 * not check for component visibility, enabled state, or other conditions.		 *		 * @param component An object that can receive focus.		 */		public function setFocus(component:InteractiveObject):void		{			if (component is IFocusManagerComponent)				IFocusManagerComponent(component).setFocus();			else 				_form.stage.focus = component;		}						/**		 * Sets the <code>showFocusIndicator</code> value to <code>true</code>		 * and draws the visual focus indicator on the object with focus, if any.		 */		public function showFocus():void 		{		}						/**		 * Sets the <code>showFocusIndicator</code> value to <code>false</code>		 * and removes the visual focus indicator from the object that has focus, if any.		 */		public function hideFocus():void 		{		}						/**		 * Retrieves the interactive object that contains the given object, if any.		 * The player can set focus to a subcomponent of a Flash component;		 * this method determines which interactive object has focus from		 * the component perspective.		 *		 *  @param component An object that can have player-level focus.		 *  @return The object containing the <code>component</code> or, if one is		 *           not found, the <code>component</code> itself.		 */		public function findFocusManagerComponent(component:InteractiveObject):			InteractiveObject		{			var p:InteractiveObject = component;			while (component)			{				if (component is IFocusManagerComponent					&& IFocusManagerComponent(component).focusEnabled)				{					return component;				}				component = component.parent;			}			/* tab was set somewhere else */			return p;		}						/**		 *  Retrieves the interactive object that would receive focus		 *  if the user pressed the Tab key to navigate to the next object.		 *  This method retrieves the object that currently has focus		 *  if there are no other valid objects in the application.		 *		 *  @param backward If this parameter is set to <code>true</code>, 		 *  focus moves in a backward direction, causing this method to retrieve		 *  the object that would receive focus next if the Shift+Tab key combination		 *  were pressed. 		 *  @return The next component to receive focus.		 */		public function getNextFocusManagerComponent(			backward:Boolean = false):InteractiveObject		{			if (!hasFocusableObjects()) return null;			if (_calculateCandidates)			{				sortFocusableObjects();				_calculateCandidates = false;			}						/* get the object that has the focus */			var o:DisplayObject = form.stage.focus;			o = DisplayObject(findFocusManagerComponent(InteractiveObject(o)));			var g:String = "";						if (o is IFocusManagerGroup)			{				var tg:IFocusManagerGroup = IFocusManagerGroup(o);				g = tg.groupName;			}						var i:int = getIndexOfFocusedObject(o);			var bSearchAll:Boolean = false;			var start:int = i;						if (i == -1)			{				/* we didn't find it */				if (backward) i = _focusableCandidates.length;				bSearchAll = true;			}						var j:int = getIndexOfNextObject(i, backward, bSearchAll, g);			return findFocusManagerComponent(_focusableCandidates[j]);		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Returtns whether the last focus was done by the Tab key (true) or with the		 * mouse (false). This property is used in UITextComponents to handle the		 * behavior of drawFocus() when the text component is focussed by mouse.		 */		public static function get isKeyFocus():Boolean		{			return _isKeyFocus;		}				/**		 * @private		 */		public function get form():DisplayObjectContainer		{			return _form;		}						/**		 * Gets or sets the current default button.		 * <p>The default button is the button on a form that dispatches a		 * <code>click</code> event when the Enter key is pressed,		 * depending on where focus is at the time.</p>		 */		public function get defaultButton():Button		{			return _defaultButton;		}				public function set defaultButton(v:Button):void		{			var b:Button = v ? Button(v) : null;			if (b != _defaultButton) 			{				if (_defaultButton) _defaultButton.emphasized = false;				if (_defButton) _defButton.emphasized = false;				_defaultButton = b;				_defButton = b;				if (b) b.emphasized = true;			}		}						/**		 *  @copy fl.managers.IFocusManager#defaultButtonEnabled		 */		public function get defaultButtonEnabled():Boolean		{			return _defaultButtonEnabled;		}				public function set defaultButtonEnabled(v:Boolean):void		{			_defaultButtonEnabled = v;		}						/**		 *  Gets the next unique tab index to use in this tab loop.		 */		public function get nextTabIndex():int		{			return 0;		}						/**		 * Gets or sets a value that indicates whether a component that		 * has focus should be marked with a visual indicator of focus.		 */		public function get showFocusIndicator():Boolean		{			return _showFocusIndicator;		}				public function set showFocusIndicator(v:Boolean):void		{			_showFocusIndicator = v;		}						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Add or remove object if tabbing properties change.		 * @private		 */		private function onTabEnabledChange(e:Event):void		{			_calculateCandidates = true;			var t:InteractiveObject = InteractiveObject(e.target);			var registeredFocusableObject:Boolean = (_focusableObjects[t] == true);						if (t.tabEnabled)			{				if (!registeredFocusableObject && isTabVisible(t))				{					if (!(t is IFocusManagerComponent)) t.focusRect = false;					_focusableObjects[t] = true;				}			}			else 			{				if (registeredFocusableObject) delete _focusableObjects[t];			}		}						/**		 * Called when a focusable object's <code>tabIndex</code> property changes.		 * @private		 */		private function onTabIndexChange(e:Event):void		{			_calculateCandidates = true;		}						/**		 * Add or remove object if tabbing properties change.		 * @private		 */		private function onTabChildrenChange(e:Event):void		{			if (e.target != e.currentTarget) return;			_calculateCandidates = true;			var d:DisplayObjectContainer = DisplayObjectContainer(e.target);			if (d.tabChildren) addFocusables(d, true);			else removeFocusables(d);		}						/**		 * @private		 */		private function onFocusIn(e:FocusEvent):void		{			var t:InteractiveObject = InteractiveObject(e.target);			if (form.contains(t))			{				_lastFocus = findFocusManagerComponent(InteractiveObject(t));				/* handle default button here */				if (_lastFocus is Button)				{					var b:Button = Button(_lastFocus);					/* if we have marked some other button as a default button */					if (_defButton)					{						/* change it to be this button */						_defButton.emphasized = false;						_defButton = b;						b.emphasized = true;					}				}				else				{					/* restore the default button to be the original one */					if (_defButton && _defButton != _defaultButton)					{						_defButton.emphasized = false;						_defButton = _defaultButton;						_defaultButton.emphasized = true;					}				}			}		}						/**		 * Useful for debugging.		 * @private		 */		private function onFocusOut(e:FocusEvent):void		{			var t:InteractiveObject = e.target as InteractiveObject;		}						/**		 * Restore focus to the element that had it last.		 * @private		 */		private function onActivate(e:Event):void		{			var t:InteractiveObject = InteractiveObject(e.target);			if (_lastFocus)			{				if (_lastFocus is IFocusManagerComponent)					IFocusManagerComponent(_lastFocus).setFocus();				else					form.stage.focus = _lastFocus;			}			_lastAction = "ACTIVATE";		}						/**		 * Useful for debugging.		 * @private		 */		private function onDeactivate(e:Event):void		{			var t:InteractiveObject = InteractiveObject(e.target);		}						/**		 * This gets called when mouse clicks on a focusable object.		 * We block Flash Player behavior.		 * @private		 */		private function onMouseFocusChange(e:FocusEvent):void		{			_isKeyFocus = false;						if (e.relatedObject is TextField) return;			e.preventDefault();		}						/**		 * This function is called when the tab key is hit.		 * @private		 */		private function onKeyFocusChange(e:FocusEvent):void		{			showFocusIndicator = true;			if ((e.keyCode == Keyboard.TAB || e.keyCode == 0) && !e.isDefaultPrevented())			{				setFocusToNextObject(e);				e.preventDefault();			}		}						/**		 * Watch for the Enter key.		 * @private		 */		private function onKeyDown(e:KeyboardEvent):void		{			_isKeyFocus = true;						if (e.keyCode == Keyboard.TAB)			{				_lastAction = "KEY";				/* this makes and orders the focusableCandidates array */				if (_calculateCandidates)				{					sortFocusableObjects();					_calculateCandidates = false;				}			}						if (defaultButtonEnabled && e.keyCode == Keyboard.ENTER				&& defaultButton && _defButton.enabled)			{				sendDefaultButtonEvent();			}		}						/**		 * This gets called when the focus changes due to a mouse click.		 * <p><strong>Note:</strong> If focus is moving to a TextField, it is not		 * necessary to call <code>setFocus()</code> on it because the player handles it;		 * calling <code>setFocus()</code> on a TextField that has scrollable text		 * causes the text to auto-scroll to the end, making the		 * mouse click set the insertion point in the wrong place.</p>		 * @private		 */		private function onMouseDown(e:MouseEvent):void		{			_isKeyFocus = false;						if (e.isDefaultPrevented()) return;			var o:InteractiveObject = getTopLevelFocusTarget(InteractiveObject(e.target));			if (!o) return;			showFocusIndicator = false;						/* Make sure the containing component gets notified. As the note			 * above says, we don't set focus to a TextField ever because the			 * player already did and took care of where the insertion point			 * is, and we also don't call setfocus on a component that last			 * the last object with focus unless the last action was just to			 * activate the player and didn't involve tabbing or clicking on			 * a component. */			if ((o != _lastFocus || _lastAction == "ACTIVATE") && !(o is TextField))			{				setFocus(o);			}			_lastAction = "MOUSEDOWN";		}						/**		 * Listen for children being added and see if they are focus candidates.		 * @private		 */		private function onChildrenAdded(e:Event):void		{			var t:DisplayObject = DisplayObject(e.target);			/* if it is truly parented, add it, otherwise it will get			 * added when the top of the tree gets parented */			if (t.stage) addFocusables(DisplayObject(e.target));		}						/**		 * Listen for children being removed.		 * @private		 */		private function onChildrenRemoved(e:Event):void		{			var i:int;			var t:DisplayObject = DisplayObject(e.target);						if (t is IFocusManagerComponent && _focusableObjects[t])			{				if (t == _lastFocus)				{					IFocusManagerComponent(_lastFocus).drawFocus(false);					_lastFocus = null;				}				t.removeEventListener(Event.TAB_ENABLED_CHANGE, onTabEnabledChange);				delete _focusableObjects[t];				_calculateCandidates = true;			}			else if (t is InteractiveObject && _focusableObjects[t])			{				var o:InteractiveObject = t as InteractiveObject;				if (o)				{					if (o == _lastFocus) _lastFocus = null;					delete _focusableObjects[o];					_calculateCandidates = true;				}				t.addEventListener(Event.TAB_ENABLED_CHANGE, onTabEnabledChange);			}			removeFocusables(t);		}						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Do a tree walk and add all children you can find.		 * @private		 */		private function addFocusables(d:DisplayObject, skipTopLevel:Boolean = false):void		{			if (!skipTopLevel)			{				if (d is IFocusManagerComponent)				{					var focusable:IFocusManagerComponent = IFocusManagerComponent(d);					if (focusable.focusEnabled)					{						if (focusable.tabEnabled && isTabVisible(d))						{							_focusableObjects[d] = true;							_calculateCandidates = true;						}						d.addEventListener(Event.TAB_ENABLED_CHANGE, onTabEnabledChange);						d.addEventListener(Event.TAB_INDEX_CHANGE, onTabIndexChange);					}				}				else if (d is InteractiveObject)				{					var io:InteractiveObject = d as InteractiveObject;					if (io && io.tabEnabled && findFocusManagerComponent(io) == io)					{						_focusableObjects[io] = true;						_calculateCandidates = true;					}					io.addEventListener(Event.TAB_ENABLED_CHANGE, onTabEnabledChange);					io.addEventListener(Event.TAB_INDEX_CHANGE, onTabIndexChange);				}			}						if (d is DisplayObjectContainer)			{				var doc:DisplayObjectContainer = DisplayObjectContainer(d);				d.addEventListener(Event.TAB_CHILDREN_CHANGE, onTabChildrenChange);								if (doc is Stage || doc.parent is Stage || doc.tabChildren)				{					var i:int;					for (i = 0; i < doc.numChildren; i++)					{						try						{							var child:DisplayObject = doc.getChildAt(i);							if (child) addFocusables(doc.getChildAt(i));						}						catch (e:SecurityError)						{							/* Ignore this child if we can't access it */						}					}				}			}		}						/**		 * Removes the DisplayObject and all its children.		 * @private		 */		private function removeFocusables(d:DisplayObject):void		{			if (d is DisplayObjectContainer)			{				d.removeEventListener(Event.TAB_CHILDREN_CHANGE, onTabChildrenChange);				d.removeEventListener(Event.TAB_INDEX_CHANGE, onTabIndexChange);								for (var p:Object in _focusableObjects)				{					var ds:DisplayObject = DisplayObject(p);					if (DisplayObjectContainer(d).contains(ds)) 					{						if (ds == _lastFocus) _lastFocus = null;						ds.removeEventListener(Event.TAB_ENABLED_CHANGE, onTabEnabledChange);						delete _focusableObjects[p];						_calculateCandidates = true;					}				}			}		}						/**		 * Checks if the DisplayObject is visible for the tab loop.		 * @private		 */		private function isTabVisible(ds:DisplayObject):Boolean		{			var d:DisplayObjectContainer = ds.parent;			while (d && !(d is Stage) && !(d.parent && d.parent is Stage))			{				if (!d.tabChildren) return false;				d = d.parent;			}			return true;		}						/**		 * Checks if the DisplayObject is a valid candidate for the tab loop.		 * @private		 */		private function isValidFocusCandidate(d:DisplayObject, groupName:String):Boolean		{			if (!isEnabledAndVisible(d)) return false;			if (d is IFocusManagerGroup)			{				var tg:IFocusManagerGroup = IFocusManagerGroup(d);				if (groupName == tg.groupName) return false;			}			return true;		}						/**		 * Checks if the DisplayObject is enabled and visible, or		 * a selectable or input TextField.		 * @private		 */		private function isEnabledAndVisible(o:DisplayObject):Boolean		{			var formParent:DisplayObjectContainer = DisplayObject(_form).parent;			while (o != formParent)			{				if (o is UIComponent)				{					/* The DO is a disabled UIComponent */					if (!UIComponent(o).enabled) return false;				}				else if (o is TextField)				{					/* The DO is a dynamic or non-selectable TextField */					var tf:TextField = TextField(o);					if (tf.type == TextFieldType.DYNAMIC || !tf.selectable) return false;				}				else if (o is SimpleButton)				{					/* The DO is a disabled SimpleButton */					var sb:SimpleButton = SimpleButton(o);					if (!sb.enabled) return false;				}								/* The DO is not visible */				if (!o.visible) return false;								o = o.parent;			}			return true;		}						/**		 * @private		 */		private function setFocusToNextObject(e:FocusEvent):void		{			if (!hasFocusableObjects()) return;			var o:InteractiveObject = getNextFocusManagerComponent(e.shiftKey);			if (o) setFocus(o);		}						/**		 * @private		 */		private function hasFocusableObjects():Boolean		{			for (var o:Object in _focusableObjects)			{				return true;			}			return false;		}						/**		 * @private		 */		private function getIndexOfFocusedObject(o:DisplayObject):int		{			var n:int = _focusableCandidates.length;			var i:int = 0;						for (i = 0;i < n; i++)			{				if (_focusableCandidates[i] == o) return i;			}			return -1;		}						/**		 * @private		 */		private function getIndexOfNextObject(i:int, shiftKey:Boolean,			bSearchAll:Boolean, groupName:String):int		{			var n:int = _focusableCandidates.length;			var start:int = i;						while (true)			{				if (shiftKey) i--;				else i++;								if (bSearchAll)				{					if (shiftKey && i < 0) break;					if (!shiftKey && i == n) break;				}				else				{					i = (i + n) % n;					/* came around and found the original */					if (start == i) break;				}								if (isValidFocusCandidate(_focusableCandidates[i], groupName))				{					var o:DisplayObject =						DisplayObject(findFocusManagerComponent(_focusableCandidates[i]));										if (o is IFocusManagerGroup)					{						/* look around to see if there's a selected member in the						 * tabgroup otherwise use the first one we found. */						var tg1:IFocusManagerGroup = IFocusManagerGroup(o);						for (var j:int = 0; j < _focusableCandidates.length; j++)						{							var obj:DisplayObject = _focusableCandidates[j];							if (obj is IFocusManagerGroup)							{								var tg2:IFocusManagerGroup = IFocusManagerGroup(obj);								if (tg2.groupName == tg1.groupName && tg2.selected)								{									i = j;									break;								}							}						}					}					return i;				}			}			return i;		}						/**		 * @private		 */		private function sortFocusableObjects():void		{			_focusableCandidates = [];			for (var o:Object in _focusableObjects)			{				var c:InteractiveObject = InteractiveObject(o);				if (c.tabIndex && !isNaN(Number(c.tabIndex)) && c.tabIndex > 0)				{					sortFocusableObjectsTabIndex();					return;				}				_focusableCandidates.push(c);			}			_focusableCandidates.sort(sortByDepth);		}						/**		 * @private		 */		private function sortFocusableObjectsTabIndex():void		{			_focusableCandidates = [];			for (var o:Object in _focusableObjects)			{				var c:InteractiveObject = InteractiveObject(o);				if (c.tabIndex && !isNaN(Number(c.tabIndex)))				{					/* if we get here, it is a candidate */					_focusableCandidates.push(c);				}			}			_focusableCandidates.sort(sortByTabIndex);		}						/**		 * @private		 */		private function sortByDepth(aa:InteractiveObject, bb:InteractiveObject):Number		{			var val1:String = "";			var val2:String = "";			var index:int;			var tmp:String;			var tmp2:String;			var zeros:String = "0000";			var a:DisplayObject = DisplayObject(aa);			var b:DisplayObject = DisplayObject(bb);						while (a != DisplayObject(_form) && a.parent)			{				index = getChildIndex(a.parent, a);				tmp = index.toString(16);				if (tmp.length < 4)				{					tmp2 = zeros.substring(0, 4 - tmp.length) + tmp;				}				val1 = tmp2 + val1;				a = a.parent;			}						while (b != DisplayObject(_form) && b.parent)			{				index = getChildIndex(b.parent, b);				tmp = index.toString(16);				if (tmp.length < 4)				{					tmp2 = zeros.substring(0, 4 - tmp.length) + tmp;				}				val2 = tmp2 + val2;				b = b.parent;			}			return val1 > val2 ? 1 : val1 < val2 ? -1 : 0;		}						/**		 * @private		 */		private function getChildIndex(parent:DisplayObjectContainer, child:DisplayObject):int		{			return parent.getChildIndex(child);		}						/**		 * @private		 */		private function sortByTabIndex(a:InteractiveObject, b:InteractiveObject):int		{			return (a.tabIndex > b.tabIndex ? 1 : a.tabIndex < b.tabIndex ? -1				: sortByDepth(a, b));		}						/**		 * @private		 */		private function getTopLevelFocusTarget(o:InteractiveObject):InteractiveObject		{			while (o != InteractiveObject(_form))			{				if (o is IFocusManagerComponent && IFocusManagerComponent(o).focusEnabled					&& IFocusManagerComponent(o).mouseFocusEnabled && UIComponent(o).enabled)				{					return o;				}								o = o.parent;				if (!o) break;			}			return null;		}	}}