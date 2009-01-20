/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.data.types{	/**	 * Represents a list of strings which are seperated into columns. When creating	 * a new ColumnText you specify the number of columns that the ColumnText should	 * have and then you add as many strings as there are columns with the add() method.	 * The ColumnText class cares about adding spacing to any strings so that they can	 * be easily read in a tabular format. A fixed width font is recommended for the	 * use of the output. The toString() method returns the formatted text result.	 */	public class ColumnText	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				protected var _columns:Vector.<Array>;		protected var _lengths:Vector.<int>;		protected var _div:String;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new ColumnText instance.		 * 		 * @param columns the number of columns that the ColumnText should have.		 * @param div The String that is used to divide columns visually.		 */		public function ColumnText(columns:int, div:String = " ")		{			if (columns < 1) columns = 1;						_div = div;						_columns = new Vector.<Array>(columns, true);			_lengths = new Vector.<int>(columns, true);						for (var i:int = 0; i < columns; i++)			{				_columns[i] = [];				_lengths[i] = 0;			}		}						/**		 * Adds a number of Strings to the ColumnText.		 * 		 * @param strings A number of strings to add. Every string is part of a		 *         column. If there are more strings specified than the ColumnText		 *         has columns, they are ignored.		 */		public function add(...strings):void		{			var l:int = strings.length;			if (l > _columns.length) l = _columns.length;						for (var i:int = 0; i < l; i++)			{				var s:String = strings[i];				_columns[i].push(s);				if (s.length > _lengths[i]) _lengths[i] = s.length;			}		}						/**		 * Returns a String Representation of the ColumnText.		 * 		 * @return A String Representation of the ColumnText.		 */		public function toString():String		{			var result:String = "";			var cols:int = _columns.length;			var rows:int = _columns[0].length;			var c:int;			var r:int;						/* Process columns */			for (c = 0; c < cols - 1; c++)			{				var col:Array = _columns[c];				var maxLen:int = _lengths[c];								for (r = 0; r < rows; r++)				{					var s:String = col[r];					if (s.length < maxLen) col[r] = pad(s, maxLen);				}			}						/* Combine rows */			for (r = 0; r < rows; r++)			{				var row:String = "";				for (c = 0; c < cols; c++)				{					row += _columns[c][r];					/* Last column does not need a following divider */					if (c < cols - 1) row += _div;				}				result += row + "\n";			}						return result;		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				public function get text():String		{			return toString();		}						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////						/**		 * sort		 * @private		 *///		protected function sort():void//		{//			var a:Array = _columns[0];//			var srt:Array = a.sort(Array.RETURNINDEXEDARRAY | Array.CASEINSENSITIVE);//			Debug.traceObj(a);//			Debug.traceObj(srt);//			//			for (var c:int = 0; c < _columns.length; c++)//			{//				var col:Array = _columns[c];//				var tmp:Array = new Array(col.length);//				for (var j:int = 0; j < col.length; j++)//				{//					var s:String = col[j];//					var i:int = srt[j];//					tmp[i] = s;//				}//				Debug.traceObj(tmp);//			}//		}				/**		 * Adds whitespace padding to the specified string.		 * @private		 */		protected function pad(s:String, maxLen:int):String		{			var l:int = maxLen - s.length;			for (var i:int = 0; i < l; i++)			{				s += " ";			}						return s;		}	}}