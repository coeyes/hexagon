/*
 * hexcomps
 * Copyright (C) 2007 Hexagon Star Softworks
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
package com.hexagonstar.flex.util
{
	import mx.managers.CursorManager;
	import mx.managers.CursorManagerPriority;
	
	
	/**
	 * CursorUtils Class
	 */
	public class CursorUtils	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		private static var _currentType:Class = null;

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Remove the current cursor and set an image.
		 * 
		 * @param type The image class
		 * @param xOffset The xOffset of the cursorimage
		 * @param yOffset The yOffset of the cursor image
		 */
		public static function changeCursor(type:Class, xOffset:Number = 0, yOffset:Number = 0):void		{
			if (_currentType != type)			{
				_currentType = type;
				CursorManager.removeCursor(CursorManager.currentCursorID);
				
				if (type != null)				{
					CursorManager.setCursor(type, CursorManagerPriority.MEDIUM, xOffset, yOffset);
				}
			}
		}
	}
}
