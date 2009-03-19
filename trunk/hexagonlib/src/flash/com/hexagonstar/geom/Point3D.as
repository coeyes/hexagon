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
package com.hexagonstar.geom
{
	/**
	 * A point class that supports x,y and z coordinates.
	 */
	public class Point3D
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		public var x:Number;
		public var y:Number;
		public var z:Number;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new Point3D instance.
		 * 
		 * @param x The X coordinate of the 3D point.
		 * @param y The Y coordinate of the 3D point.
		 * @param z The Z coordinate of the 3D point.
		 */
		public function Point3D(x:Number = 0, y:Number = 0, z:Number = 0)
		{
			this.x = x;
			this.y = y;
			this.z = z;
		}
	}
}
