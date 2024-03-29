/*
 * tetragonlib - ActionScript 3 Game Library.
 *    ____
 *   /    / TETRAGON
 *  /____/  LIBRARY
 * 
 * Licensed under the MIT License
 * 
 * Copyright (c) 2009 Sascha Balkau / Hexagon Star Softworks
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
package com.hexagonstar.game.tile.ds
{

	
	/**
	 * A two-dimensional array.
	 */
	public class TileGrid
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		// TODO change to int Vector!
		private var _a:Vector.<int>;
		private var _w:int, _h:int;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Initializes a two-dimensional array to match a given width and
		 * height. The smallest possible size is a 1x1 matrix. The initial value
		 * of all elements is null.
		 * 
		 * @param w The width  (equals number of colums).
		 * @param h The height (equals number of rows).
		 */
		public function TileGrid(w:int, h:int)
		{
			if (w < 1 || h < 1)
			{
				throw new Error("illegal size");
			}
			
			_w = w;
			_h = h;
			
			clear();
		}
		
		
		/**
		 * Writes a given value into each cell of the two-dimensional array. If
		 * the obj parameter if of type Class, the method creates individual
		 * instances of this class for all array cells.
		 * 
		 * @param item The item to be written into each cell.
		 */
		public function fill(value:int):void
		{
			var l:int = _w * _h;
			for (var i:int = 0; i < l; i++)
			{
				_a[i] = value;
			}
		}
		
		
		/**
		 * Reads a value from a given x/y index. No boundary check is done, so
		 * you have to make sure that the input coordinates do not exceed the
		 * width or height of the two-dimensional array.
		 *
		 * @param x The x index (column).
		 * @param y The y index (row).
		 * 
		 * @return The value at the given x/y index.
		 */
		public function getCell(x:int, y:int):int
		{
			return _a[int(y * _w + x)];
		}
		
		
		/**
		 * Writes a value into a cell at the given x/y index. Because of
		 * performance reasons no boundary check is done, so you have to make
		 * sure that the input coordinates do not exceed the width or height of
		 * the two-dimensional array.
		 *
		 * @param x   The x index (column).
		 * @param y   The y index (row).
		 * @param obj The item to be written into the cell.
		 */
		public function setCell(x:int, y:int, value:int):void
		{
			_a[int(y * _w + x)] = value;
		}
		
		
		/**
		 * Resizes the array to match the given width and height. If the new
		 * size is smaller than the existing size, values are lost because of
		 * truncation, otherwise all values are preserved. The minimum size
		 * is a 1x1 matrix.
		 * 
		 * @param w The new width (cols).
		 * @param h The new height (rows).
		 */
		public function resize(w:int, h:int):void
		{
			if (w < 1 || h < 1)
			{
				throw new Error("illegal size");
			}
			
			var copy:Vector.<int> = _a.concat();
			
			_a.length = 0;
			_a.length = w * h;
			
			var minx:int = w < _w ? w : _w;
			var miny:int = h < _h ? h : _h;
			
			var x:int, y:int, t1:int, t2:int;
			for (y = 0; y < miny; y++)
			{
				t1 = y * w;
				t2 = y * _w;
				
				for (x = 0; x < minx; x++)
				{
					_a[int(t1 + x)] = copy[int(t2 + x)];
				}
			}
			
			_w = w;
			_h = h;
		}
		
		
		/**
		 * Extracts a row from a given index.
		 * 
		 * @param y The row index.
		 * 
		 * @return An array storing the values of the row.
		 */
		public function getRow(y:int):Vector.<int>
		{
			var offset:int = y * _w;
			return _a.slice(offset, offset + _w);
		}
		
		
		/**
		 * Inserts new values into a complete row of the two-dimensional array. 
		 * The new row is truncated if it exceeds the existing width.
		 *
		 * @param y The row index.
		 * @param a The row's new values.
		 */
		public function setRow(y:int, a:Vector.<int>):void
		{
			if (y < 0 || y > _h) throw new Error("row index out of bounds");
			
			var offset:int = y * _w;
			for (var x:int = 0; x < _w; x++)
			{
				_a[int(offset + x)] = a[x];	
			}
		}
		
		
		/**
		 * Extracts a column from a given index.
		 * 
		 * @param x The column index.
		 * 
		 * @return An array storing the values of the column.
		 */
		public function getCol(x:int):Vector.<int>
		{
			var t:Vector.<int> = new Vector.<int>();
			for (var i:int = 0; i < _h; i++)
			{
				t[i] = _a[int(i * _w + x)];
			}
			return t;
		}
		
		
		/**
		 * Inserts new values into a complete column of the two-dimensional
		 * array. The new column is truncated if it exceeds the existing height.
		 *
		 * @param x The column index.
		 * @param a The column's new values.
		 */
		public function setCol(x:int, a:Vector.<int>):void
		{
			if (x < 0 || x > _w) throw new Error("column index out of bounds");
			
			for (var y:int = 0; y < _h; y++)
			{
				_a[int(y * _w + x)] = a[y];	
			}
		}
		
		
		/**
		 * Shifts all columns by one column to the left. Columns are wrapped,
		 * so the column at index 0 is not lost but appended to the rightmost
		 * column.
		 */
		public function shiftLeft():void
		{
			if (_w == 1) return;
			
			var j:int = _w - 1, k:int;
			for (var i:int = 0; i < _h; i++)
			{
				k = i * _w + j;
				_a.splice(k, 0, _a.splice(k - j, 1));
			}
		}
		
		
		/**
		 * Shifts all columns by one column to the right. Columns are wrapped,
		 * so the column at the last index is not lost but appended to the
		 * leftmost column.
		 */
		public function shiftRight():void
		{
			if (_w == 1) return;
			
			var j:int = _w - 1, k:int;
			for (var i:int = 0; i < _h; i++)
			{
				k = i * _w + j;
				_a.splice(k - j, 0, _a.splice(k, 1));
			}
		}
		
		
		/**
		 * Shifts all rows up by one row. Rows are wrapped, so the first row
		 * is not lost but appended to bottommost row.
		 */
		public function shiftUp():void
		{
			if (_h == 1) return;
			
			_a = _a.concat(_a.slice(0, _w));
			_a.splice(0, _w);
		}
		
		
		/**
		 * Shifts all rows down by one row. Rows are wrapped, so the last row
		 * is not lost but appended to the topmost row.
		 */
		public function shiftDown():void
		{
			if (_h == 1) return;
			
			var offset:int = (_h - 1) * _w;
			_a = _a.slice(offset, offset + _w).concat(_a);
			_a.splice(_h * _w, _w);
		}
		
		
		/**
		 * Appends a new row. If the new row doesn't match the current width,
		 * the inserted row gets truncated or widened to match the existing
		 * width.
		 *
		 * @param a The row to append.
		 */
		public function appendRow(a:Vector.<int>):void
		{
			a.length = _w;
			_a = _a.concat(a);
			_h++;
		}
		
		
		/**
		 * Prepends a new row. If the new row doesn't match the current width,
		 * the inserted row gets truncated or widened to match the existing
		 * width.
		 *
		 * @param a The row to prepend.
		 */
		public function prependRow(a:Vector.<int>):void
		{
			a.length = _w;
			_a = a.concat(_a);
			_h++;
		}
		
		
		/**
		 * Appends a new column. If the new column doesn't match the current
		 * height, the inserted column gets truncated or widened to match the
		 * existing height.
		 *
		 * @param a The column to append.
		 */
		public function appendCol(a:Vector.<int>):void
		{
			a.length = _h;
			for (var y:int = 0; y < _h; y++)
			{
				_a.splice(y * _w + _w + y, 0, a[y]);
			}
			_w++;
		}
		
		
		/**
		 * Prepends a new column. If the new column doesn't match the current
		 * height, the inserted column gets truncated or widened to match the
		 * existing height.
		 *
		 * @param a The column to prepend.
		 */
		public function prependCol(a:Vector.<int>):void
		{	
			a.length = _h;
			for (var y:int = 0; y < _h; y++)
			{
				_a.splice(y * _w + y, 0, a[y]);
			}
			_w++;
		}

		
		/**
		 * Flips rows with cols and vice versa.
		 */
		public function transpose():void
		{
			var a:Vector.<int> = _a.concat();
			for (var y:int = 0; y < _h; y++)
			{
				for (var x:int = 0; x < _w; x++)
				{
					_a[int(x * _w + y)] = a[int(y * _w + x)];
				}
			}
		}
		
		
		/**
		 * Grants access to the the linear array which is used internally to
		 * store the data in the two-dimensional array. Use with care for
		 * advanced operations.
		 */
		public function getVector():Vector.<int>
		{
			return _a;
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function contains(value:int):Boolean
		{
			var k:int = size;
			for (var i:int = 0;i < k; i++)
			{
				if (_a[i] === value)
					return true;
			}
			return false;
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function clear():void
		{
			_a = new Vector.<int>(size, true);
			fill(0);
		}

		
		/**
		 * fromArray
		 */
		public function fromArray(source:Array):void
		{
			_h = source.length;
			_w = (source[0] as Array).length;
			
			clear();
			
			for (var y:int = 0; y < _h; y++)
			{
				var row:Array = source[y];
				for (var x:int = 0; x < _w; x++)
				{
					setCell(x, y, row[x]);
				}
			}
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function toArray():Array
		{
			// TODO
			//var a:Array = _a.concat();
			//
			//var k:int = size;
			//if (a.length > k) a.length = k;
			//return a;
			return null;
		}

		
		/**
		 * Prints out a string representing the current object.
		 * 
		 * @return A string representing the current object.
		 */
		public function toString():String
		{
			return "[TileGrid, width=" + width + ", height=" + height + "]";
		}

		
		/**
		 * Prints out all elements (for debug/demo purposes).
		 * 
		 * @return A human-readable representation of the structure.
		 */
		public function dump():String
		{
			var s:String = "TileGrid\n{";
			var offset:int, value:*;
			for (var y:int = 0; y < _h; y++)
			{
				s += "\n" + "\t";
				offset = y * _w;
				for (var x:int = 0; x < _w; x++)
				{
					value = _a[int(offset + x)];
					s += "[" + (value != undefined ? value : "?") + "]";
				}
			}
			s += "\n}";
			return s;
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Indicates the width (colums).
		 * If a new width is set, the two-dimensional array is resized
		 * accordingly. The minimum value is 2.
		 */
		public function get width():int
		{
			return _w;
		}
		public function set width(v:int):void
		{
			resize(v, _h);
		}

		
		/**
		 * Indicates the height (rows).
		 * If a new height is set, the two-dimensional array is resized
		 * accordingly. The minimum value is 2.
		 */
		public function get height():int
		{
			return _h;
		}
		public function set height(v:int):void
		{
			resize(_w, v);
		}

		
		/**
		 * @inheritDoc
		 */
		public function get size():int
		{
			return _w * _h;
		}
	}
}
