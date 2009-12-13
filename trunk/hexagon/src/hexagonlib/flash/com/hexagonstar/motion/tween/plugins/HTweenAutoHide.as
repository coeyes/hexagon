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
 * Copyright (c) 2007 Sascha Balkau / Hexagon Star Softworks
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
package com.hexagonstar.motion.tween.plugins 
{
	import com.hexagonstar.motion.tween.HTween;

	
	/**
	 * Plugin for GTween. Sets the visible of the target to false if its alpha is 0 or
	 * less. <br/>
	 * <br/>
	 * Supports the following <code>pluginData</code> properties:
	 * <UL>
	 * <LI>autoHideEnabled: overrides the enabled property for the plugin on a per tween
	 * basis.
	 * </UL>
	 */
	public class HTweenAutoHide implements IHTweenPlugin 
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Specifies whether this plugin is enabled for all tweens by default.
		 */
		public static var enabled:Boolean = true;
		
		/** @private */
		protected static var _instance:HTweenAutoHide;
		/** @private */
		protected static var _tweenProperties:Array = ["alpha"];
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Installs this plugin for use with all GTween instances.
		 */
		public static function install():void
		{
			if (_instance) return;
			_instance = new HTweenAutoHide();
			HTween.installPlugin(_instance, _tweenProperties);
		}
		
		
		/**
		 * @private
		 * 
		 * @param tween
		 * @param name
		 * @param value
		 * @return Number
		 */
		public function init(tween:HTween, name:String, value:Number):Number
		{
			return value;
		}
		
		
		/**
		 * @private
		 * 
		 * @param tween
		 * @param name
		 * @param value
		 * @param initValue
		 * @param rangeValue
		 * @param ratio
		 * @param end
		 * @return Number
		 */
		public function tween(tween:HTween,
								 name:String,
								 value:Number,
								 initValue:Number,
								 rangeValue:Number,
								 ratio:Number,
								 end:Boolean):Number
		{
			/* only change the visibility if the plugin is enabled */
			if (((tween.pluginData.autoHideEnabled == null && enabled)
				|| tween.pluginData.autoHideEnabled))
			{
				if (tween.target.visible != (value > 0))
				{
					tween.target.visible = (value > 0);
				}
			}
			return value;
		}
	}
}
