package io{	import model.Config;	import model.Locale;	import util.Log;	import com.hexagonstar.env.event.FileIOEvent;	import com.hexagonstar.io.file.types.TextFile;	import flash.events.ErrorEvent;	import flash.events.Event;		/**	 * LocaleLoader Class	 * @author Sascha Balkau	 */	public class LocaleLoader extends AbstractLoader	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				private var _hasNotified:Boolean;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new LocaleLoader instance.		 */		public function LocaleLoader()		{			super();		}						/**		 * Loads the application configuration file.		 */		override public function load():void		{			super.load();						var cfg:Config = Main.config;						_hasNotified = false;						/* If the current locale is English we don't need to load it			 * because English is built-in. If it's not English, try to load it. */			if (cfg.currentLocale == Locale.ENGLISH)			{				Locale.init();				dispatchEvent(new Event(Event.COMPLETE));			}			else			{				var path:String = cfg.localePath + "/" + cfg.currentLocale + ".locale";				var file:TextFile = new TextFile(path);				_loader.addFile(file);				_loader.load();			}		}						/**		 * Returns a String Representation of LocaleLoader.		 * 		 * @return A String Representation of LocaleLoader.		 */		override public function toString():String		{			return "[LocaleLoader]";		}						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Initiates parsing of the loaded config file into the config model object.		 * @private		 */		override public function onAllComplete(e:FileIOEvent):void		{			if (e.file.isValid)			{				parseText(e.file as TextFile);			}			else			{				notifyError("Malformed content in " + e.file.toString() + ": "					+ e.file.errorStatus);			}		}				////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Notifies any listener that an error occured during loading/checking the locale.		 * @private		 * 		 * @param msg the error message.		 */		override protected function notifyError(msg:String):void		{			if (!_hasNotified)			{				_hasNotified = true;								var e:ErrorEvent = new ErrorEvent(ErrorEvent.ERROR);				e.text = toString() + " Error loading locale: " + msg;				dispatchEvent(e);			}		}						/**		 * Parses text from a Text File into locale data.		 * @private		 */		private function parseText(file:TextFile):void		{			var text:String = file.contentAsString;			var lines:Array = text.match(/([^=\r\n]+)=(.*)/g);			var key:String;			var val:String;						for each (var l:String in lines)			{				var pos:int = l.indexOf("=");				key = trim(l.substring(0, pos));				val = trim(l.substring(pos + 1, l.length));				parseProperty(key, val);			}						dispatchEvent(new Event(Event.COMPLETE));		}						/**		 * Tries to parse the specified key and value pair into the Locale Model.		 * @private		 */		private function parseProperty(key:String, val:String):void		{			var keyExists:Boolean = true;			var p:*;						/* Check if the key found in the locale file is defined in the Locale class */			try			{				p = Locale[key];			}			catch (e:Error)			{				Log.error(toString() + " Error parsing locale string: " + e.message);				keyExists = false;			}						if (keyExists)			{					Locale[key] = val;			}		}	}}