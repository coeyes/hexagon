/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.game.tile{	import flash.display.Bitmap;	import flash.display.BitmapData;			/**	 * Tile Class	 */	public class Tile extends Bitmap implements ITile	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				protected var _id:int;		protected var _subTileAmount:int;		protected var _copyOf:int;		protected var _buffer:BitmapData;				////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new Tile instance.		 */		public function Tile(id:int, subTileAmount:int = 0, copyOf:int = -1)		{			_id = id;			_subTileAmount = subTileAmount;			_copyOf = copyOf;		}						/**		 * Clones the Tile's BitmapData Buffer into the passed-in Bitmap's		 * bitmapData. This is used by the TileSet's Duplicate function to		 * create duplicate tiles from existing ones.		 * 		 * @param target The bitmap object to whose bitmapdata the tile is cloned to.		 */		public function cloneBufferTo(target:Bitmap):void		{			/* If the tile is a GenericAnimTile clone from its buffer to get all sub			 * tiles. Otherwise simply clone from the bitmapdata since non-anim Tiles			 * don't need a buffer: */			if (this is AnimTile)			{				target.bitmapData = _buffer.clone();			}			else			{				target.bitmapData = bitmapData.clone();			}		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				public function get id():int		{			return _id;		}				public function set id(v:int):void		{			_id = v;		}						public function get subTileAmount():int		{			return _subTileAmount;		}				public function set subTileAmount(v:int):void		{			_subTileAmount = v;		}						public function get copyOf():int		{			return _copyOf;		}				public function set copyOf(v:int):void		{			_copyOf = v;		}	}}