/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.game.tile{	import flash.display.Bitmap;	import flash.display.BitmapData;	import flash.geom.Point;	import flash.geom.Rectangle;			/**	 * The TileSetFactory takes an OXML object and a Bitmap object and generates	 * a TileSet object from these.	 */	public class TileSetFactory	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				protected var _bitmap:BitmapData;		protected var _tileSet:TileSet;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new TileSetFactory instance.		 */		public function TileSetFactory()		{		}						/**		 * Generates a new TileSet object from the specified XML object and bitmap.		 * 		 * @param xml The XML that contains the TileSet data.		 * @param bitmap A Bitmap that contains the graphic tiles.		 */		public function create(xml:XML, bitmap:Bitmap):TileSet		{			_bitmap = bitmap.bitmapData;			_tileSet = new TileSet();						parseData(xml);			generateTiles();						_bitmap = null;			return _tileSet;		}						/**		 * Disposes the TileSetFactory.		 */		public function dispose():void		{			_tileSet = null;		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Returns the parsed TileSet. The parse method needs to called to		 * generate the TileSet first, otherwise the returned value will be null.		 */		public function get tileSet():TileSet		{			return _tileSet;		}						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Parses the TileSet attributes and Tile data from the provided XML object.		 * @private		 */		protected function parseData(xml:XML):void		{			var root:XMLList = xml["tileSet"];			var node:XMLList;			var p:XML;						/* Parse TileSet main attributes */			with (_tileSet)			{				id = root.@id;				tileWidth = root.@tileWidth;				tileHeight = root.@tileHeight;				tileGap = root.@tileGap;				isTransparent = (root.@isTransparent == "true") ? true : false;				backgroundColor = root.@bgColor;				tileImageFilePath = root.@imageFilePath;			}						/* Parse TileSet Pool Properties */			node = root["poolProperties"].property;			for each (p in node)			{				_tileSet.addPoolProperty(p.@id, p.@name, p.@defaultValue);			}						/* Parse TileSet Global Properties */			node = root["globalProperties"].property;			for each (p in node)			{				_tileSet.addGlobalProperty(p.@id, p.@value);			}						/* Parse TileSet tiles */			var tile:ITile;			var tileID:int;			var subFrameCount:int;			var copyOf:int;			node = root["tiles"].tile;			for each (var t:XML in node)			{				tileID = parseInt(t.@id);				subFrameCount = parseInt(t.@subFrames);				copyOf = parseInt(t.@copyOf);								if (subFrameCount > 0)				{					tile = new AnimTile(tileID, subFrameCount, copyOf);				}				else				{					tile = new Tile(tileID, copyOf);				}								/* Parse the current tile's properties */				var propertyNode:XMLList = t["properties"].property;				for each (var prop:XML in propertyNode)				{					var propertyID:int = prop.@id;					var propertyValue:String = prop.@value;					tile.addProperty(propertyID, propertyValue);				}				_tileSet.addTile(tile);			}		}						/**		 * Creates a 'physical' tileset from the provided bitmap by copying the tiles from it.		 * @private		 */		protected function generateTiles():void		{			var rectangle:Rectangle;			var point:Point;			var tile:ITile;			var b:Bitmap;						var id:int;			var subFrames:int;			var copyOf:int = 0;			var x:int = 0;			var y:int = 0;			var width:int;						var bitmapWidth:int = _bitmap.width;			var bitmapHeight:int = _bitmap.height;			var tileWidth:int = _tileSet.tileWidth;			var tileHeight:int = _tileSet.tileHeight;			var tileGap:int = _tileSet.tileGap;			var tileAmount:int = _tileSet.tileCount;			var bgColor:int = _tileSet.backgroundColor;			var isTransparent:Boolean = _tileSet.isTransparent;						/* Iterate through tiles on the bitmap */			for (var i:int = 1; i <= tileAmount; i++)			{				rectangle = new Rectangle(x, y, tileWidth, tileHeight);				point = new Point(0, 0);								tile = _tileSet.getTile(i);				id = tile.id;				copyOf = tile.copyOf;				subFrames = (tile is AnimTile) ? (tile as AnimTile).subFrameCount : 0;				b = tile as Bitmap;								/* TODO Experimenal feature! Checks if the current tile should be a copy				/* of an already existing tile and if so use that instead but update the				/* tile ID to the current one */				if (copyOf > 0)				{					tile = _tileSet.duplicateTile(_tileSet.getTile(copyOf));					tile.id = id;					tile.copyOf = copyOf;					_tileSet.replaceTile(id, tile);					continue;				}								/* If tile has subFrames, extend its width to create space for subFrame buffer */				width = (subFrames > 0) ? tileWidth * (subFrames + 1) : tileWidth;								/* Copy bitmap area from the bitmap to the tile */				b.bitmapData = new BitmapData(width, tileHeight, isTransparent, bgColor);				b.bitmapData.copyPixels(_bitmap, rectangle, point);								/* Iterate over the 'physical' tiles (all tiles and their sub tiles) */				for (var j:int = 0; j < (1 + subFrames); j++)				{					/* If tile has subtiles, copy them into the current tile */					if (subFrames > 0)					{						rectangle = new Rectangle(x, y, tileWidth, tileHeight);						point = new Point((tileWidth * j), 0);						b.bitmapData.copyPixels(_bitmap, rectangle, point);					}										/* Increase x position */					x += (tileWidth + tileGap);										/* Reset x and increase y after reaching the last tile per row */					if (x > (bitmapWidth - tileWidth))					{						x = 0;						y += (tileHeight + tileGap);					}				}								/* For AnimTiles set their ScrollRect */				if (subFrames > 0)				{					rectangle = new Rectangle(0, 0, tileWidth, tileHeight);					(tile as AnimTile).scrollRect = rectangle;				}			}		}	}}