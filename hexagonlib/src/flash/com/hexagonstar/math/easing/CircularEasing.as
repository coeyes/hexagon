/*
 * hexagon framework - Multi-Purpose ActionScript 3 Framework.
 * Copyright (C) 2007 Hexagon Star Softworks
 *       __    __
 *    __/  \__/  \__    __
 *   /  \__/HEXAGON \__/  \
 *   \__/  \__/ FRAMEWORK_/
 *            \__/  \__/
 *
 * ``The contents of this file are subject to the Mozilla Public License
 * Version 1.1 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 * License for the specific language governing rights and limitations
 * under the License.
 */
package com.hexagonstar.math.easing
{
	/**
	 * CircularEasing class
	 */
	public class CircularEasing implements IEasing
	{
		private var mSqrt:Function = Math.sqrt;
		
		
		/**
		 * easeIn
		 */
		public function easeIn(t:Number, b:Number, c:Number, d:Number):Number
		{
			return -c * (mSqrt(1 - (t /= d) * t) - 1) + b;
		}
		
		
		/**
		 * easeOut
		 */
		public function easeOut(t:Number, b:Number, c:Number, d:Number):Number
		{
			return c * mSqrt(1 - (t = t / d - 1) * t) + b;
		}
		
		
		/**
		 * easeInOut
		 */
		public function easeInOut(t:Number, b:Number, c:Number, d:Number):Number
		{
			if ((t /= d / 2) < 1) return -c / 2 * (mSqrt(1 - t * t) - 1) + b;
			return c / 2 * (mSqrt(1 - (t -= 2) * t) + 1) + b;
		}
	}
}
