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
	 * ExpoEasing class
	 */
	public class ExpoEasing implements IEasing
	{
		private var mPow:Function = Math.pow;
		
		/**
		 * easeIn
		 */
		public function easeIn(t:Number, b:Number, c:Number, d:Number):Number
		{
			return (t == 0) ? b : c * mPow(2, 10 * (t / d - 1)) + b;
		}
		
		
		/**
		 * easeOut
		 */
		public function easeOut(t:Number, b:Number, c:Number, d:Number):Number
		{
			return (t == d) ? b + c : c * (-mPow(2, -10 * t / d) + 1) + b;
		}
		
		
		/**
		 * easeInOut
		 */
		public function easeInOut(t:Number, b:Number, c:Number, d:Number):Number
		{
			if (t == 0) return b;
			if (t == d) return b + c;
			if ((t /= d / 2) < 1) return c / 2 * mPow(2, 10 * (t - 1)) + b;
			return c / 2 * (-mPow(2, -10 * --t) + 2) + b;
		}
	}
}
