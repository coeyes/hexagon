/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package {	import flexunit.framework.TestSuite;		import testsuites.data.structures.lists.*;	import testsuites.data.structures.maps.HashMapTest;	import testsuites.data.structures.queues.*;	import testsuites.io.file.*;		
	/**	 * AllTests Class	 */	public class AllTests	{		/**		 * Creates a new AllTests instance.		 */		public function AllTests()		{		}						/**		 * suite		 */		public static function suite():TestSuite		{			var testSuite:TestSuite = new TestSuite();			testSuite.addTestSuite(SinglyLinkedListTest);			testSuite.addTestSuite(LinearQueueTest);			testSuite.addTestSuite(HashMapTest);						testSuite.addTestSuite(SequentialFileReaderTest);						return testSuite;		}	}}