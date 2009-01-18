/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package testsuites.data.structures.queues {	import flexunit.framework.*;		import com.hexagonstar.data.structures.queues.Queue;	import com.hexagonstar.util.debug.Debug;			public class QueueTest extends TestCase	{				private var _collection:Queue;		//--------------------------------------------------------------------------------------				public function QueueTest(name:String = null)		{			super(name);		}						override public function setUp():void		{			Assert.resetAssertionsMade();		}            		//--------------------------------------------------------------------------------------      		public function testAll():void		{			Debug.trace("\n\n*******************************************************\n"				+ "LinearQueue Tests"				+ "\n*******************************************************");						createEmpty();			create();						enqueue();			add();			dequeue();			remove();						peek();			contains();			clone();			toArray();						addAll();			containsAll();			removeAll();			retainAll();			clear();		}						private function log(title:String = ""):void		{			if (title.length > 0)			{				logTitle(title);			}			else			{				Debug.delimiter();			}						Debug.trace(_collection.dump());		}				private function logTitle(title:String = ""):void		{			Debug.trace("\n\n========================================\n"				+ "LinearQueue " + title				+ "\n========================================");		}						//--------------------------------------------------------------------------------------				private function createEmpty():void		{			_collection = new Queue();			assertStrictlyEquals(_collection, _collection);			assertEquals(_collection.size, 0);			assertTrue(_collection.isEmpty);			log("create (empty)");		}				private function create():void		{			_collection = new Queue("Jenny", "Brianna", "Keela");			assertStrictlyEquals(_collection, _collection);			assertEquals(_collection.size, 3);			assertFalse(_collection.isEmpty);			log("create");		}						//--------------------------------------------------------------------------------------				private function enqueue():void		{			assertTrue(_collection.enqueue("Heather"));			assertTrue(_collection.enqueue(777));			assertTrue(_collection.enqueue("Kayla"));			assertTrue(_collection.enqueue(null));			assertEquals(_collection.size, 7);			assertFalse(_collection.isEmpty);			log("enqueue");		}				private function add():void		{			assertTrue(_collection.add("Suzanne"));			assertTrue(_collection.add(null));			assertEquals(_collection.size, 9);			assertFalse(_collection.isEmpty);			log("add");		}				private function dequeue():void		{			assertEquals(_collection.dequeue(), "Jenny");			assertEquals(_collection.size, 8);			assertEquals(_collection.dequeue(), "Brianna");			assertEquals(_collection.size, 7);			log("dequeue");		}				private function remove():void		{			/* Removing elements not supported by LinearQueue! */			//assertEquals(_collection.remove("Suzanne"), undefined);			//assertEquals(_collection.size, 7);			//log("remove");		}						//--------------------------------------------------------------------------------------				private function peek():void		{			assertEquals(_collection.peek(), "Keela");			assertEquals(_collection.size, 7);			log("peek");		}				private function contains():void		{			assertTrue(_collection.contains(777));			assertFalse(_collection.contains("Gerry"));			assertTrue(_collection.contains("Keela"));			assertFalse(_collection.contains(126));			assertTrue(_collection.contains("Suzanne"));			assertTrue(_collection.contains(null));			assertFalse(_collection.contains(undefined));			assertEquals(_collection.size, 7);			log("contains");		}				private function clone():void		{			var clone:Queue = _collection.clone();			logTitle("clone");			Debug.trace("Clone:\n" + clone.dump());			assertEquals(clone.size, 7);		}				private function toArray():void		{			var array:Array = _collection.toArray();			logTitle("toArray");			Debug.trace(array);			assertEquals(array.length, 7);		}						//--------------------------------------------------------------------------------------			private function addAll():void		{			var queueA:Queue = new Queue("Steve", "Giles", "James");			assertTrue(_collection.addAll(queueA));						var empty:Queue = new Queue();			assertFalse(_collection.addAll(empty));						assertEquals(_collection.size, 10);			log("addAll");		}				private function containsAll():void		{			/* All contained */			var queueA:Queue = new Queue("Giles", "Keela", 777, null);			assertTrue(_collection.containsAll(queueA));						/* Not all contained */			var queueB:Queue = new Queue("Giles", "Steve", "Raoul", "Kayla");			assertFalse(_collection.containsAll(queueB));						assertEquals(_collection.size, 10);			log("containsAll");		}				private function removeAll():void		{			/* Removing elements not supported by LinearQueue! */		}				private function retainAll():void		{			/* Removing elements not supported by LinearQueue! */		}				private function clear():void		{			_collection.clear();			assertEquals(_collection.size, 0);			assertTrue(_collection.isEmpty);			log("clear");		}	}}