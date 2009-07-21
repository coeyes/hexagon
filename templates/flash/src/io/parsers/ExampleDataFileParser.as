package io.parsers
{
	import util.Log;

	import com.hexagonstar.io.file.types.IFile;
	import com.hexagonstar.io.file.types.XMLFile;

	
	/**
	 * ExampleDataFileParser Class
	 * @author Sascha Balkau <sascha@hexagonstar.com>
	 */
	public class ExampleDataFileParser extends AbstractFileParser implements IFileParser
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new ExampleDataFileParser instance.
		 */
		public function ExampleDataFileParser()
		{
			super();
		}
		
		
		/**
		 * parse
		 */
		override public function parse(file:IFile):void
		{
			super.parse(file);
			
			var xml:XML = XMLFile(file).contentAsXML;
			
			for each (var x:XML in xml.entry)
			{
				/* Create a new object instance of the data model you're using for
				 * the parsed data and fill it in from the parsed xml here, e.g.:
				 * 
				 * var d:DataModel = new DataModel();
				 * d.id = x.@id;
				 * d.text = x;
				 * 
				 * After that add the data model object to a data container in the
				 * main data model:
				 * 
				 * _data.exampleDataModels.push(d);
				 */
			}
			
			Log.trace(toString() + " example data parsing complete.");
		}
	}
}
