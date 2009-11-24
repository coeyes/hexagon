/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.data.structures.lists{	import com.hexagonstar.data.structures.AbstractCollection;	import com.hexagonstar.data.structures.ICollection;	import com.hexagonstar.exception.IndexOutOfBoundsException;		/**	 * Abstract class for list implementations that share common methods.	 * 	 * @author Sascha Balkau	 * @version 1.0.0	 */	public class AbstractList extends AbstractCollection	{		////////////////////////////////////////////////////////////////////////////////////////		// Query Operations                                                                   //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Abstract Method.		 */		public function getElementAt(index:int):*		{			return null;		}				////////////////////////////////////////////////////////////////////////////////////////		// Modification Operations                                                            //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Abstract Method.		 */		public function append(...elements):Boolean		{			return false;		}						/**		 * Abstract Method.		 */		public function insert(index:int, element:*):Boolean		{			return false;		}						/**		 * Abstract Method.		 */		public function replace(index:int, element:*):*		{			return null;		}						/**		 * Abstract Method.		 */		public function remove(element:*):*		{			return null;		}						/**		 * Abstract Method.		 */		public function removeAt(index:int):*		{			return null;		}						////////////////////////////////////////////////////////////////////////////////////////		// Bulk Operations                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Adds all of the elements in the specified collection to the end of the list and		 * returns true if the elements were added successfully or false if no elements were		 * added, e.g. if the specified collection is empty.		 * 		 * @param collection The collection whose elements should be added to the list.		 * @return true if the elements of the specified collection were added successfully.		 * @throws com.hexagonstar.exception.NullReferenceException if the specified		 *             collection is null.		 */		public function addAll(collection:ICollection):Boolean		{			if (collection)			{				if (collection.size < 1) return false;								var a:Array = collection.toArray();				var l:int = a.length;								for (var i:int = 0; i < l; i++)				{					append(a[i]);				}								return true;			}			else			{				return throwNullReferenceException();			}		}						/**		 * Inserts all elements contained in the specified collection to the List starting		 * at the specified index. Elements that are at an affected index are shifted to the		 * right by the size of the specified collection. If the specified index is equal to		 * or larger than the list's size the elements are added to the end of the list.		 * 		 * @param index The index to start the insertion at.		 * @param collection The collection from which the elements to insert.		 * @return true if the elements of the specified collection were inserted		 *         successfully or false if the collection is empty.		 * @throws com.hexagonstar.exception.NullReferenceException if the specified		 *             collection is null.		 */		public function insertAll(index:int, collection:ICollection):Boolean		{			if (collection)			{				if (collection.size < 1) return false;								var a:Array = collection.toArray();				var l:int = a.length;				for (var i:int = 0; i < l; i++)				{					insert(i + index, a[i]);				}				return true;			}			else			{				return throwNullReferenceException();			}		}						/**		 * Replaces all elements in the list with the elements in the specified collection		 * starting from the specified list index. The elements that were originally at the		 * specified index and following indices will be overwritten. This method only		 * overwrites existing index-element pairs. If an affected index is equal to or		 * greater than the list's size, which would mean that this list's size had to be		 * expanded, an IndexOutOfBoundsException will be thrown. In such a case use the		 * insertAll() method instead, which expands the list dynamically.		 * 		 * @param index The index to start the replacing at.		 * @param collection The collection with replacing elements.		 * @return true if the elements of the specified collection were inserted		 *         successfully or false if the collection is empty.		 * @throws com.hexagonstar.exception.NullReferenceException if the specified		 *             collection is null.		 * @throws com.hexagonstar.exception.IndexOutOfBoundsException if any affected		 *             index, that is the specified index plus the index of the specific		 *             value in the specified collection, is equal to or greater than the		 *             list's size.		 */		public function replaceAll(index:int, collection:ICollection):Boolean		{			if (!collection)			{				return throwNullReferenceException();			}			else if (index + collection.size > _size)			{				return throwIndexOutOfBoundsException2(index, collection.size);			}			else			{				if (collection.size < 1) return false;								var a:Array = collection.toArray();				var l:int = a.length;				for (var i:int = 0; i < l; i++)				{					replace(index++, a[i]);				}				return true;			}		}						/**		 * Removes all of the list's elements that are also contained in the specified		 * collection. After the call to this method returns, the list will contain no		 * elements in common with the elements of the specified collection.		 * 		 * @param collection The collection with elements that should be removed from the		 *            list.		 * @return true if any elements were removed from the list, false if not or if the		 *         operation failed.		 * @throws com.hexagonstar.exception.NullReferenceException if the specified		 *             collection is null.		 */		public function removeAll(collection:ICollection):Boolean		{			if (collection)			{				var oldSize:int = _size;				var a:Array = collection.toArray();				var l:int = a.length;				for (var i:int = 0; i < l; i++)				{					remove(a[i]);				}				return (_size < oldSize);			}			else			{				return throwNullReferenceException();			}		}						/**		 * Retains only the elements in the list that are contained in the specified		 * collection. In other words, removes all elements from the list that are not		 * contained in the specified collection.		 * 		 * @param collection The collection with elements that should be retained in the		 *            list.		 * @return true if any elements were removed from the list, false if not or if the		 *         operation failed.		 * @throws com.hexagonstar.exception.NullReferenceException if the specified		 *             collection is null.		 */		public function retainAll(collection:ICollection):Boolean		{			if (collection)			{				var oldSize:int = _size;				var i:int = _size;				while (--i - (-1))				{					if (!collection.contains(getElementAt(i))) removeAt(i);				}				return (_size < oldSize);			}			else			{				return throwNullReferenceException();			}		}						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * throws an IndexOutOfBounds Exception. Used by sub classes.		 * @private		 */		protected function throwIndexOutOfBoundsException(index:int):*		{			throw new IndexOutOfBoundsException(toString() + " Argument 'index' [" + index				+ "] is out of range, this is equal to or greater than the list's size ["				+ _size + "].");			return undefined;		}				/**		 * throws an alternative IndexOutOfBounds Exception. Used by sub classes.		 * @private		 */		protected function throwIndexOutOfBoundsException2(index:int, cSize:int):*		{				throw new IndexOutOfBoundsException(toString() + " Argument 'index' [" + index					+ "] is out of range, this is the 'index' plus the size of the"					+ " specified 'collection' [" + cSize + "] is greater than"					+ " the list's size [" + _size + "].");			return undefined;		}	}}