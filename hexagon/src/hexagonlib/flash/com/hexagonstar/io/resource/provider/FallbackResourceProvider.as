/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.io.resource.provider{	import com.hexagonstar.exception.SingletonException;		/**	 * FallbackResourceProvider	 * @author Sascha Balkau	 */	public class FallbackResourceProvider extends LoadedResourceProvider	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				/** @private */		private static var _instance:FallbackResourceProvider;		/** @private */		private static var _singletonLock:Boolean = false;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new instance of the class.		 */		public function FallbackResourceProvider()		{			/* call the LoadedResourceProvider parent constructor where we specify that			 * this Provider should not be registered as a normal provider. */			super(false);						if (!_singletonLock) throw new SingletonException(this);		}						/**		 * This method will check if this provider has access to a specific Resource.		 */		override public function isResourceKnown(path:String, type:Class):Boolean		{			// always return true, because this resource provider will load the 			// resource on the fly, using a loader when it is requested.			return true;		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Returns the singleton instance of FallbackResourceProvider.		 */		public static function get instance():FallbackResourceProvider		{			if (_instance == null)			{				_singletonLock = true;				_instance = new FallbackResourceProvider();				_singletonLock = false;			}			return _instance;		}	}}