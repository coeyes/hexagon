/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.game.tile{	import com.hexagonstar.core.BasicClass;	import com.hexagonstar.data.types.MetaData;	import com.hexagonstar.game.tile.ds.PropertyMap;			/**	 * TileMap Class	 */	public class TileMap extends BasicClass implements ITileMap	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				protected var _id:String;		protected var _width:int;		protected var _height:int;				protected var _metaData:MetaData;				protected var _properties:PropertyMap;		protected var _layers:Vector.<TileLayer>;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new TileMap instance.		 */		public function TileMap()		{			_metaData = new MetaData();			_properties = new PropertyMap();			_layers = new Vector.<TileLayer>();		}				/**		 * Adds a new TileMap Property to the TileMap.		 * 		 * @param id The property ID.		 * @param value The value of the property.		 */		public function addProperty(id:String, value:*):void		{			_properties.put(id, value);		}						/**		 * Adds a new Tile Layer to the TileMap.		 * 		 * @param layer The Tile Layer.		 */		public function addLayer(layer:TileLayer):void		{			_layers.push(layer);		}						/**		 * Returns a String representation of the TileMap.		 * @return A String representation of the TileMap.		 */		override public function toString(...args):String		{			return super.toString("id=" + _id, "width=" + _width, "height=" + _height);		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * The ID of the TileMap.		 */		public function get id():String		{			return _id;		}		public function set id(v:String):void		{			_id = v;		}						/**		 * The width of the TileMap measured in tiles.		 */		public function get width():int		{			return _width;		}		public function set width(v:int):void		{			_width = v;		}						/**		 * The height of the TileMap measured in tiles.		 */		public function get height():int		{			return _height;		}		public function set height(v:int):void		{			_height = v;		}						/**		 * Returns a Map of the tilemap properties.		 */		public function get properties():PropertyMap		{			return _properties;		}						/**		 * The amount of tile layers that the TileMap has.		 */		public function get layerCount():int		{			return _layers.length;		}						/**		 * Returns the meta data object of the TileSet.		 */		public function get metaData():MetaData		{			return _metaData;		}						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Method description		 * 		 * @private		 */		private function privateMethod():void		{		}	}}