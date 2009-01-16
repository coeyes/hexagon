/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.io.key{	import com.hexagonstar.display.StageReference;	import com.hexagonstar.env.event.KeyCombinationEvent;	import com.hexagonstar.env.event.RemovableEventDispatcher;	import com.hexagonstar.env.exception.UnsupportedOperationException;		import flash.display.Stage;	import flash.events.Event;	import flash.events.KeyboardEvent;	import flash.utils.Dictionary;			[Event(name="keyDown",	type="flash.events.KeyboardEvent")]	[Event(name="keyUp",	type="flash.events.KeyboardEvent")]	[Event(name="down",		type="com.hexagonstar.env.event.KeyCombinationEvent")]	[Event(name="release",	type="com.hexagonstar.env.event.KeyCombinationEvent")]	[Event(name="sequence",	type="com.hexagonstar.env.event.KeyCombinationEvent")]			/**	 * A Singleton Key class that simplifies listening to global key strokes and	 * adds additional keyboard events. Key enables you to receive events when	 * multiple keys are held/released and when a sequence of keys is pressed.	 * 	 * @example	 * <pre>	 * package	 * {	 * 	import com.hexagonstar.display.StageReference;	 * 	import com.hexagonstar.env.event.KeyCombinationEvent;	 * 	import com.hexagonstar.io.key.Key;	 * 	import com.hexagonstar.io.key.KeyCombination;	 * 	import com.hexagonstar.util.debug.Debug;	 * 		 * 	import flash.display.Sprite;	 * 	import flash.events.KeyboardEvent;	 * 		 * 	public class KeyExample extends Sprite	 * 	{	 * 		private var _combo1:KeyCombination;	 * 		private var _combo2:KeyCombination;	 * 		private var _combo3:KeyCombination;	 * 		private var _key:Key;	 * 			 * 		public function KeyExample()	 * 		{	 * 			StageReference.stage = stage;	 * 				 * 			_combo1 = new KeyCombination(65, 83, 68, 70);	 * 			_combo2 = new KeyCombination(17, 16, 67);	 * 			_combo3 = new KeyCombination(72, 69, 88, 65, 71, 79, 78);	 * 				 * 			_key = Key.instance;	 * 			_key.addKeyCombination(_combo1);	 * 			_key.addKeyCombination(_combo2);	 * 			_key.addKeyCombination(_combo3);	 * 			_key.addEventListener(KeyCombinationEvent.DOWN, onComboDown);	 * 			_key.addEventListener(KeyCombinationEvent.RELEASE, onComboRelease);	 * 			_key.addEventListener(KeyCombinationEvent.SEQUENCE, onComboTyped);	 * 			_key.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPressed);	 * 			_key.addEventListener(KeyboardEvent.KEY_UP, onKeyReleased);	 * 		}	 * 			 * 			 * 		private function onComboDown(e:KeyCombinationEvent):void	 * 		{	 * 			if (_combo1.equals(e.keyCombination))	 * 				Debug.trace("User is holding down keys A-S-D-F.");	 * 			else if (_combo2.equals(e.keyCombination))	 * 				Debug.trace("User is holding down CTRL+SHIFT+C.");	 * 		}	 * 			 * 		private function onComboRelease(e:KeyCombinationEvent):void	 * 		{	 * 			if (_combo1.equals(e.keyCombination))	 * 				Debug.trace("User released keys A-S-D-F.");	 * 			else if (_combo2.equals(e.keyCombination))	 * 				Debug.trace("User released CTRL+SHIFT+C.");	 * 		}	 * 			 * 		private function onComboTyped(e:KeyCombinationEvent):void	 * 		{	 * 			if (_combo3.equals(e.keyCombination))	 * 			{	 * 				Debug.trace("User typed hexagon.");	 * 			}	 * 		}	 * 			 * 		private function onKeyPressed(e:KeyboardEvent):void	 * 		{	 * 			Debug.trace("User pressed key with code: " + e.keyCode + ".");	 * 		}	 * 			 * 		private function onKeyReleased(e:KeyboardEvent):void	 * 		{	 * 			Debug.trace("User released key with code: " + e.keyCode + ".");	 * 		}	 * 	}	 * }	 * </pre>	 */	public class Key extends RemovableEventDispatcher	{		////////////////////////////////////////////////////////////////////////////////////////		// Constants                                                                          //		////////////////////////////////////////////////////////////////////////////////////////				public static const KEY_COMBINATION_DELIMITER:String = "+";						////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				protected static var _instance:Key;				protected var _keysDown:Dictionary;		protected var _keysTyped:Vector.<uint>;		protected var _combsDown:Vector.<KeyCombination>;		protected var _combs:Vector.<KeyCombination>;		protected var _longestComb:int;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new instance of the class. You shouldn't use the constructor to		 * instantiate this class. Instead use the Key.instance getter. It is		 * necessary to set the StageReference first before using this class.		 */		public function Key()		{			super();						if (_instance)			{				throw new Error("Tried to instantiate Key through"					+ " it's constructor. Use Key.instance instead!");			}						var stage:Stage = StageReference.stage;			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);			stage.addEventListener(Event.DEACTIVATE, onDeactivate);						_keysDown = new Dictionary();			_keysTyped = new Vector.<uint>();			_combsDown = new Vector.<KeyCombination>();			_combs = new Vector.<KeyCombination>();			_longestComb = 0;		}						/**		 * Determines if the key with the specified keyCode is being pressed.		 * 		 * @param keyCode The key code value assigned to a specific key or a		 *         Keyboard class constant associated with the key.		 * @return Returns true if key is currently pressed; otherwise false.		 */		public function isDown(keyCode:uint):Boolean		{			return _keysDown[keyCode];		}						/**		 * Adds a key combination to trigger a KeyCombinationEvent.		 * 		 * @param kc A defined KeyCombination object.		 */		public function addKeyCombination(kc:KeyCombination):void		{			var i:int = _combs.length;			while (i--)			{				if (_combs[i].equals(kc)) return;			}						_longestComb = Math.max(_longestComb, kc.keyCodes.length);			_combs.push(kc);		}						/**		 * Removes a key combination that has been added with addKeyCombination		 * from triggering a KeyCombinationEvent.		 * 		 * @param kc A defined KeyCombination object.		 */		public function removeKeyCombination(kc:KeyCombination):void		{			var i:int = -1;			var l:int = _combs.length;						/* Check if the specified combination exists in _combs */			while (l--)			{				if (_combs[l].equals(kc))				{					i = l;					break;				}			}			if (i == -1) return;						_combs.splice(i, 1);						/* Update _longestComb */			if (kc.keyCodes.length == _longestComb)			{				var size:int = 0;				l = _combs.length;				while (l--)				{					size = Math.max(size, _combs[l].keyCodes.length);				}								_longestComb = size;			}		}						/**		 * Throws an UnsupportedOperationException since Singleton Key should not		 * be disposed.		 * 		 * @throws UnsupportedOperationException Key class may not be disposed.		 */		override public function dispose():void		{			throw new UnsupportedOperationException("Key class should not be disposed!");		}						/**		 * Checks whether the specified key string contains a valid combination		 * of keys. A valid key combination string is comprised of at least two		 * valid key names (see KeyCodes class) which are connected by a plus (+)		 * character, e.g. CTRL+C. A key combination can contain several keys, e.g.		 * CTRL+SHIFT+F1. A string that only contains a single key (e.g. CTRL) is		 * not considered a key combination.		 * 		 * @param keyString The string to check for key codes.		 * @return true if the string contains two or more connected keycodes.		 */		public static function isCombination(keyString:String):Boolean		{			if (keyString.length > 2 && keyString.indexOf(KEY_COMBINATION_DELIMITER) > -1)			{				return true;			}			return false;		}						/**		 * Returns an array of key codes that are created from the specified keyString.		 * The keyString can contain one or more key names combined by the key		 * combination delimiter (+), e.g. CTRL+SHIFT+A or just CTRL. If no valid		 * key names or key combination was found it returns null.		 * 		 * @param keyString the string of keys to provide key codes from.		 * @return an array comprising of the key codes or null.		 */		public static function getKeyCodes(keyString:String):Array		{			var a:Array = [];			var k:Array = keyString.split(KEY_COMBINATION_DELIMITER);						for each (var s:String in k)			{				var c:int = KeyCodes.getKeyCode(s);				if (c > -1) a.push(c);			}						if (a.length > 0) return a;			return null;		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @return the Singleton instance for Key.		 */		public static function get instance():Key		{			if (!_instance) _instance = new Key();			return _instance;		}						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @sends KeyboardEvent#KEY_DOWN - Dispatched when the user presses a key.		 * @private		 */		protected function onKeyDown(e:KeyboardEvent):void		{			var alreadyDown:Boolean = _keysDown[e.keyCode];			_keysDown[e.keyCode] = true;			_keysTyped.push(e.keyCode);						if (_keysTyped.length > _longestComb) _keysTyped.splice(0, 1);						var l:int = _combs.length;			while (l--)			{				checkTypedKeys(_combs[l]);				if (!alreadyDown) checkDownKeys(_combs[l]);			}						dispatchEvent(e.clone());		}						/**		 * @sends KeyboardEvent#KEY_UP - Dispatched when the user releases a key.		 * @sends KeyComboEvent#RELEASE - Dispatched whens all keys in an added		 * KeyCombination are no longer being held together at once.		 * @private		 */		protected function onKeyUp(e:KeyboardEvent):void		{			var l:int = _combsDown.length;			while (l--)			{				if (_combsDown[l].keyCodes.indexOf(e.keyCode) != -1)				{					var kce:KeyCombinationEvent =						new KeyCombinationEvent(KeyCombinationEvent.RELEASE);					kce.keyCombination = _combsDown[l];					_combsDown.splice(l, 1);					dispatchEvent(kce);				}			}						delete _keysDown[e.keyCode];			dispatchEvent(e.clone());		}						/**		 * @private		 */		protected function onDeactivate(e:Event):void		{			var l:int = _combsDown.length;			while (l--)			{				var kce:KeyCombinationEvent =					new KeyCombinationEvent(KeyCombinationEvent.RELEASE);				kce.keyCombination = _combsDown[l];				dispatchEvent(kce);			}						_combsDown = new Vector.<KeyCombination>();			_keysDown = new Dictionary();		}						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @sends KeyComboEvent#SEQUENCE - Dispatched when all keys in an added		 * KeyCombination are typed in order.		 * @private		 */		protected function checkTypedKeys(kc:KeyCombination):void		{			var c1:Vector.<uint> = kc.keyCodes;			var l:int = c1.length;			var c2:Vector.<uint> = _keysTyped.slice(-l);			var isEqual:Boolean = true;						/* Check for equality */			if (l != c2.length)			{				isEqual = false;			}			else			{				while (l--)				{					if (c1[l] != c2[l]) isEqual = false;				}			}						if (isEqual)			{				var kce:KeyCombinationEvent =					new KeyCombinationEvent(KeyCombinationEvent.SEQUENCE);				kce.keyCombination = kc;				dispatchEvent(kce);			}		}				/**		 * @sends KeyComboEvent#DOWN - Dispatched when all keys in an added		 * KeyCombination are held down together at once.		 * @private		 */		protected function checkDownKeys(kc:KeyCombination):void		{			var uniqueCombination:Vector.<uint> = removeDuplicates(kc.keyCodes);			var i:int = uniqueCombination.length;						while (i--)			{				if (!isDown(uniqueCombination[i])) return;			}						var kce:KeyCombinationEvent = new KeyCombinationEvent(KeyCombinationEvent.DOWN);			kce.keyCombination = kc;			_combsDown.push(kc);			dispatchEvent(kce);		}						/**		 * Removes duplicate characters from entered key sequences.		 * @private		 * 		 * @param v Vector with key codes.		 */		protected function removeDuplicates(v:Vector.<uint>):Vector.<uint>		{			return v.filter(duplicatesFilter);		}						/**		 * Used as filter function for removeDuplicates method.		 * @private		 * 		 * @param e Item		 * @param i Index		 * @param v Vector		 */		protected function duplicatesFilter(e:uint, i:int, v:Vector.<uint>):Boolean		{			return (i == 0) ? true : v.lastIndexOf(e, i - 1) == -1;		}	}}