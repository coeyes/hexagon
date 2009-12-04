/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.game.tile{	import com.hexagonstar.game.tile.ds.PropertyMap;	import flash.display.Bitmap;		/**	 * Tile Class	 */	public class Tile extends Bitmap implements ITile	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				protected var _id:int;		protected var _copyOf:int;		protected var _properties:PropertyMap;				////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new Tile instance.		 */		public function Tile(id:int, copyOf:int = 0)		{			_id = id;			_copyOf = copyOf;			_properties = new PropertyMap(10);		}				/**		 * Clones the Tile's BitmapData Buffer into the passed-in Bitmap's		 * bitmapData. This is used by the TileSet's Duplicate function to		 * create duplicate tiles from existing ones.		 * 		 * @param target The bitmap object to whose bitmapdata the tile is cloned to.		 */		public function cloneBufferTo(target:Bitmap):void		{			target.bitmapData = bitmapData.clone();		}						/**		 * Adds a new Tile Property to the Tile.		 * 		 * @param id The property ID.		 * @param value The value of the property.		 */		public function addProperty(id:int, value:*):void		{			_properties.put(id, value);		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				public function get id():int		{			return _id;		}				public function set id(v:int):void		{			_id = v;		}						public function get copyOf():int		{			return _copyOf;		}				public function set copyOf(v:int):void		{			_copyOf = v;		}						public function get properties():PropertyMap		{			return _properties;		}	}}