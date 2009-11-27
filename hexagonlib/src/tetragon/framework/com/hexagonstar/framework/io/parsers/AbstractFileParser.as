/*
 * tetragon - Application framework for Flash, Flash/AIR, Flex & Flex/AIR.
 * 
 * Licensed under the MIT License
 * Copyright (c) 2008-2009 Sascha Balkau / Hexagon Star Softworks
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
package com.hexagonstar.framework.io.parsers
{
	import com.hexagonstar.framework.model.Data;
	import com.hexagonstar.framework.util.Log;
	import com.hexagonstar.io.file.types.IFile;
	import com.hexagonstar.util.VectorUtil;

	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;

	
	/**
	 * AbstractFileParser Class
	 * 
	 * @author Sascha Balkau
	 * @version 1.0.0
	 */
	public class AbstractFileParser extends EventDispatcher
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/** @private */
		protected var _data:Data;
		/** @private */
		protected var _file:IFile;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new AbstractFileParser instance.
		 */
		public function AbstractFileParser()
		{
			_data = Main.data;
			super();
		}
		
		
		/**
		 * parse
		 */
		public function parse(file:IFile):void
		{
			_file = file;
			if (!_file.isValid)
			{
				notifyParsingError();
				return;
			}
		}
		
		
		/**
		 * Returns a string representation of the object
		 * @return A string representation of the object.
		 */
		override public function toString():String
		{
			return "[" + getQualifiedClassName(this).match("[^:]*$")[0] + "]";
		}
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Returns the ID of the parser that is used to identify which loaded
		 * files should be parsed with which parser. this method needs to be
		 * overridden by sub classes.
		 */
		public function get id():String
		{
			return null;
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * complete
		 * @private
		 */
		protected function complete():void
		{
			Log.trace(toString() + " Parsed data of " + _file.toString() + ".");
		}
		
		
		/**
		 * notifyParsingError
		 * @private
		 */
		protected function notifyParsingError():void
		{
			Log.error(toString() + " Error parsing file: data structure of <"
				+ _file.path + "> is invalid. (" + _file.errorStatus + ")");
		}
		
		
		/**
		 * Unwraps a string that contains multi-line text, usually from a XML
		 * file. Any leading and trailing spaces or tabs are removed from
		 * each line, then the lines are unwrapped (LFs and CRs are removed).
		 * Then the method adds a space to every line that doesn't end with
		 * a <br/> tag.
		 * 
		 * @param string The string to unwrap.
		 * @return The unwrapped string.
		 * @private
		 */
		protected static function unwrapText(string:String):String
		{
			if (string == null) return null;
			var lines:Array = string.split("\n");
			for (var i:int = 0; i < lines.length; i++)
			{
				lines[i] = lines[i].replace(/^\s+|\s+$/g, "");
				if (!(/<br\/>$/.test(lines[i]))) lines[i] += " ";
			}
			return lines.join("");
		}
		
		
		/**
		 * Parses a string made of IDs into a String Vector.
		 * The IDs in the string must be separated by commata.
		 * @private
		 * 
		 * @param string The string to parse ID values from.
		 * @return A Vector with string values.
		 */
		protected static function parseIDString(string:String):Vector.<String>
		{
			if (string == null) return null;
			string = unwrapText(string);
			return VectorUtil.createStringVector(string.split(","));
		}
		
		
		/**
		 * parseBooleanString
		 * @private
		 */
		protected static function parseBooleanString(string:String):Boolean
		{
			if (string.toLowerCase() == "true") return true;
			return false;
		}
	}
}
