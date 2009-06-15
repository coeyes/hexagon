package model{	/**	 * A data model that is used to store config properties loaded by ConfigLoader	 * from the application config file (app.ini). This class must define all the	 * properties matching the properties added to the config file!	 * If a property was not defined or did not match, an error is sent by default	 * to the debug console.<p>	 * 	 * Ideally every defined property should have a default value assigned in case	 * the config file could not be loaded.	 * 	 * @author Sascha Balkau	 */	public class Config	{		////////////////////////////////////////////////////////////////////////////////////////		// Config Data                                                                        //		////////////////////////////////////////////////////////////////////////////////////////				public var loggingEnabled:Boolean;		public var consoleEnabled:Boolean;		public var consoleAutoOpen:Boolean;		public var consoleKey:String;		public var consoleTransparency:Number;		public var consoleMaxBufferSize:int;				public var autoCheckForUpdates:Boolean;		public var updateURL:String;				public var localePath:String;		public var defaultLocale:String;		public var currentLocale:String;				public var dataFiles:Array;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * initializes the model data.		 */		public function init():void		{			loggingEnabled = true;			consoleEnabled = true;			consoleAutoOpen = false;			consoleKey = "F8";			consoleTransparency = 0.9;			consoleMaxBufferSize = 40000;						autoCheckForUpdates = true;			updateURL = "";						localePath = "locale";			defaultLocale = Locale.ENGLISH;						dataFiles = [];		}	}}