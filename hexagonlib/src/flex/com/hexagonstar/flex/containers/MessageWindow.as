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
	import mx.controls.Label;
	import mx.controls.TextArea;	

	
	/**
	 * MessageWindow Class
	 */
	public class MessageWindow extends OneButtonWindow
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		protected var _messageTitle:Label;
		protected var _messageText:TextArea;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new MessageWindow instance.
		 */
		public function MessageWindow()
		{
			super();
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Sets the text for the dialog's content title.
		 */
		public function set messageTitle(v:String):void
		{
			_messageTitle.htmlText = v;
		}
		
		public function get messageTitle():String
		{
			return _messageTitle.htmlText;
		}
		
		/**
		 * Sets the text for the dialog's content text.
		 */
		public function set messageText(v:String):void
		{
			_messageText.htmlText = v;
		}
		
		public function get messageText():String
		{
			return _messageText.htmlText;
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
			
			_messageTitle = new Label();
			_messageTitle.styleName = "messageWindowTitle";
			_messageTitle.percentWidth = 100;
			_messageTitle.selectable = false;
			
			_messageText = new TextArea();
			_messageText.styleName = "messageWindowText";
			_messageText.percentWidth = 100;
			_messageText.percentHeight = 100;
			_messageText.selectable = false;
			
			addChild(_messageTitle);
			addChild(_messageText);
		}
	}
}
