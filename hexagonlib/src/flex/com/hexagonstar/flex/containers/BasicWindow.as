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
	import mx.containers.ControlBar;
	import mx.containers.TitleWindow;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;	

	
	/**
	 * BasicWindow Class
	 */
	public class BasicWindow extends TitleWindow
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		
		public static const CLOSE_BUTTON:String = "closeButton";
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		protected var _controlBar:ControlBar;
		protected var _controlBarAlignment:String;
		protected var _closeButtonHasListener:Boolean;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new BasicWindow instance.
		 */
		public function BasicWindow()
		{
			_closeButtonHasListener = false;
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Sets the alignment of the window's ControlBar. Allowed arguments
		 * are "left", "center" and "right". All children of the ControlBar
		 * are aligned to the specified alignment.
		 * 
		 * @param alignment the aligment of the ControlBar.
		 */
		public function set controlBarAlignment(alignment:String):void
		{
			_controlBar.setStyle("horizontalAlign", alignment);
		}
		
		public function get controlBarAlignment():String
		{
			return _controlBar.getStyle("horizontalAlign");
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Event Handlers                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * keyDownHandler
		 * @private
		 */
		override protected function keyDownHandler(e:KeyboardEvent):void
		{
			super.keyDownHandler(e);
			if (e.keyCode == Keyboard.ENTER || e.keyCode == Keyboard.ESCAPE)
			{
				close();
			}
		}
		
		/**
		 * Called when the Window's close button was pressed.
		 * @private
		 */
		protected function onCloseButton(e:CloseEvent):void
		{
			dispatchEvent(new Event(CLOSE_BUTTON));
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
			_controlBar = new ControlBar();
			addChild(_controlBar);
			
			super.createChildren();
			
			width = 300;
			height = 200;
		}
		
		
		/**
		 * updateDisplayList
		 * @private
		 */
		override protected function updateDisplayList(unscaledWidth:Number,
			unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			PopUpManager.centerPopUp(this);
			setFocus();
			
			/* Checks if the closeButton already has an event listener, otherwise
			 * the event would be assigned again when the window closes */
			if (showCloseButton && !_closeButtonHasListener)
			{
				_closeButtonHasListener = true;
				addEventListener(CloseEvent.CLOSE, onCloseButton);
			}
		}
		
		
		/**
		 * Closes the window.
		 * @private
		 */
		protected function close():void
		{
			removeEventListeners();
			PopUpManager.removePopUp(this);
		}
		
		
		/**
		 * Removes all assigned event listeners from the window and it's children.
		 * @private
		 */
		protected function removeEventListeners():void
		{
			removeEventListener(CloseEvent.CLOSE, onCloseButton);
		}
	}
}
