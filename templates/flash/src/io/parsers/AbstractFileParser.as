package io.parsers
{
	import model.Data;

	import util.Log;

	import com.hexagonstar.io.file.types.IFile;

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
			if (!file.isValid)
			{
				notifyParsingError(file);
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
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * notifyParsingError
		 * @private
		 */
		protected function notifyParsingError(file:IFile):void
		{
			Log.error(toString() + " Error parsing file: data structure of <"
				+ file.path + "> is invalid. (" + file.errorStatus + ")");
		}
	}
}
