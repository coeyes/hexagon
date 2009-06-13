package managers
{
	import util.Log;

	import com.hexagonstar.io.net.SharedObjectStatus;

	import flash.events.NetStatusEvent;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;

	
	/**
	 * This is a singleton class that manages LocalSharedObject settings.
	 * It also works as a registry of settings objects names. 
	 * 
	 * @author Sascha Balkau
	 */
	public class SettingsManager
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/* Add any keys for settings stored in the Local Shared Object here as
		 * public static constants. These act as the settings key registry. */
		
		public static const DATA_PATH:String			= "dataPath";
		public static const WINDOW_POSITION:String	= "winPos";
		public static const WINDOW_SIZE:String		= "winSize";
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		private static var _instance:SettingsManager;
		private static var _singletonLock:Boolean = false;
		
		private var _so:SharedObject;
		private var _minDiskSpace:int = 51200;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new SettingsManager instance.
		 */
		public function SettingsManager()
		{
			if (!_singletonLock)
			{
				throw new Error("Tried to instantiate SettingsManager through"
					+ " it's constructor. Use SettingsManager.instance instead!");
			}
			else
			{
				setup();
			}
		}
		
		
		/**
		 * Returns the specified setting value from the LocalSharedObject.
		 * 
		 * @param key The key under which the setting is stored.
		 */
		public function getSetting(key:String):Object
		{
			return _so.data[key];
		}
		
		
		/**
		 * Tries to set and store the specified setting.
		 * 
		 * @param key The key under which the setting is being stored.
		 * @param value The value of the setting.
		 */
		public function setSetting(key:String, value:Object):void
		{
			_so.data[key] = value;
			var status:String;
			
			try
			{
				status = _so.flush(_minDiskSpace);
			}
			catch (e:Error)
			{
				Log.error(toString() + " Local settings could not be stored! ("
					+ e.message + ").");
			}
			
			if (status != null)
			{
				switch (status)
				{
					case SharedObjectFlushStatus.PENDING:
						_so.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
						break;
					case SharedObjectFlushStatus.FLUSHED:
						Log.debug(toString() + " Local settings flushed to disk.");
						break;
				}
			}
		}
		
		
		/**
		 * Purges all of the stored data and deletes the shared object from the disk.
		 */
		public function clear():void
		{
			_so.clear();
		}
		
		
		/**
		 * Returns a String Representation of SettingsManager.
		 * @return A String Representation of SettingsManager.
		 */
		public function toString():String
		{
			return "[SettingsManager]";
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		
		public static function get instance():SettingsManager
		{
			if (_instance == null)
			{
				_singletonLock = true;
				_instance = new SettingsManager();
				_singletonLock = false;
			}
			return _instance;
		}
		
		/**
		 * The minimum disk space available in bytes that ther user must
		 * grant for the settings data to be stored on disk.
		 */
		public function get minDiskSpace():int
		{
			return _minDiskSpace;
		}
		public function set minDiskSpace(v:int):void
		{
			_minDiskSpace = v;
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Event Handlers                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		private function onNetStatus(e:NetStatusEvent):void
		{
			_so.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			
			switch (e.info.code)
			{
				case SharedObjectStatus.FLUSH_SUCCESS:
					/* User granted permission, data saved! */
					break;
				case SharedObjectStatus.FLUSH_FAILED:
					/* User denied permission, data not saved! */
			        break;
			}
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Sets up the class.
		 * @private
		 */
		private function setup():void
		{
			_so = SharedObject.getLocal("localSettings");	
		}
	}
}
