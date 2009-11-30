/* * tetragon - Application framework for Flash, Flash/AIR, Flex & Flex/AIR. *  * Licensed under the MIT License * Copyright (c) 2008-2009 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.framework.io.loaders{	import model.Config;	import com.hexagonstar.framework.util.Log;	[Event(name="complete", type="flash.events.Event")]	[Event(name="error", type="flash.events.ErrorEvent")]			/**	 * A class that loads the application configuration/ini file and parses the loaded	 * properties into the config model. The manager/config model supports simple string and	 * numeric values, objects, and arrays.<p> The Config model should contain all	 * properties that are also found in the config file. See the Config class for more	 * info.	 * 	 * @author Sascha Balkau	 * @version 1.0.0	 */	public class ConfigLoader extends AbstractIniLoader implements ILoader	{		////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new instance of the class.		 * 		 * @param filePath The file path of the config file.		 * @param fileID An optional ID for the config file.		 */		public function ConfigLoader(filePath:String, fileID:String = null)		{			super(filePath, fileID);		}						/**		 * Returns a string representation of ConfigLoader.		 * 		 * @return A string representation of ConfigLoader.		 */		override public function toString():String		{			return "[ConfigLoader]";		}						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Tries to parse the specified key and value pair into the Config Model.		 * @private		 */		override protected function parseProperty(key:String, val:String):void		{			var config:Config = Main.config;			var keyExists:Boolean = true;			var p:*;						/* Check if the key found in the config file is defined in the Config Model */			try			{				p = config[key];			}			catch (e:Error)			{				Log.error(toString() + " Error parsing config property: " + e.message);				keyExists = false;			}						if (keyExists)			{				if (p is Number)					config[key] = val;				else if (p is String)					config[key] = val;				else if (p is Boolean)					config[key] = (val.toLowerCase() == "true") ? true : false;				else if (p is Array)					config[key] = parseArray(val);				else if (p is Object)					config[key] = parseObject(val);			}		}						/**		 * Parses a string into an array. The string must have the format [val1, val2, val3]		 * and so on. Note that string type values in the array string should not be wrapped		 * by any kind of quotation marks; internally all values are treated as Strings!		 * 		 * @private		 * @param string The string to parse into an array.		 * @return the array with values from the string or null if the string could not be		 *         parsed into an array.		 */		private function parseArray(string:String):Array		{			/* String must start mit [ and end with ] */			if (string.match("^\\[.*?\\]\\z"))			{				string = string.substr(1, string.length - 2);				if (string.length > 0)				{					var a:Array = string.split(",");					for (var i:String in a)					{						a[i] = trim(a[i]);					}					return a;				}				return null;			}			else			{				Log.error(toString() + " Error parsing config: malformed syntax"					+ " in Array property: " + string);				return null;			}		}						/**		 * Parses a string into an object. The string must have the format {key1: val1,		 * key2: val2, key3: val3} and so on. Note that string type values in the object		 * string should not be wrapped by any kind of quotation marks; internally all		 * values are treated as Strings!		 * 		 * @private		 * @param string The string to parse into an object.		 * @return the object with the key/value pairs from the string or null if the string		 *         could not be parsed into an object.		 */		private function parseObject(string:String):Object		{			/* String must start with {, end with }, contain at least one : and			 * may not contain any {} in it's contents */			if (string.match("^\\{.[^\\{\\}]*?[:]+.[^\\{\\}]*?\\}\\z"))			{				string = string.substr(1, string.length - 2);				var a:Array = string.split(",");				var o:Object = {};								for (var i:String in a)				{					var d:Array = (a[i] as String).split(":");					var p:RegExp = new RegExp("[ \n\t\r]", "g");					var key:String = (d[0] as String).replace(p, "");					var val:String = (d[1] as String).replace(p, "");					o[key] = val;				}				return o;			}			else			{				Log.error(toString() + " Error parsing config: malformed syntax"					+ " in Object property: " + string);				return null;			}		}	}}