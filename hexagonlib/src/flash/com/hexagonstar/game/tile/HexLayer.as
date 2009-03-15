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
package com.hexagonstar.game.tile
{
	import com.hexagonstar.data.structures.grids.Grid2D;
	import com.hexagonstar.game.tile.ds.PropertyMap;
	import com.hexagonstar.util.debug.Debug;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;	

	
	/**
	 * HexLayer Class
	 */
	public class HexLayer extends Sprite implements ITileLayer
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		protected var _index:int;
		protected var _name:String;
		protected var _tileSetID:String;
		protected var _tileAnimFPS:int;
		protected var _properties:PropertyMap;
		protected var _grid:Grid2D;
		
		protected var _windowWidth:int;
		protected var _windowHeight:int;
		
		protected var _tileWidth:int;
		protected var _tileHeight:int;
		
		protected var _bufferWidth:int;
		protected var _bufferHeight:int;
		protected var _bufferWidthTiles:int;
		protected var _bufferHeightTiles:int;
		
		protected var _bitmap:BitmapData;
		protected var _tileSet:TileSet;

		protected var _rectangle:Rectangle;
		protected var _point:Point;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new HexLayer instance.
		 */
		public function HexLayer(width:int = 0, height:int = 0)
		{
			_properties = new PropertyMap(10);
			_grid = new Grid2D(width, height);
		}

		
		/**
		 * Adds a new Layer Property to the Layer.
		 * 
		 * @param id The property ID.
		 * @param value The value of the property.
		 */
		public function addProperty(id:String, value:*):void
		{
			_properties.put(id, value);
		}
		
		
		/**
		 * Sets the Grid data that is used by the layer. This must be set before
		 * the layer can be used.
		 * 
		 * @param array A 2D Array whose values must be integers and will
		 * be used to populate the layers' grid. The Grid will automatically
		 * receive the width and height from the 2D array.
		 */
		public function setGridData(array:Array):void
		{
			_grid.fromArray(array);
		}
		
		
		/**
		 * Initializes TileLayer.
		 */
		public function init(tileSetsMap:PropertyMap, winWidth:int, winHeight:int):void
		{
			_tileSet = tileSetsMap.getValue(_tileSetID);
			_tileWidth = _tileSet.tileWidth;
			_tileHeight = _tileSet.tileHeight;
			
			_windowWidth = winWidth;
			_windowHeight = winHeight;
			
			calculateBufferSize();
			
			_point = new Point(0, 0);
			_rectangle = new Rectangle(0, 0, _tileWidth, _tileHeight);
			
			_bitmap = new BitmapData(_bufferWidth, _bufferHeight, true, 0x00000000);
			addChild(new Bitmap(_bitmap));
		}

		
		/**
		 * Draws the layer.
		 */
		public function draw():void
		{
			var tile:ITile;
			var tileID:int;
			var xPos:int;
			var yPos:int;
			
			Debug.trace("bwt=" + _bufferWidthTiles + ", bht=" + _bufferHeightTiles);
			for (var y:int = 0; y < _bufferHeightTiles; y++)
			{
				for (var x:int = 0; x < _bufferWidthTiles; x++)
				{
					//Debug.trace("x: " + x + "  y: " + y);
					tileID = _grid.getCell(x, y);
					
					/* Only draw tiles if necessary */
					if (tileID > 0)
					{
						tile = _tileSet.getTile(tileID);
						_point.x = x * _tileWidth;
						_point.y = y * _tileHeight;
						
						if (tile is AnimTile)
						{
							tile = _tileSet.duplicateTile(tile);
							tile.x = _point.x;
							tile.y = _point.y;
							addChild(tile as DisplayObject);
							(tile as AnimTile).play();
						}
						else
						{
							_bitmap.copyPixels((tile as Tile).bitmapData, _rectangle, _point);
						}
					}
				}
			}
		}

		
		/**
		 * Returns a String Representation of TileLayer.
		 * @return A String Representation of TileLayer.
		 */
		override public function toString():String
		{
			return "[HexLayer, index=" + _index + ", layerName=" + _name + "]";
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		
		public function get index():int
		{
			return _index;
		}
		public function set index(v:int):void
		{
			_index = v;
		}
		
		
		public function get layerName():String
		{
			return _name;
		}
		public function set layerName(v:String):void
		{
			_name = v;
		}
		
		
		public function get tileSetID():String
		{
			return _tileSetID;
		}
		public function set tileSetID(v:String):void
		{
			_tileSetID = v;
		}
		
		
		public function get tileSet():TileSet
		{
			return _tileSet;
		}
		public function set tileSet(v:TileSet):void
		{
			_tileSet = v;
		}
		
		
		public function get tileAnimFPS():int
		{
			return _tileAnimFPS;
		}
		public function set tileAnimFPS(v:int):void
		{
			_tileAnimFPS = v;
		}
		
		
		public function get grid():Grid2D
		{
			return _grid;
		}
		
		
		public function get properties():PropertyMap
		{
			return _properties;
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Event Handlers                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * calculateBufferSize
		 * @private
		 */
		protected function calculateBufferSize():void
		{
		}
	}
}
