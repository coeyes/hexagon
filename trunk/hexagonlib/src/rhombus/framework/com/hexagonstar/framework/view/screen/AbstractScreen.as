/* * rhombus - Application framework for web/desktop-based Flash & Flex projects. *  *  /\ RHOMBUS *  \/ FRAMEWORK *  * Licensed under the MIT License * Copyright (c) 2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.framework.view.screen{	import com.hexagonstar.display.StageReference;	import com.hexagonstar.event.CommandEvent;	import com.hexagonstar.framework.event.ScreenEvent;	import com.hexagonstar.framework.util.Log;	import com.hexagonstar.framework.view.display.AbstractDisplay;	import flash.display.DisplayObject;	import flash.display.Stage;		/**	 * AbstractScreen Class	 * 	 * @author Sascha Balkau	 * @version 0.9.0	 */	public class AbstractScreen extends AbstractDisplay implements IScreen	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				/** @private */		protected static var _stage:Stage;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new AbstractScreen instance.		 */		public function AbstractScreen()		{			super();			_stage = StageReference.stage;		}						/**		 * load		 */		public function load():void		{			onScreenAssetsLoadComplete(null);		}						/**		 * dispose		 */		override public function dispose():void		{			super.dispose();			unload();		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @private		 */		protected function onScreenAssetsLoadComplete(e:CommandEvent):void		{			setup();		}						/**		 * @private		 */		protected function onScreenAssetsLoadError(e:CommandEvent):void		{			/* Only log error message (If we'd call setup here too, shit would			 * start to hit the fan!) */			Log.error(toString() + " Error loading screen assets: " + e.message);		}						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @private		 */		override protected function setup():void		{			super.setup();			dispatchEvent(new ScreenEvent(ScreenEvent.CREATED, this));		}						/**		 * unload		 * @private		 */		protected function unload():void		{			/* Abstract method! */		}						/**		 * Calculates and returns the horizontal center of the specified display		 * object in regard to the application stage.		 * @private		 * 		 * @param d The display object for which to calculate the horizontal center.		 * @return The horizontal center of d.		 */		protected static function horizontalCenter(d:DisplayObject):Number		{			return Math.round((_stage.stageWidth / 2) - (d.width / 2));		}						/**		 * Calculates and returns the vertical center of the specified display		 * object in regard to the application stage.		 * @private		 * 		 * @param d The display object for which to calculate the vertical center.		 * @return The vertical center of d.		 */		protected static function verticalCenter(d:DisplayObject):Number		{			return Math.round((_stage.stageHeight / 2) - (d.height / 2));		}	}}