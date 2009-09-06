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
	import com.hexagonstar.env.event.FlexWindowEvent;

	import mx.controls.Button;

	import flash.events.MouseEvent;

	
	/**
	 * TwoButtonWindow Class
	 */
	public class TwoButtonWindow extends OneButtonWindow implements IFlexWindow
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		protected var _cancelButton:Button;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new TwoButtonWindow instance.
		 */
		public function TwoButtonWindow()
		{
			super();
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Sets the label text of the window's Cancel Button.
		 * @param text the label text for the Cancel button.
		 */
		public function set cancelButtonLabel(v:String):void
		{
			_cancelButton.label = v;
		}
		
		public function get cancelButtonLabel():String
		{
			return _cancelButton.label;
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Event Handlers                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Called when the Cancel button was pressed.
		 */
		protected function onCancelButton(e:MouseEvent):void
		{
			dispatchEvent(new FlexWindowEvent(FlexWindowEvent.CANCEL_BUTTON, this));
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
			
			_cancelButton = new Button();
			_cancelButton.label = "Cancel";
			_cancelButton.addEventListener(MouseEvent.CLICK, onCancelButton);
			_controlBar.addChild(_cancelButton);
		}
		
		
		/**
		 * Removes all assigned event listeners from the window and it's children.
		 * @private
		 */
		override protected function removeEventListeners():void
		{
			super.removeEventListeners();
			_cancelButton.removeEventListener(MouseEvent.CLICK, onCancelButton);
		}
	}
}
