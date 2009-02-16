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
package testsuites.data.structures.maps
{
	import flexunit.framework.*;
	
	import com.hexagonstar.data.structures.maps.HashMap;
	import com.hexagonstar.util.debug.Debug;	

	public class HashMapTest extends TestCase
	{
		
		private var _collection:HashMap;
		//--------------------------------------------------------------------------------------
		
		public function HashMapTest(name:String = null)
		{
			super(name);
		}
		
		
		override public function setUp():void
		{
			Assert.resetAssertionsMade();
		}
      
      
		//--------------------------------------------------------------------------------------
      
		public function testAll():void
		{
			Debug.trace("\n\n*******************************************************\n"
				+ "HashMap Tests"
				+ "\n*******************************************************");
			
			create();
			
			put();
			remove();
			
			contains();
			clone();
			toArray();
			
			putAll();
			containsAll();
			removeAll();
			retainAll();
			clear();
		}
		
		
		private function log(title:String = ""):void
		{
			if (title.length > 0)
			{
				logTitle(title);
			}
			else
			{
				Debug.delimiter();
			}
			
			Debug.trace(_collection.dump());
		}
		
		private function logTitle(title:String = ""):void
		{
			Debug.trace("\n\n========================================\n"
				+ "HashMap " + title
				+ "\n========================================");
		}
		
		
		//--------------------------------------------------------------------------------------
		
		private function create():void
		{
			_collection = new HashMap();
			assertStrictlyEquals(_collection, _collection);
			assertEquals(_collection.size, 0);
			assertTrue(_collection.isEmpty);
			log("create");
		}
		
		
		//--------------------------------------------------------------------------------------
		
		private function put():void
		{
			assertTrue(_collection.put(110, "Suzanne"));
			assertTrue(_collection.put(111, "Beth"));
			assertFalse(_collection.put(112, null));
			assertTrue(_collection.put(113, "Kayla"));
			assertTrue(_collection.put(2133, "Brianna"));
			assertEquals(_collection.size, 4);
			assertFalse(_collection.isEmpty);
			log("put");
		}
		
		private function remove():void
		{
//			assertEquals(_collection.remove("Inserted with Index -12"), "Inserted with Index -12");
//			assertEquals(_collection.remove("Brianna"), "Brianna");
//			assertEquals(_collection.remove("Inserted with Index 21"), "Inserted with Index 21");
//			assertEquals(_collection.remove(777), 777);
//			assertEquals(_collection.remove(null), null);
//			assertUndefined(_collection.remove("XX"));
//			
//			assertTrue(_collection.insert(3, "Beth"));
//			log("remove");
//			
//			assertEquals(_collection.remove("Beth"), "Beth");
//			assertEquals(_collection.size, 13);
//			log();
		}
		
		
		//--------------------------------------------------------------------------------------
		
		private function contains():void
		{
//			assertTrue(_collection.contains("Inserted with Index 3"));
//			assertFalse(_collection.contains("Inserted with Index 7000"));
//			assertTrue(_collection.contains(125));
//			assertFalse(_collection.contains(126));
//			assertTrue(_collection.contains("Suzanne"));
//			assertFalse(_collection.contains(null));
//			assertFalse(_collection.contains(undefined));
//			assertEquals(_collection.size, 13);
//			log("contains");
		}
		
		private function clone():void
		{
//			var clone:SinglyLinkedList = _collection.clone();
//			logTitle("clone");
//			Debug.trace("Clone:\n" + clone.dump());
//			assertEquals(clone.size, 13);
		}
		
		private function toArray():void
		{
//			var array:Array = _collection.toArray();
//			logTitle("toArray");
//			Debug.trace(array);
//			assertEquals(array.length, 13);
		}
		
		
		//--------------------------------------------------------------------------------------
	
		private function putAll():void
		{
//			var list2:SinglyLinkedList = new SinglyLinkedList("Steve", "Gerry", "James");
//			assertTrue(_collection.addAll(list2));
//			
//			var emptyList:SinglyLinkedList = new SinglyLinkedList();
//			assertFalse(_collection.addAll(emptyList));
//			
//			assertEquals(_collection.size, 16);
//			log("addAll");
		}
		
		private function replaceAll():void
		{
//			var list5:SinglyLinkedList = new SinglyLinkedList("Replaced with Magnum", "Replaced with Higgins", "Replaced with TC");
//			assertTrue(_collection.replaceAll(1, list5));
//			
//			var emptyList:SinglyLinkedList = new SinglyLinkedList();
//			assertFalse(_collection.replaceAll(12, emptyList));
//			
//			assertEquals(_collection.size, 21);
//			log("replaceAll");
		}
		
		private function containsAll():void
		{
//			var list6:SinglyLinkedList = new SinglyLinkedList("Giles", "Beth", 125, "Keela");
//			assertTrue(_collection.containsAll(list6));
//			
//			var list7:SinglyLinkedList = new SinglyLinkedList("Giles", "Beth", 125, "Raoul");
//			assertFalse(_collection.containsAll(list7));
//			
//			assertEquals(_collection.size, 21);
//			log("containsAll");
		}
		
		private function removeAll():void
		{
//			var list8:SinglyLinkedList = new SinglyLinkedList("Buffy", "Steve", "Jeannie");
//			assertTrue(_collection.removeAll(list8));
//			
//			var list9:SinglyLinkedList = new SinglyLinkedList("James", "Todd", "Terry");
//			assertTrue(_collection.removeAll(list9));
//			
//			var list10:SinglyLinkedList = new SinglyLinkedList("Cora", "Todd", "Terry");
//			assertFalse(_collection.removeAll(list10));
//			
//			assertEquals(_collection.size, 17);
//			log("removeAll");
		}
		
		private function retainAll():void
		{
//			var list11:SinglyLinkedList = new SinglyLinkedList();
//			list11.append("Giles", "Keela", "Dawn", 125, "Kayla", "Anabel");
//			assertTrue(_collection.retainAll(list11));
//			
//			var list12:SinglyLinkedList = new SinglyLinkedList();
//			list12.append("Giles", "Keela", "Dawn", 125, "Kayla", "Anabel");
//			assertFalse(_collection.retainAll(list12));
//			assertEquals(_collection.size, 5);
//			
//			var list13:SinglyLinkedList = new SinglyLinkedList("Anabel", "Suzi", "Bill");
//			assertTrue(_collection.retainAll(list13));
//			assertEquals(_collection.size, 0);
//			assertTrue(_collection.isEmpty);
//			
//			log("retainAll");
		}
		
		private function clear():void
		{
//			_collection.append("Anabel", "Suzi", "Bill");
//			assertEquals(_collection.size, 3);
//			assertFalse(_collection.isEmpty);
//			log("clear");
//			
//			_collection.clear();
//			assertEquals(_collection.size, 0);
//			assertTrue(_collection.isEmpty);
//			log();
		}
	}
}
