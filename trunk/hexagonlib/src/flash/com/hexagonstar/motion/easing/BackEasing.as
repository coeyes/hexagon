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
package com.hexagonstar.motion.easing
{
	/**
	 * BackEasing class
	 * 
	 * @author Sascha Balkau
	 * @version 1.0.0
	 */
	public class BackEasing implements IEasing
	{
		/** @private */
		private var s:Number = 1.70158;
		
		
		/**
		 * easeIn
		 */
		public function easeIn(t:Number, b:Number, c:Number, d:Number):Number
		{
			return c * (t /= d) * t * ((s + 1) * t - s) + b;
		}
		
		
		/**
		 * easeOut
		 */
		public function easeOut(t:Number, b:Number, c:Number, d:Number):Number
		{
			return c * ((t = t / d - 1) * t * ((s + 1) * t + s) + 1) + b;
		}
		
		
		/**
		 * easeInOut
		 */
		public function easeInOut(t:Number, b:Number, c:Number, d:Number):Number
		{
			if ((t /= d / 2) < 1) return c / 2 * (t * t * (((s *= (1.525)) + 1) * t - s)) + b;
			return c / 2 * ((t -= 2) * t * (((s *= (1.525)) + 1) * t + s) + 2) + b;
		}
	}
}
