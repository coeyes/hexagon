/*
 * tetragonlib - ActionScript 3 Game Library.
 *    ____
 *   /    / TETRAGON
 *  /____/  LIBRARY
 * 
 * Licensed under the MIT License
 * 
 * Copyright (c) 2009 Sascha Balkau / Hexagon Star Softworks
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
package com.hexagonstar.game.tile
{
	import com.hexagonstar.data.structures.grids.Grid2D;
	import com.hexagonstar.game.tile.ds.PropertyMap;

	
	/**
	 * ITileLayer Interface
	 * @author Sascha Balkau <sascha@hexagonstar.com>
	 */
	public interface ITileLayer
	{
		/**
		 * Adds a new Layer Property to the Layer.
		 * 
		 * @param id The property ID.
		 * @param value The value of the property.
		 */
		function addProperty(id:String, value:*):void
		
		
		/**
		 * Sets the Grid data that is used by the layer. This must be set before
		 * the layer can be used.
		 * 
		 * @param array A 2D Array whose values must be integers and will
		 * be used to populate the layers' grid. The Grid will automatically
		 * receive the width and height from the 2D array.
		 */
		function setGridData(array:Array):void
		
		
		/**
		 * Initializes TileLayer.
		 */
		function init(tileSetsMap:PropertyMap, viewWidth:int, viewHeight:int):void
		
		
		/**
		 * Draws the layer.
		 */
		function draw(xPos:int, yPos:int):void;

		
		/**
		 * Returns a String Representation of the Layer.
		 * @return A String Representation of the Layer.
		 */
		function toString():String;
		
		
		function get index():int;
		function set index(v:int):void;
		function get layerName():String;
		function set layerName(v:String):void;
		function get tileSetID():String;
		function set tileSetID(v:String):void;
		function get tileSet():TileSet;
		function set tileSet(v:TileSet):void;
		function get tileAnimFPS():int;
		function set tileAnimFPS(v:int):void;
		function get transparent():Boolean
		function set transparent(v:Boolean):void
		function get fillColor():uint;
		function set fillColor(v:uint):void;
		function get grid():Grid2D;
		function get properties():PropertyMap;
		
		function get filters():Array;
		function set filters(v:Array):void;
	}
}
