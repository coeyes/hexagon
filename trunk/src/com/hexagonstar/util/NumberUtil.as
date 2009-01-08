/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.util{	import com.hexagonstar.data.types.Percent;			/**	 * Provides utility methods for nummeric operations.	 */	public class NumberUtil	{		////////////////////////////////////////////////////////////////////////////////////////		// Constants                                                                          //		////////////////////////////////////////////////////////////////////////////////////////				private static const MATH_RANDOM:Function	= Math.random;		private static const MATH_MIN:Function		= Math.min;		private static const MATH_MAX:Function		= Math.max;		private static const MATH_SQRT:Function		= Math.sqrt;		private static const MATH_POW:Function		= Math.pow;		private static const MATH_ROUND:Function		= Math.round;		private static const MATH_FLOOR:Function		= Math.floor;		private static const MATH_CEIL:Function		= Math.ceil;		private static const LCA_POW:Number			= Math.pow(2.8, 14);		private static const COEFFICIENT1:Number		= Math.PI / 4;						////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				private static var _mr:int = 0;		private static var _date:Date;		private static var _uniqueValues:Vector.<uint>;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Disposes several properties that are used by the class.		 */		public static function dispose():void		{			_date = null;			_uniqueValues = null;		}						/**		 * Generates a random integer. If called without the optional min, max arguments		 * random() returns a pseudo-random integer between 0 and int.MAX_VALUE. If you		 * want a random number between 5 and 15, for example, (inclusive) use random(5, 15).		 * Parameter order is insignificant, the return will always be between the lowest		 * and highest value.		 * 		 * @param min The lowest possible value to return.		 * @param max The highest possible value to return.		 * @param excludedValues A Vector of integers which will NOT be returned.		 * @return A pseudo-random integer between min and max.		 */		public static function random(min:int = 0, max:int = int.MAX_VALUE,			excludedValues:Vector.<int> = null):int		{			if (min == max) return min;						if (excludedValues)			{				excludedValues.sort(Array.NUMERIC);				var result:int;								do				{					if (min < max)						result = min + (MATH_RANDOM() * max);					else						result = max + (MATH_RANDOM() * min);				}				while (excludedValues.indexOf(result) >= 0);				return result;			}			else			{				/* Reverse check */				if (min < max)					return min + (MATH_RANDOM() * max);				else					return max + (MATH_RANDOM() * min);			}		}						/**		 * Generates a small random number between 0 and 65535 using an extremely fast		 * cyclical generator, with an even spread of numbers. After the 65536th call to		 * this function the value resets.		 * 		 * @return A pseudo random value between 0 and 65536 inclusive.		 */		public static function randomFast():int		{			var r:int = _mr;			r++;			r *= 75;			r %= 65537;			r--;			_mr++;			if (_mr == 65536) _mr = 0;			return r;		}						/**		 * Generates a random float (number). If called without the optional min, max		 * arguments randomFloat() returns a peudo-random float between 0 and int.MAX_VALUE.		 * If you want a random number between 5 and 15, for example, (inclusive) use		 * rand(5, 15). Parameter order is insignificant, the return will always be between		 * the lowest and highest value.		 * 		 * @param min The lowest possible value to return.		 * @param max The highest possible value to return.		 * @return A pseudo random number between min and max.		 */		public static function randomFloat(min:Number = 0,			max:Number = int.MAX_VALUE):Number		{			if (min == max)			{				return min;			}			else if (min < max)			{				return min + (MATH_RANDOM() * max);			}			else			{				return max + (MATH_RANDOM() * min);			}		}						/**		 * A more costy method that generates a random number within a specified range.		 * By default the value is rounded to the nearest integer unless the decimals		 * argument is not 0.		 * 		 * @param min the minimum value in the range.		 * @param max the maxium value in the range. If omitted, the minimum value is		 *         used as the maximum, and 0 is used as the minimum.		 * @param decimals the number of decimal places to floor the number to.		 * @return the random number.		 */		public static function randomEven(min:Number, max:Number = 0,			decimals:int = 0):Number		{			/* If the minimum is greater than the maximum, switch the two */			if (min > max)			{				var tmp:Number = min;				min = max;				max = tmp;			}						/* Calculate the range by subtracting the minimum from the maximum.			 * Add 1 times the round to interval to ensure even distribution */			var deltaRange:Number = (max - min) + (1 * decimals);			var iterations:int = MATH_FLOOR((getLCANumber() * 100) / 2) + 1;			var number:Number;						for (var i:int = 0; i < iterations; i++)			{				number = MATH_RANDOM() * deltaRange;			}						/* Add the minimum to the random offset to generate a random number			 * in the correct range */			number += min;						return floor(number, decimals);		}						/**		 * Returns a random number based on the 48-bit Linear Congruential Algorithm.		 * 		 * @param seed the seed that is used to generate the LCA number.		 * @return the LCA number.		 */		public static function getLCANumber(seed:int = 0):Number		{			if (seed == 0) seed = new Date().getTime();			return (((seed & LCA_POW) * 2862933555777941757 + 3037000493) % LCA_POW) / LCA_POW;		}						/**		 * Generates a unique unsigned integer based on the current date in milliseconds.		 * The value is compared to an internal Vector of previous values to guarantee		 * for uniqueness.		 * 		 * @return the unique number.		 */		public static function getUnique():uint		{			if (!_uniqueValues) _uniqueValues = new Vector.<uint>;						/* Create a number based on the current date and time.			 * This will be unique in most cases. */			if (!_date) _date = new Date();			var n:uint = _date.getTime();						/* It is possible that the value may not be unique if it was generated			 * within the same millisecond as a previous number. Therefore, check to			 * make sure. If it is not unique, then generate a random value. */			while (!isUnique(n))			{				n += random(_date.getTime(), (2 * _date.getTime()));			}			_uniqueValues.push(n);						return n;						/* Nested Check Function */			function isUnique(value:uint):Boolean			{				var l:int = _uniqueValues.length;				for (var i:int = 0; i < l; i++)				{					if (_uniqueValues[i] == value) return false;				}				return true;			}		}						/**		 * A faster version of Math.sqrt. Computes and returns the square root of		 * the specified number.		 * 		 * @param val A number greater than or equal to 0.		 * @return If the parameter val is greater than or equal to zero, a number;		 *          otherwise NaN (not a number).		 */		public function sqrt(val:Number):Number		{			if (isNaN(val)) return NaN;			if (val == 0) return 0;						var thres:Number = 0.002;			var b:Number = val * 0.25;			var a:Number;			var c:Number;						do			{				c = val / b;				b = (b + c) * 0.5;				a = b - c;				if (a < 0) a = -a;			}			while (a > thres);						return b;		}						/**		 * A faster (but much less accurate) version of Math.atan2(). For close range/loose		 * comparisons this works very well, but avoid for long-distance or high accuracy		 * simulations.<p>		 * Computes and returns the angle of the point y/x in radians, when measured		 * counterclockwise from a circle's x axis (where 0,0 represents the center of the		 * circle). The return value is between positive pi and negative pi. Note that the		 * first parameter to atan2 is always the y coordinate.		 * 		 * @param y The y coordinate of the point.		 * @param x The x coordinate of the point.		 * @return The angle of the point x/y in radians.		 */		public function atan2(y:Number, x:Number):Number		{			var absY:Number = y;			var coefficient2:Number = 3 * COEFFICIENT1;			var r:Number;			var angle:Number;						if (absY < 0) absY = -absY;			if (x >= 0)			{				r = (x - absY) / (x + absY);				angle = COEFFICIENT1 - COEFFICIENT1 * r;			}			else			{				r = (x + absY) / (absY - x);				angle = coefficient2 - COEFFICIENT1 * r;			}    			return (y < 0) ? -angle : angle;		}						/**		 * Experimental - Much faster version of v % d only for when d is any power of 2.		 * 		 * @param value The amount to divide.		 * @param divisor The divisor, must be a power of 2.		 * @return The remainder.		 */		public function powerOf2Mod(value:uint, divisor:uint):uint		{			return value & (divisor - 1);		}						/**		 * Evaluates val1 and val2 and returns the smaller value. Unlike Math.min this		 * method will return the defined value if the other value is null or not a number.		 * 		 * @param val1 a value to compare.		 * @param val2 a value to compare.		 * @return Returns the smallest value, or the value out of the two that		 *          is defined and valid.		 * 		 * @example		 * <pre>		 *     trace(NumberUtil.min(5, null)); // Traces 5		 *     trace(NumberUtil.min(5, "Hexagon")); // Traces 5		 *     trace(NumberUtil.min(5, 13)); // Traces 5		 * </pre>		 */		public static function min(val1:*, val2:*):Number 		{			if (isNaN(val1) && isNaN(val2) || val1 == null && val2 == null) return NaN;			if (val1 == null || val2 == null) return (val2 == null) ? val1 : val2;			if (isNaN(val1) || isNaN(val2)) return isNaN(val2) ? val1 : val2;			return MATH_MIN(val1, val2);		}						/**		 * Evaluates val1 and val2 and returns the larger value. Unlike Math.max this		 * method will return the defined value if the other value is null or not a number.		 * 		 * @param val1: A value to compare.		 * @param val2: A value to compare.		 * @return Returns the largest value, or the value out of the two that		 *          is defined and valid.		 * 		 * @example		 * <pre>		 *     trace(NumberUtil.max(-5, null)); // Traces -5		 *     trace(NumberUtil.max(-5, "Hexagon")); // Traces -5		 *     trace(NumberUtil.max(-5, -13)); // Traces -5		 * </pre>		 */		public static function max(val1:*, val2:*):Number 		{			if (isNaN(val1) && isNaN(val2) || val1 == null && val2 == null) return NaN;			if (val1 == null || val2 == null) return (val2 == null) ? val1 : val2;			if (isNaN(val1) || isNaN(val2)) return (isNaN(val2)) ? val1 : val2;			return MATH_MAX(val1, val2);		}						/**		 * Determines if the specified number is even.		 *		 * @param value aA number to determine if it is divisible by 2.		 * @return true if the number is even; otherwise false.		 * 		 * @example		 * <pre>		 *     trace(NumberUtil.isEven(7)); // Traces false		 *     trace(NumberUtil.isEven(12)); // Traces true		 * </pre>		 */		public static function isEven(value:Number):Boolean 		{			return (value & 1) == 0;		}						/**		 * Determines if the specified number is odd.		 * 		 * @param value a number to determine if it is not divisible by 2.		 * @return Returns true if the number is odd; otherwise false.		 * 		 * @example		 * <pre>		 *     trace(NumberUtil.isOdd(7)); // Traces true		 *     trace(NumberUtil.isOdd(12)); // Traces false		 * </pre>		 */		public static function isOdd(value:Number):Boolean 		{			return !isEven(value);		}						/**		 * Determines if the specified number is an integer.		 * 		 * @param value a number to determine if it contains no decimal values.		 * @return Returns true if the number is an integer; otherwise false.		 * 		 * @example		 * <pre>		 *     trace(NumberUtil.isInteger(13)); // Traces true		 *     trace(NumberUtil.isInteger(1.2345)); // Traces false		 * </pre>		 */		public static function isInteger(value:Number):Boolean 		{			return (value % 1) == 0;		}						/**		 * Checks if the specified number is an unsigned integer, i.e. a		 * number that is 0 or positive and has no decimal places.		 *		 * @param number the number to check.		 * @return true if the number is unsigned otherwise false.		 */			public static function isUnsignedInteger(value:Number):Boolean		{			return (value >= 0 && value % 1 == 0);		}						/**		 * Checks if the specified number is a prime. A prime number is a positive		 * integer that has no positive integer divisors other than 1 and itself.		 * 		 * @param value a number to determine if it is only divisible by 1 and itself.		 * @return true if the number is prime; otherwise false.		 * 		 * @example		 * <pre>		 *     trace(NumberUtil.isPrime(13)); // Traces true		 *     trace(NumberUtil.isPrime(4)); // Traces false		 * </pre>		 */		public static function isPrime(value:Number):Boolean 		{			if (value == 1 || value == 2) return true;			if (isEven(value)) return false;						var s:Number = MATH_SQRT(value);			for (var i:int = 3; i <= s; i++)			{				if (value % i == 0) return false;			}						return true;		}						/**		 * Calculates the factorial of the specified value. A factorial is the		 * total of an integer when multiplied by all lower positive integers.		 *		 * @param value the number to calculate the factorial of.		 * @return the factorial of the number.		 */		public static function getFactorial(value:int):Number		{			if (value == 0) return 1;			var d:Number = value.valueOf();			var i:Number = d - 1;			while (i)			{				d = d * i;				i--;			}			return d;		}						/**		 * Returns a Vector with all divisors of the specified value.		 * 		 * @param value the number from which to return the divisors of.		 * @return a Vector that contains the divisors of number.		 */		public static function getDivisors(value:int):Vector.<Number>		{			var v:Vector.<Number> = new Vector.<Number>();			var e:Number = value / 2;			for (var i:uint = 1; i <= e; i++)			{				if (value % i == 0) v.push(i);			}			if (value != 0) v.push(value.valueOf());			return v;		}						/**		 * Rounds the specified value. By default the value is rounded to the nearest		 * integer. Specifying a decimals parameter allows to round to the nearest of a		 * specified interval.		 * 		 * @param value the number to round.		 * @param decimals the number of decimal places to round the number.		 * @return the number rounded to the nearest interval.		 * @example		 * <pre>		 *     trace(NumberUtil.round(3.14159, 2)); // Traces 3.14		 *     trace(NumberUtil.round(3.14159, 3)); // Traces 3.142		 * </pre>		 */		public static function round(value:Number, decimals:int = 0):Number		{			var p:Number = MATH_POW(10, decimals);			return MATH_ROUND(value * p) / p;		}						/**		 * Returns the floor part of the specified value. By default the integer part		 * of the number is returned just as if calling Math.floor(). However, by		 * a decimals argument, non-integer floor parts to the nearest of the specified		 * decimals interval can be returned.		 * 		 * @param value the number for which the floor part should be returned.		 * @param decimals the number of decimal places to get the floor part of the number.		 * @return the floor part of the number.		 */		public static function floor(value:Number, decimals:int = 0):Number		{			var p:Number = MATH_POW(10, decimals);			return MATH_FLOOR(value * p) / p;		}						/**		 * Returns the ceiling part of the specified value. By default the next highested		 * integer number is returned just as if calling Math.ceil(). However, by specifying		 * a decimals argument, non-integer ceiling parts to the nearest of the specified		 * decimals interval can be returned.		 * 		 * @param value the number for which the ceiling part should be returned.		 * @param decimals the number of decimal places to get the ceiling part of the number.		 * @return the ceiling part of the number.		 */		public static function ceil(value:Number, decimals:int = 0):Number		{			var p:Number = MATH_POW(10, decimals);			return MATH_CEIL(value * p) / p;		}						/**		 * Determines if the specified value is included within a range. The range		 * values do not need to be in order.		 *		 * @param value Number to determine if it is included in the range.		 * @param start First value of the range.		 * @param end Second value of the range.		 * @return true if the number falls within the range; otherwise false.		 * 		 * @example		 * <pre>		 *     trace(NumberUtil.isBetween(3, 0, 5)); // Traces true		 *     trace(NumberUtil.isBetween(7, 0, 5)); // Traces false		 * </pre>		 */		public static function isBetween(value:Number, start:Number, end:Number):Boolean 		{			return !(value < MATH_MIN(start, end) || value > MATH_MAX(start, end));		}						/**		 * Determines if the specified value falls within a range; if not it is snapped		 * to the nearest range value. The constraint values do not need to be in order.		 * 		 * @param value Number to determine if it is included in the range.		 * @param start First value of the range.		 * @param end Second value of the range.		 * @return Returns either the number as passed, or its value once snapped to		 *          the nearest range value.		 * 		 * @example		 * <pre>		 *     trace(NumberUtil.constrain(3, 0, 5)); // Traces 3		 *     trace(NumberUtil.constrain(7, 0, 5)); // Traces 5		 * </pre>		 */		public static function constrain(value:Number, start:Number, end:Number):Number 		{			return MATH_MIN(MATH_MAX(value, MATH_MIN(start, end)), MATH_MAX(start, end));		}						/**		 * Determines a value between two specified values.		 * 		 * @param amount The level of interpolation between the two values. If 0,		 *         begin value is returned; if 100, end value is returned.		 * @param min The lower value.		 * @param max The upper value.		 * 		 * @example		 * <pre>		 *     trace(NumberUtil.interpolate(new Percent(0.5), 0, 10)); // Traces 5		 * </pre>		 */		public static function interpolate(amount:Percent, min:Number, max:Number):Number 		{			return min + (max - min) * amount.decimalPercentage;		}						/**		 * Determines a percentage of a value in a given range.		 *		 * @param value The value to be converted.		 * @param min The lower value of the range.		 * @param max The upper value of the range.		 * 		 * @example		 * <pre>		 *     trace(NumberUtil.normalize(8, 4, 20).decimalPercentage); // Traces 0.25		 * </pre>		 */		public static function normalize(value:Number, min:Number, max:Number):Percent 		{			return new Percent((value - min) / (max - min));		}						/**		 * Maps a value from one coordinate space to another.		 * 		 * @param value Value from the input coordinate space to map to the output		 *         coordinate space.		 * @param min1 Starting value of the input coordinate space.		 * @param max1 Ending value of the input coordinate space.		 * @param min2 Starting value of the output coordinate space.		 * @param max2 Ending value of the output coordinate space.		 * 		 * @example		 * <pre>		 *     trace(NumberUtil.map(0.75, 0, 1, 0, 100)); // Traces 75		 * </pre>		 */		public static function map(value:Number, min1:Number, max1:Number, min2:Number,			max2:Number):Number 		{			return interpolate(normalize(value, min1, max1), min2, max2);		}						/**		 * Creates a Vector of evenly spaced numerical increments between two numbers.		 * 		 * @param start The starting value.		 * @param end The ending value.		 * @param steps The number of increments between the starting and ending values.		 * @return Returns a Vector composed of the increments between the two values.		 * 		 * @example		 * <pre>		 *     trace(NumberUtil.createStepsBetween(0, 5, 4)); // Traces 1,2,3,4		 *     trace(NumberUtil.createStepsBetween(1, 3, 3)); // Traces 1.5,2,2.5		 * </pre>		 */		public static function createStepsBetween(start:Number, end:Number,			steps:Number):Vector.<Number>		{			steps++;						var i:int = 0;			var v:Vector.<Number> = new Vector.<Number>();			var increment:Number = (end - start) / steps;						while (++i < steps)			{				v.push((i * increment) + start);			}						return v;		}						/**		 * Formats a number.		 * 		 * @param value The number you wish to format.		 * @param minLength The minimum length of the number.		 * @param delimChar The character used to seperate thousands.		 * @param fillChar The leading character used to make the number the minimum length.		 * @return Returns the formated number as a String.		 * 		 * @example		 * <pre>		 *     trace(NumberUtil.format(1234567, 8, ",")); // Traces 01,234,567		 * </pre>		 */		public static function format(value:Number, minLength:int,			delimChar:String = null, fillChar:String = null):String		{			var n:String = value.toString();			var l:int = n.length;						if (delimChar != null)			{				var numSplit:Array = n.split("");				var c:int = 3;				var i:int = numSplit.length;								while (--i > 0)				{					c--;					if (c == 0) 					{						c = 3;						numSplit.splice(i, 0, delimChar);					}				}								n = numSplit.join("");			}						if (minLength != 0)			{				if (l < minLength) 				{					minLength -= l;					var addChar:String = (fillChar == null) ? "0" : fillChar;										while (minLength--)					{						n = addChar + n;					}				}			}						return n;		}						/**		 * Finds the English ordinal suffix for the number given.		 * 		 * @param value Number to find the ordinal suffix of.		 * @return Returns the suffix for the number, 2 characters.		 * 		 * @example		 * <pre>		 *     trace(32 + NumberUtil.getOrdinalSuffix(32)); // Traces 32nd		 * </pre>		 */		public static function getOrdinalSuffix(value:int):String 		{			if (value >= 10 && value <= 20) return "th";			switch (value % 10)			{				case 0:				case 4:				case 5:				case 6:				case 7:				case 8:				case 9:					return "th";				case 3:					return "rd";				case 2:					return "nd";				case 1:					return "st";				default:					return "";			}		}						/**		 * Adds leading zeroes in front of the specified value up the amount specified		 * by the digits parameter.		 * 		 * @param value Number to add leading zeroes.		 * @param digits determines the amount of digits that the number must have to still		 *         get leading zeroes.		 * @return the Number as a String.		 * 		 * @example		 * <pre>		 *     trace(NumberUtil.addLeadingZeroes(7, 3)); // Traces 007		 *     trace(NumberUtil.addLeadingZeroes(10, 4)); // Traces 0010		 * </pre>		 */		public static function addLeadingZeroes(value:Number, digits:int = 4):String 		{			var s:String = value.toString();			var l:int = s.length;			var z:String = "";						if (l >= digits) return s;						digits -= l;			for (var i:int = 0; i < digits; i++)			{				z += "0";			}						return z + s;		}	}}