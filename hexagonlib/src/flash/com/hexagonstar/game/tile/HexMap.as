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
	import com.hexagonstar.core.BasicClass;
	import com.hexagonstar.data.types.MetaData;
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
		protected var _width:int;
		protected var _height:int;
		
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
			return super.toString("id=" + _id, "width=" + _width, "height=" + _height);
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
		public function get width():int
		{
			return _width;
		}
		public function set width(v:int):void
		{
			_width = v;
		}
		
		
		/**
		 * The height of the TileMap measured in tiles.
		 */
		public function get height():int
		{
			return _height;
		}
		public function set height(v:int):void
		{
			_height = v;
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
