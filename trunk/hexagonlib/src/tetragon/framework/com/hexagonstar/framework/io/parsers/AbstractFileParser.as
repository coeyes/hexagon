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
	 * @author Sascha Balkau <sascha@hexagonstar.com>
	 */
	public class AbstractFileParser extends EventDispatcher
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		protected var _data:Data;
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
