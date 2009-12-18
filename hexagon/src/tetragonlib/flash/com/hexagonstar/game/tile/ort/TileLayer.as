/* * tetragonlib - ActionScript 3 Game Library. *    ____ *   /    / TETRAGON *  /____/  LIBRARY *  * Licensed under the MIT License *  * Copyright (c) 2009 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.game.tile.ort{	import com.hexagonstar.data.structures.grids.Grid2D;	import com.hexagonstar.game.tile.AnimTile;	import com.hexagonstar.game.tile.ITile;	import com.hexagonstar.game.tile.ITileLayer;	import com.hexagonstar.game.tile.Tile;	import com.hexagonstar.game.tile.TileSet;	import com.hexagonstar.game.tile.ds.PropertyMap;	import com.hexagonstar.time.PreciseTimer;	import flash.display.Bitmap;	import flash.display.BitmapData;	import flash.display.DisplayObject;	import flash.display.PixelSnapping;	import flash.display.Sprite;	import flash.events.TimerEvent;	import flash.geom.Point;	import flash.geom.Rectangle;	import flash.utils.Dictionary;		/**	 * TileLayer Class	 */	public class TileLayer extends Sprite implements ITileLayer	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				protected var _index:int;		protected var _name:String;		protected var _tileSetID:String;		protected var _tileAnimFPS:int;		protected var _tileAnimTimer:PreciseTimer;		protected var _properties:PropertyMap;				protected var _grid:Grid2D;		protected var _tileSet:TileSet;		protected var _buffer:BitmapData;		protected var _canvas:BitmapData;				protected var _viewWidth:int;		protected var _viewHeight:int;		protected var _viewCols:int;		protected var _viewRows:int;				protected var _tileWidth:int;		protected var _tileHeight:int;				protected var _bufferWidth:int;		protected var _bufferHeight:int;				/**		 * Rectangle and Point that are used to copy/position tiles.		 * @private		 */		protected var _rectangle:Rectangle;		protected var _point:Point;				/**		 * Rectangle and Point that are used to copy an area from the buffer to the canvas.		 * @private		 */		protected var _copyRectangle:Rectangle;		protected var _copyPoint:Point;				/**		 * Rectangle used to clear (flood fill) the buffer.		 * @private		 */		protected var _bufferRectangle:Rectangle;				/**		 * If true also renders the buffer to the screen. Only used for debugging.		 * @private		 */		protected var _showBuffer:Boolean = false;						protected var _animTiles:Dictionary;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new TileLayer instance.		 * 		 * @param width Width of the layer, measured in tiles.		 * @param height Height of the layer, measured in tiles.		 */		public function TileLayer(width:int = 0, height:int = 0)		{			_properties = new PropertyMap(10);			_grid = new Grid2D(width, height);		}				/**		 * Adds a new Layer Property to the Layer.		 * 		 * @param id The property ID.		 * @param value The value of the property.		 */		public function addProperty(id:String, value:*):void		{			_properties.put(id, value);		}						/**		 * Sets the Grid data that is used by the layer. This must be set before		 * the layer can be used.		 * 		 * @param array A 2D Array whose values must be integers and will		 * be used to populate the layers' grid. The Grid will automatically		 * receive the width and height from the 2D array.		 */		public function setGridData(array:Array):void		{			_grid.fromArray(array);		}						/**		 * Initializes TileLayer.		 */		public function init(tileSetsMap:PropertyMap, viewWidth:int, viewHeight:int):void		{			_tileSet = tileSetsMap.getValue(_tileSetID);			_tileWidth = _tileSet.tileWidth;			_tileHeight = _tileSet.tileHeight;						_viewWidth = viewWidth;			_viewHeight = viewHeight;			_viewCols = _viewWidth / _tileWidth;			_viewRows = _viewHeight / _tileHeight;						/* Calculate buffer width and height */			_bufferWidth = _viewWidth + _tileWidth;			_bufferHeight = _viewHeight + _tileHeight;						_point = new Point(0, 0);			_copyPoint = new Point(0, 0);			_copyRectangle = new Rectangle(0, 0, _viewWidth, _viewHeight);			_rectangle = new Rectangle(0, 0, _tileWidth, _tileHeight);						_buffer = new BitmapData(_bufferWidth, _bufferHeight, true, 0x00000000);			_bufferRectangle = new Rectangle(0, 0, _viewWidth + _tileWidth, _viewHeight + _tileHeight);						if (_showBuffer)			{				var bufferBitmap:Bitmap = new Bitmap(_buffer);				bufferBitmap.alpha = 0.4;				addChild(bufferBitmap);			}						_canvas = new BitmapData(_viewWidth, _viewHeight, true, 0x00000000);			addChild(new Bitmap(_canvas, PixelSnapping.ALWAYS, false));						_animTiles = new Dictionary(true);						if (_tileSet.animTileCount > 0)			{				_tileAnimTimer = new PreciseTimer(Math.round(1000 / _tileAnimFPS), 0);				_tileAnimTimer.addEventListener(TimerEvent.TIMER, onTimer);				_tileAnimTimer.start();			}		}						/**		 * Draws the layer.		 */		public function draw(xPos:int, yPos:int):void		{//			for each (var t:AnimTile in _animTiles)//			{//				removeChild(t);//			}						/* Clear the buffer */			_buffer.fillRect(_bufferRectangle, 0x00000000);						for (var y:int = 0; y <= _viewRows; y++)			{				for (var x:int = 0; x <= _viewCols; x++)				{					var ux:int = x + int(xPos / _tileWidth);					var uy:int = y + int(yPos / _tileHeight);					var tileID:int = _grid.getCell(ux, uy);										/* Only draw tiles if necessary */					if (tileID > 0)					{						var tile:ITile = _tileSet.getTile(tileID);						_point.x = x * _tileWidth;						_point.y = y * _tileHeight;												if (tile is AnimTile)						{							var uid:String = ux + "_" + uy;							if (!_animTiles[uid])							{								tile = _tileSet.duplicateTile(tile);								tile.x = _point.x;								tile.y = _point.y;								_animTiles[uid] = tile;								addChild(tile as DisplayObject);							}							else							{								// TODO remove tiles that moved outside the view.								// TODO calculate correct coord of tile to move to.								var t:AnimTile = _animTiles[uid];								t.x = _point.x;								t.y = _point.y;							}						}						else						{							_buffer.copyPixels((tile as Tile).bitmapData, _rectangle, _point);						}					}				}			}						/* Calculate offset position to copy view rect from the buffer. */			_copyRectangle.x = xPos % _tileWidth;			_copyRectangle.y = yPos % _tileHeight;						_canvas.copyPixels(_buffer, _copyRectangle, _copyPoint);			//			for (var y:int = 0; y <= _viewRows; y++)//			{//				for (var x:int = 0; x <= _viewCols; x++)//				{//					//					tileID = _grid.getCell(x + tileX, y + tileY);//			        //					_point.x = x * _tileWidth;//					_point.y = y * _tileHeight;//					//					if (tileID > 0)//					{//						tile = _tileSet.getTile(tileID);//						//						var spr:Sprite = new Sprite();//						var rct:RectangleShape = new RectangleShape(_tileWidth, _tileHeight, 0, 0.0, 1, 0xFF00FF, 1.0);//						var qtf:QuickTextField = new QuickTextField((x + tileX).toString(), 0, 0, null, 11, 0xFFFFFF);//						spr.addChild(rct);//						spr.addChild(qtf);//						//						var bmd:BitmapData = new BitmapData(_tileWidth, _tileHeight, true, 0x00000000);//						bmd.draw((tile as Tile).bitmapData);//						bmd.draw(spr);//						//						_buffer.copyPixels(bmd, _rectangle, _point);//					}//					else//					{//						_buffer.copyPixels(_emptyTile, _rectangle, _point);//					}//				}//			}		}				/**		 * Returns a String Representation of TileLayer.		 * @return A String Representation of TileLayer.		 */		override public function toString():String		{			return "[TileLayer, index=" + _index + ", layerName=" + _name + "]";		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				public function get index():int		{			return _index;		}		public function set index(v:int):void		{			_index = v;		}						public function get layerName():String		{			return _name;		}		public function set layerName(v:String):void		{			_name = v;		}						public function get tileSetID():String		{			return _tileSetID;		}		public function set tileSetID(v:String):void		{			_tileSetID = v;		}						public function get tileSet():TileSet		{			return _tileSet;		}		public function set tileSet(v:TileSet):void		{			_tileSet = v;		}						public function get tileAnimFPS():int		{			return _tileAnimFPS;		}		public function set tileAnimFPS(v:int):void		{			_tileAnimFPS = v;		}						public function get grid():Grid2D		{			return _grid;		}						public function get properties():PropertyMap		{			return _properties;		}						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @private		 */		protected function onTimer(e:TimerEvent):void		{			for each (var t:AnimTile in _animTiles)			{				t.nextFrame();			}		}						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * calculateBufferSize		 * @private		 */		protected function calculateBufferSize():void		{//			var gridW:int = _grid.width * _tileWidth;//			var gridH:int = _grid.height * _tileHeight;//			//			/* If the grid is smaller (or equal) to the window size, the buffer size//			 * can be the same as the grid size since no scrolling is necessary but if//			 * the grid is larger, the buffer needs to be the view size + one column//			 * and row of a tile width/height *///			if (gridW <= _viewWidth)//			{//				_bufferWidth = gridW;//			}//			else//			{//				_bufferWidth = _viewWidth - (_viewWidth % _tileWidth) + _tileWidth;//			}//			//			if (gridH <= _viewHeight)//			{//				_bufferHeight = gridH;//			}//			else//			{//				_bufferHeight = _viewHeight - (_viewHeight % _tileHeight) + _tileHeight;//			}//			//			_bufferWidthTiles = _bufferWidth / _tileWidth;//			_bufferHeightTiles = _bufferHeight / _tileHeight;//			//			//Debug.trace("gridW=" + gridW, Debug.LEVEL_DEBUG);//			//Debug.trace("gridH=" + gridH, Debug.LEVEL_DEBUG);//			//Debug.trace("bufferWidth=" + _bufferWidth, Debug.LEVEL_DEBUG);//			//Debug.trace("bufferHeight=" + _bufferHeight, Debug.LEVEL_DEBUG);//			//Debug.trace("bufferWidthTiles=" + _bufferWidthTiles, Debug.LEVEL_DEBUG);//			//Debug.trace("bufferHeightTiles=" + _bufferHeightTiles, Debug.LEVEL_DEBUG);		}	}}