package io{	import event.FileParserEvent;	import io.parsers.IFileParser;	import util.Log;	import com.hexagonstar.data.structures.queues.Queue;	import com.hexagonstar.env.event.FileIOEvent;	import com.hexagonstar.io.file.types.IFile;	import com.hexagonstar.io.file.types.XMLFile;	import com.hexagonstar.util.debug.Debug;	import flash.events.Event;		/**	 * @author Sascha Balkau	 */	public class DataFileLoader extends AbstractLoader	{		////////////////////////////////////////////////////////////////////////////////////////		// Constants                                                                          //		////////////////////////////////////////////////////////////////////////////////////////				protected static const INDEX_FILE_ID:String = "indexFile";		protected static const DATA_FILE_1_ID:String = "data1";		protected static const DATA_FILE_2_ID:String = "data2";						////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				protected var _indexFile:XMLFile;		protected var _files:Queue;		protected var _parser:IFileParser;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new instance of the class.		 */		public function DataFileLoader()		{			super();		}						/**		 * Loads the data files.		 */		override public function load():void		{			super.load();						/* Load the data index file which contains IDs and pathes to all data files */			_indexFile = new XMLFile(Main.config.dataIndexFile, INDEX_FILE_ID);			_loader.addFile(_indexFile);			_loader.load();		}						/**		 * Returns a String Representation of DataLoader.		 * @return A String Representation of DataLoader.		 */		override public function toString():String		{			return "[DataFileLoader]";		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @private		 */		override public function onComplete(e:FileIOEvent):void		{			super.onComplete(e);		}						/**		 * @private		 */		protected function onParserComplete(e:FileParserEvent):void		{			switch (e.file.id)			{			}		}						/**		 * @private		 */		override public function onAllComplete(e:FileIOEvent):void		{			super.onAllComplete(e);						if (e.file.id == INDEX_FILE_ID)			{				createDataFiles(e.file);			}			else			{				parseDataFiles();			}		}						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Notifies any listener that an error occured during loading.		 * @private		 * 		 * @param msg the error message.		 */		override protected function notifyError(msg:String):void		{			Log.error(toString() + " Error loading file: " + msg);						//var e:ErrorEvent = new ErrorEvent(ErrorEvent.ERROR);			//e.text = toString() + " Error loading file: " + msg;			//dispatchEvent(e);		}						/**		 * createDataFiles		 * @private		 */		protected function createDataFiles(file:IFile):void		{			if (file.isValid && file is XMLFile)			{				var xml:XML = XMLFile(file).contentAsXML;				_files = new Queue();								for each (var x:XML in xml.file)				{					var id:String = x.@id;					var path:String = x.@path;					var dataFile:XMLFile = new XMLFile(path, id);					_files.enqueue(dataFile);				}								loadDataFiles();			}			else			{				notifyError("XML structure of <" + file.path + "> is invalid. ("					+ file.errorStatus + ").");			}		}						/**		 * loadDataFiles		 * @private		 */		protected function loadDataFiles():void		{			if (_files.size > 0)			{				_loader.reset();				_loader.fileQueue = _files;				_loader.load();			}			else			{				dispatchEvent(new Event(Event.COMPLETE));			}		}						/**		 * parseDataFiles		 * @private		 */		protected function parseDataFiles():void		{			Debug.trace(_files.dump());			dispatchEvent(new Event(Event.COMPLETE));			//notifyError("a data file with ID '" + id + "' was not specified!");		}	}}