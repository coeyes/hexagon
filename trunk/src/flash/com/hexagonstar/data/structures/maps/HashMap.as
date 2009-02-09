/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.data.structures.maps{	import com.hexagonstar.data.structures.ICollection;	import com.hexagonstar.data.structures.IIterator;		import flash.utils.Dictionary;			/**	 * HashMap Class	 */	public class HashMap extends AbstractMap implements IMap	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				protected var _keyMap:Dictionary;		protected var _dupMap:Dictionary;		protected var _initSize:int;		protected var _maxSize:int;				protected var _node:Node;		protected var _first:Node;		protected var _last:Node;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new HashMap instance.		 */		public function HashMap(size:int = 500)		{			_initSize = _maxSize = Math.max(10, size);						_keyMap = new Dictionary(true);			_dupMap = new Dictionary(true);			_size = 0;						var n:Node = new Node();			_first = _last = n;						var l:int = _initSize + 1;			for (var i:int = 0; i < l; i++)			{				n.next = new Node();				n = n.next;			}						_last = n;		}						////////////////////////////////////////////////////////////////////////////////////////		// Query Operations                                                                   //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Checks if the Map contains the specified value.		 */		override public function contains(value:*):Boolean		{			return _dupMap[value] > 0;		}						/**		 * Checks if the Map contains the specified key.		 */		public function containsKey(key:*):Boolean		{			return _keyMap[key] != null;		}						/**		 * Returns the value that is mapped with the specified key.		 */		public function getValue(key:*):*		{			var n:Node = _keyMap[key];			if (n) return n.val;			return null;		}						/**		 * 		 */		public function iterator():IIterator		{			return new HashMapIterator(_node);		}						/**		 * 		 */		public function clone():*		{			return null;		}						/**		 * Returns an Array that contains all values that are mapped.		 */		public function toArray():Array		{			var a:Array = new Array(_size);			var i:int = 0;			for each (var n:Node in _keyMap)				a[i++] = n.val;			return a;		}						/**		 * Returns an Array that contains all keys that are mapped.		 */		public function toKeyArray():Array		{			var a:Array = new Array(_size);			var i:int = 0;			for each (var n:Node in _keyMap)				a[i++] = n.key;			a.sort(Array.NUMERIC);			return a;		}						/**		 * Returns a String that contains all key-value pairs in the Map.		 */		public function dump():String		{			var s:String = toString();			for each (var n:Node in _keyMap)				s += "\n[" + n.key + ": " + n.val + "]";			return s;		}						////////////////////////////////////////////////////////////////////////////////////////		// Modification Operations                                                            //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * 		 */		public function add(element:*):Boolean		{			// TODO Throw Operation Not Supported Exception!			return false;		}						/**		 * 		 */		public function put(key:*, value:*):Boolean		{			if (key == null)  return false;			// TODO check for evtl. probs with dupe values!			//if (value == null)  return false;			if (_keyMap[key]) return false;						if (_size++ == _maxSize)			{				var l:int = (_maxSize += _initSize) + 1;				for (var i:int = 0; i < l; i++)				{					_last.next = new Node();					_last = _last.next;				}			}						var n:Node = _first;			_first = _first.next;			n.key = key;			n.val = value;						n.next = _node;						if (_node) _node.prev = n;			_node = n;						_keyMap[key] = n;			_dupMap[value] ? _dupMap[value]++ : _dupMap[value] = 1;						return true;		}						/**		 * Removes the entry from the Map that was mapped with the specified key.		 * 		 * @param key The key that the entry is mapped with.		 * @return The value from the removed entry or null if no matching		 *          entry was found.		 */		public function remove(key:*):*		{			var n:Node = _keyMap[key];						if (n)			{				var v:* = n.val;				delete _keyMap[key];								if (n.prev) n.prev.next = n.next;				if (n.next) n.next.prev = n.prev;				if (n == _node) _node = n.next;								n.prev = null;				n.next = null;				_last.next = n;				_last = n;								if (--_dupMap[v] <= 0)					delete _dupMap[v];								if (--_size <= (_maxSize - _initSize))				{					var l:int = (_maxSize -= _initSize) + 1;					for (var i:int = 0; i < l; i++)						_first = _first.next;				}								return v;			}						return null;		}						////////////////////////////////////////////////////////////////////////////////////////		// Bulk Operations                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * 		 */		public function addAll(collection:ICollection):Boolean		{			// TODO Throw Operation Not Supported Exception!			return false;		}						/**		 * 		 */		public function putAll(map:IMap):Boolean		{			return false;		}						/**		 * 		 */		public function removeAll(collection:ICollection):Boolean		{			return false;		}						/**		 * 		 */		public function retainAll(collection:ICollection):Boolean		{			return false;		}						/**		 * 		 */		override public function containsAll(collection:ICollection):Boolean		{			return false;		}						/**		 * 		 */		public function clear():void		{			_keyMap = new Dictionary(true);			_dupMap = new Dictionary(true);						var t:Node;			var n:Node = _node;						while (n)			{				t = n.next;								n.next = n.prev = null;				n.key = null;				n.val = null;				_last.next = n;				_last = _last.next;				n = t;			}						_node = null;			_size = 0;		}	}}// ---------------------------------------------------------------------------------------------/** * @private */internal class Node{	public var key:*;	public var val:*;	public var prev:Node;	public var next:Node;}// ---------------------------------------------------------------------------------------------import com.hexagonstar.data.structures.IIterator;/** * @private */internal class HashMapIterator implements IIterator{	private var _node:Node;	private var _walker:Node;		public function HashMapIterator(node:Node)	{		_node = _walker = node;	}			public function remove():*	{		// TODO remove not supportet! (yet)		return null;	}			public function reset():void	{		_walker = _node;	}			public function get hasNext():Boolean	{		return _walker != null;	}		public function get next():*	{		var v:* = _walker.val;		_walker = _walker.next;		return v;	}		public function get data():*	{		return _walker.val;	}	public function set data(v:*):void	{		_walker.val = v;	}}