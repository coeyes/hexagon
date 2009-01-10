/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.geom{	/**	 * Degree represents an angle in degree units.	 */	public class Degree implements IAngle	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				protected var _degree:Number;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new Degree instance.		 * 		 * @param degree The angle in degree units.		 */		public function Degree(degree:Number)		{			_degree = degree;		}						/**		 * Returns the angle in radian units.		 * 		 * @return The angle in radian units.		 */		public function toRadian():Number		{			return (_degree / 180) * Math.PI;		}						/**		 * Returns the angle in degree units.		 * 		 * @return The angle in degree units.		 */		public function toDegree():Number		{			return _degree;		}						/**		 * Returns the angle value in degree as a Number.		 * 		 * @return The angle value in degree as a Number.		 */		public function valueOf():Number		{			return _degree;		}						/**		 * Returns the angle value in degree as a String.		 * 		 * @return The angle value in degree as a String.		 */		public function toString():String		{			return _degree.toString();		}	}}