/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.io.resource.provider{	import com.hexagonstar.debug.HLog;	import com.hexagonstar.exception.SingletonException;	import com.hexagonstar.io.resource.ResourceManager;	import com.hexagonstar.io.resource.types.Resource;		/**	 * The EmbeddedResourceProvider provides the ResourceManager with the embedded	 * resources that were loaded from ResourceBundle and ResourceBinding classes This	 * class works using a singleton pattern so when resource bundles and/or resource	 * bindings are initialized they will register the resources with the	 * EmbeddedResourceProvider.instance	 * 	 * @author Sascha Balkau	 */	public class EmbeddedResourceProvider extends AbstractResourceProvider	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				/** @private */		private static var _instance:EmbeddedResourceProvider;		/** @private */		private static var _singletonLock:Boolean = false;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Calls the AbstractResourceProvider constructor - super(); to auto-register this		 * provider with the ResourceManager		 */		public function EmbeddedResourceProvider()		{			super();			if (!_singletonLock) throw new SingletonException(this);		}						/**		 * This method is used by the ResourceBundle and ResourceBinding Class to register		 * the existance of a specific embedded resource.		 * 		 * @param path		 * @param type		 * @param data		 */		public function registerResource(path:String, type:Class, data:*):void		{			/* create a unique identifier for this resource */			var identifier:String = ResourceManager.createIdentifier(path, type);						/* check if the resource has already been registered */			if (_resources[identifier])			{				HLog.warn(toString() + " An embedded resource from file <"					+ path + "> has already been registered.");				return;			}						/* Set up the resource */			try			{				var resource:Resource = new type();				resource.setup(path, identifier);				//setTimeout(resource.initialize, 1000, data);				resource.initialize(data);								/* keep the resource in the lookup dictionary */				_resources[identifier] = resource;			}			catch (e:Error)			{				HLog.error(toString() + " Could not instantiate embedded resource <" + path					+ "> of type " + type + " due to error: " + e.message);				return;			}		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Returns the singleton instance of EmbeddedResourceProvider.		 */		public static function get instance():EmbeddedResourceProvider		{			if (_instance == null)			{				_singletonLock = true;				_instance = new EmbeddedResourceProvider();				_singletonLock = false;			}			return _instance;		}	}}