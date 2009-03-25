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
package com.hexagonstar.flex.containers
{
	import mx.controls.Button;
	
	import flash.events.Event;
	import flash.events.MouseEvent;	

	
	/**
	 * OneButtonWindow Class
	 */
	public class OneButtonWindow extends BasicWindow
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		
		public static const OK_BUTTON:String = "okButton";
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		protected var _okButton:Button;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new OneButtonWindow instance.
		 */
		public function OneButtonWindow()
		{
			super();
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Sets the label text of the window's OK Button.
		 * @param text the label text for the OK button.
		 */
		public function set okButtonLabel(v:String):void
		{
			_okButton.label = v;
		}
		
		public function get okButtonLabel():String
		{
			return _okButton.label;
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Event Handlers                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Called when the OK button was pressed.
		 */
		protected function onOkButton(e:MouseEvent):void
		{
			dispatchEvent(new Event(OK_BUTTON));
			close();
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * createChildren
		 * @private
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			_okButton = new Button();
			_okButton.label = "OK";
			_okButton.addEventListener(MouseEvent.CLICK, onOkButton);
			_controlBar.addChild(_okButton);
		}
		
		
		/**
		 * Removes all assigned event listeners from the window and it's children.
		 * @private
		 */
		override protected function removeEventListeners():void
		{
			super.removeEventListeners();
			_okButton.removeEventListener(MouseEvent.CLICK, onOkButton);
		}
	}
}
