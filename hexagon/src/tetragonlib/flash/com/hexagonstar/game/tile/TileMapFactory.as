/* * tetragonlib - ActionScript 3 Game Library. *    ____ *   /    / TETRAGON *  /____/  LIBRARY *  * Licensed under the MIT License *  * Copyright (c) 2009 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.game.tile{	import com.hexagonstar.exception.InvalidDataException;	import com.hexagonstar.game.tile.hex.HexLayer;	import com.hexagonstar.game.tile.hex.HexMap;	import com.hexagonstar.game.tile.iso.IsoMap;	import com.hexagonstar.game.tile.ort.TileLayer;	import com.hexagonstar.game.tile.ort.TileMap;		/**	 * TileMapFactory Class	 */	public class TileMapFactory	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				protected var _tileMap:ITileMap;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new TileMapFactory instance.		 */		public function TileMapFactory()		{		}						/**		 * Generates a new TileSet object from the specified XML object and bitmap.		 * 		 * @param xml The XML that contains the TileSet data.		 * @param bitmap A Bitmap that contains the graphic tiles.		 * @return A tilemap.		 */		public function create(xml:XML):ITileMap		{			parseData(xml);			return _tileMap;		}						/**		 * create a tilemap for testing that is randomly populated with tiles.		 * 		 * @param width Width of the test map, measured in tiles.		 * @param height Height of the test map, measured in tiles.		 * @param tileSet The tileset used on the testmap.		 * @param bgColor The background color for the test map.		 * @param layerCount The amount of layers the testmap will have.		 * @param noEmptyTilesIf true the random map will not have any empty tiles.		 * @return The test tilemap.		 */		public function createTestMap(width:int,											height:int,											tileSet:TileSet,											type:String = TileMapType.ORTHOGONAL,											bgColor:uint = 0x555555,											layerCount:int = 1,											noEmptyTiles:Boolean = false):ITileMap		{			createMap(type, layerCount);			_tileMap.width = width;			_tileMap.height = height;			_tileMap.backgroundColor = bgColor;			createTestLayers(tileSet, noEmptyTiles);			return _tileMap;		}		
		
		/**		 * Disposes the TileSetFactory.		 */		public function dispose():void		{			_tileMap = null;		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Returns the generated TileMap. The create method needs to called to		 * generate the TileMap first, otherwise the returned value will be null.		 */		public function get tileMap():ITileMap		{			return _tileMap;		}						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Parses the TileSet attributes and Tile data from the provided XML object.		 * @private		 */		protected function parseData(xml:XML):void		{			var root:XMLList = xml["tileMap"];			var node:XMLList;			var p:XML;						createMap(root.@type, root.@layerCount);						if (_tileMap)			{				/* Parse TileMap main attributes */				with (_tileMap)				{					id = root.@id;					width = root.@width;					height = root.@height;				}								/* Parse TileMap meta data */				node = root["meta"];				with (_tileMap.metaData)				{					name = node["name"];					description = node["description"];					author = node["author"];					keywords = node["keywords"];					date = node["date"];				}								/* Parse TileMap Properties */				node = root["mapProperties"].property;				for each (p in node)				{					_tileMap.addProperty(p.@name, p.@value);				}								/* Parse TileMap layers */				var layer:ITileLayer;				node = root["layers"].layer;				for each (var l:XML in node)				{					layer = createLayer(_tileMap);					layer.index = l.@index;					layer.layerName = l.@name;					layer.tileSetID = l.@tileSetID;					layer.tileAnimFPS = l.@tileAnimFPS;										/* Parse the current layers's properties */					var propNode:XMLList = l["properties"].property;					var prop:XML;					for each (prop in propNode)					{						layer.addProperty(prop.@name, prop.@value);					}										/* Parse the current layers's row data */					propNode = l["data"].row;					var a:Array = [];					for each (var r:XML in propNode)					{						var row:Array = ("" + r.@data).split(",");						a.push(row);					}					layer.setGridData(a);					_tileMap.addLayer(layer);				}			}		}						/**		 * createTestLayers		 * @private		 */		protected function createTestLayers(tileSet:TileSet, noEmptyTiles:Boolean):void		{			var layer:ITileLayer;			var w:int = _tileMap.width;			var h:int = _tileMap.height;			var tileCount:int = tileSet.tileCount;			var m1:int = noEmptyTiles ? 0 : 1;			var m2:int = noEmptyTiles ? 1 : 0;						for (var i:int = 0; i < _tileMap.layers.length; i++)			{				layer = createLayer(_tileMap);				layer.index = i;				layer.layerName = "Random Layer #" + i;				layer.tileSetID = tileSet.id;				layer.tileAnimFPS = TileScroller.TILE_ANIM_FPS;								for (var y:int = 0; y < h; y++)				{					for (var x:int = 0; x < w; x++)					{						var tileID:int = (Math.random() * (tileCount + m1)) + m2;						layer.grid.setCell(x, y, tileID);					}				}								_tileMap.addLayer(layer);			}		}						/**		 * Creates a tilemap of the specified type.		 * @private		 */		protected function createMap(type:String, layerCount:int):void		{			switch (type)			{				case TileMapType.ORTHOGONAL:					_tileMap = new TileMap(layerCount);					break;				case TileMapType.HEXAGONAL:					_tileMap = new HexMap(layerCount);					break;				case TileMapType.ISOMETRIC:					// TODO _tileMap = new IsoMap(layerCount);					break;				default:					throw new InvalidDataException("A TileMapType of [" + type + "]"						+ "is not supported!");			}		}						/**		 * Creates a tile layer of the specified type.		 * @private		 */		protected function createLayer(tileMap:ITileMap):ITileLayer		{			if (tileMap is TileMap)			{				return new TileLayer(tileMap.width, tileMap.height);			}			else if (tileMap is HexMap)			{				return new HexLayer(tileMap.width, tileMap.height);			}			else if (tileMap is IsoMap)			{				// TODO				return null;				//return new IsoLayer(tileMap.width, tileMap.height);			}			return null;		}	}}