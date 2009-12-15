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
package com.hexagonstar.game.tile.hex
{
	import com.hexagonstar.core.BasicClass;
	import com.hexagonstar.data.types.MetaData;
	import com.hexagonstar.game.tile.ITileLayer;
	import com.hexagonstar.game.tile.ITileMap;
	import com.hexagonstar.game.tile.ds.PropertyMap;

	
	/**
	 * HexMap Class
	 */
	public class HexMap extends BasicClass implements ITileMap
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		protected var _id:String;
		protected var _widthTiles:int;
		protected var _heightTiles:int;
		protected var _widthPixel:uint;
		protected var _heightPixel:uint;
		
		protected var _metaData:MetaData;
		
		protected var _properties:PropertyMap;
		protected var _layers:Vector.<ITileLayer>;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new HexMap instance.
		 */
		public function HexMap(layerCount:int)
		{
			_metaData = new MetaData();
			_properties = new PropertyMap();
			_layers = new Vector.<ITileLayer>(layerCount, false);
		}

		
		/**
		 * Adds a new HexMap Property to the TileMap.
		 * 
		 * @param id The property ID.
		 * @param value The value of the property.
		 */
		public function addProperty(id:String, value:*):void
		{
			_properties.put(id, value);
		}
		
		
		/**
		 * Adds a new Tile Layer to the TileMap.
		 * 
		 * @param layer The Tile Layer.
		 */
		public function addLayer(layer:ITileLayer):void
		{
			/* We only need to get the dimensions of the first layer since all
			 * layer and tiles sizes must be the same. */
			if (_layers.length == 0)
			{
				_widthPixel = _widthTiles * layer.tileSet.tileWidth;
				_heightPixel = _heightTiles * layer.tileSet.tileHeight;
			}
			
			_layers[layer.index] = layer;
		}
		
		
		/**
		 * getLayer
		 */
		public function getLayer(index:int):ITileLayer
		{
			return _layers[index];
		}
		
		
		/**
		 * Initializes the TileMap.
		 */
		public function init():void
		{
		}
		
		
		/**
		 * initLayers
		 */
		public function initLayers(tileSetsMap:PropertyMap, winWidth:int, winHeight:int):void
		{
			for each (var l:ITileLayer in _layers)
			{
				l.init(tileSetsMap, winWidth, winHeight);
			}
		}
		
		
		/**
		 * Returns a String representation of the TileMap.
		 * @return A String representation of the TileMap.
		 */
		override public function toString(...args):String
		{
			return super.toString("id=" + _id, "widthTiles=" + _widthTiles,
				"heightTiles=" + _heightTiles);
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * The ID of the TileMap.
		 */
		public function get id():String
		{
			return _id;
		}
		public function set id(v:String):void
		{
			_id = v;
		}
		
		
		/**
		 * The width of the TileMap measured in tiles.
		 */
		public function get widthTiles():int
		{
			return _widthTiles;
		}
		public function set widthTiles(v:int):void
		{
			_widthTiles = v;
		}

		
		/**
		 * The height of the TileMap measured in tiles.
		 */
		public function get heightTiles():int
		{
			return _heightTiles;
		}
		public function set heightTiles(v:int):void
		{
			_heightTiles = v;
		}
		
		
		/**
		 * The width of the entire map in pixels. This is calculated from
		 * mapWidth measured in tiles * tileWidth of the tileset with largest tiles.
		 */
		public function get widthPixel():uint
		{
			return _widthPixel;
		}
		
		
		/**
		 * The height of the entire map in pixels. This is calculated from
		 * mapHeight measured in tiles * tileHeight of the tileset with largest tiles.
		 */
		public function get heightPixel():uint
		{
			return _heightPixel;
		}
		
		
		/**
		 * The background color of the tilemap.
		 */
		public function get backgroundColor():uint
		{
			return _properties.getValue("backgroundColor");
		}
		public function set backgroundColor(v:uint):void
		{
			_properties.put("backgroundColor", v);
		}

		
		/**
		 * Returns a Map of the tilemap properties.
		 */
		public function get properties():PropertyMap
		{
			return _properties;
		}
		
		
		/**
		 * The tile layers of the TileMap.
		 */
		public function get layers():Vector.<ITileLayer>
		{
			return _layers;
		}
		
		
		/**
		 * The amount of tile layers that the TileMap has.
		 */
		public function get layerCount():int
		{
			return _layers.length;
		}
		public function set layerCount(v:int):void
		{
			// TODO (only necessary for tilemap editor)
		}
		
		
		/**
		 * Returns the meta data object of the TileSet.
		 */
		public function get metaData():MetaData
		{
			return _metaData;
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Event Handlers                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		
	}
}
