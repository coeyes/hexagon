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
	 * ElasticEasing class
	 */
	public class ElasticEasing implements IEasing
	{
		private var p:Number = NaN;
		private var a:Number = NaN;
		private var s:Number = NaN;
		private var mAbs:Function = Math.abs;
		private var mAsin:Function = Math.asin;
		private var mSin:Function = Math.sin;
		private var mPow:Function = Math.pow;
		private var mPI:Number = Math.PI;
		
		/**
		 * easeIn
		 */
		public function easeIn(t:Number, b:Number, c:Number, d:Number):Number
		{
			if (t == 0) return b;
			if ((t /= d) == 1) return b + c;
			if (isNaN(p)) p = d * .3;
			if (isNaN(a) || a < mAbs(c)) {a = c; s = p / 4;}
			else s = p / (2 * mPI) * mAsin(c / a);
			return -(a * mPow(2, 10 * (t -= 1)) * mSin((t * d - s) * (2 * mPI) / p)) + b;
		}
		
		
		/**
		 * easeOut
		 */
		public function easeOut(t:Number, b:Number, c:Number, d:Number):Number
		{
			if (t == 0) return b;
			if ((t /= d) == 1) return b + c;
			if (isNaN(p)) p = d * .3;
			if (isNaN(a) || a < mAbs(c)) {a = c; s = p / 4;}
			else s = p / (2 * mPI) * mAsin(c / a);
			return (a * mPow(2, -10 * t) * mSin((t * d - s) * (2 * mPI) / p) + c + b);
		}
		
		
		/**
		 * easeInOut
		 */
		public function easeInOut(t:Number, b:Number, c:Number, d:Number):Number
		{
			if (t == 0) return b;
			if ((t /= d / 2) == 2) return b + c;
			if (isNaN(p)) p = d * .465;
			if (isNaN(a) || a < mAbs(c)) {a = c; s = p / 4;}
			else s = p / (2 * mPI) * mAsin(c / a);
			if (t < 1) return -.5 * (a * mPow(2, 10 * (t -= 1)) * mSin((t * d - s) * (2 * mPI) / p)) + b;
			return a * mPow(2, -10 * (t -= 1)) * mSin((t * d - s) * (2 * mPI) / p) * .5 + c + b;
		}
	}
}
