/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.env.settings{	import com.hexagonstar.event.LocalSettingsEvent;	import com.hexagonstar.io.net.SharedObjectStatus;	import flash.events.EventDispatcher;	import flash.events.NetStatusEvent;	import flash.net.SharedObject;	import flash.net.SharedObjectFlushStatus;	/**	 * Dispatched when the settings flush is pending, i.e. if the user has permitted	 * local information storage for objects, but the amount of space allotted is not	 * sufficient to store the object and Flash Player prompts the user to allow more	 * space.	 * 	 * @eventType com.hexagonstar.event.LocalSettingsEvent.PENDING	 */	[Event(name="flushPending", type="com.hexagonstar.event.LocalSettingsEvent")]		/**	 * Dispatched when the settings has been successfully written to a file on the	 * local disk.	 * 	 * @eventType com.hexagonstar.event.LocalSettingsEvent.FLUSHED	 */	[Event(name="flushFlushed", type="com.hexagonstar.event.LocalSettingsEvent")]		/**	 * Dispatched when the settings flush failed and the settings could not be stored,	 * in particular if the user didn't grant more storage space after a FLUSH_PENDING	 * occured.	 * 	 * @eventType com.hexagonstar.event.LocalSettingsEvent.FAILED	 */	[Event(name="flushFailed", type="com.hexagonstar.event.LocalSettingsEvent")]		/**	 * Dispatched when an error occured and the settings could not be stored, e.g.	 * the user did not allow any storage of local data.	 * 	 * @eventType com.hexagonstar.event.LocalSettingsEvent.ERROR	 */	[Event(name="flushError", type="com.hexagonstar.event.LocalSettingsEvent")]			/**	 * This is a singleton class that manages LocalSharedObject settings. You can use this	 * class to store and recall persistent data to the users harddisk into a local shared	 * object.<p>	 * To store local settings with the LocalSettingsManager you first create a LocalSettings	 * object and put all settings values into it that need to be stored. Then you use the	 * store() method to store the settings to disk.	 * 	 * @example	 * <p><pre>	 *	// Create a new settings object:	 *	var ls:LocalSettings = new LocalSettings();	 *	ls.put("windowPosX", 200);	 *	ls.put("windowPosY", 150);	 *	ls.put("dataPath", "c:/user/documents/test/");	 *		 *	// Create the LocalSettingsManager, add event listeners and store the settings:	 *	var lsm:LocalSettingsManager = LocalSettingsManager.instance;	 *	lsm.addEventListener(LocalSettingsEvent.PENDING, onPending);	 *	lsm.addEventListener(LocalSettingsEvent.FLUSHED, onFlushed);	 *	lsm.addEventListener(LocalSettingsEvent.FAILED, onFailed);	 *	lsm.addEventListener(LocalSettingsEvent.ERROR, onError);	 *	lsm.store(ls);	 * </pre>	 * 	 * <p>At any time you can recall either single or all settings by using the recall()	 * or recallAll() method:	 * 	 * @example	 * <p><pre>	 *	var windowPosX:int = int(LocalSettingsManager.instance.recall("windowPosX"));	 *	var ls:LocalSettings = LocalSettingsManager.instance.recallAll();	 * </pre>	 * 	 * @see #LocalSettings	 * @author Sascha Balkau	 * @version 0.9.0	 */	public class LocalSettingsManager extends EventDispatcher	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				/** @private */		private static var _instance:LocalSettingsManager;		/** @private */		private static var _singletonLock:Boolean = false;				/** @private */		private var _so:SharedObject;		/** @private */		private var _minDiskSpace:int = 51200; /* 50 Kilobyte */						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new LocalSettingsManager instance.		 */		public function LocalSettingsManager()		{			if (!_singletonLock)			{				throw new Error("Tried to instantiate LocalSettingsManager through"					+ " it's constructor. Use LocalSettingsManager.instance instead!");			}			else			{				setup();			}		}						/**		 * Returns the specified setting value from the LocalSharedObject.		 * 		 * @param key The key under which the setting is stored.		 * @return The specified setting value from the LocalSharedObject.		 */		public function recall(key:String):Object		{			return _so.data[key];		}						/**		 * Returns a LocalSettings object with all settings that are stored in the		 * LocalSharedObject.		 * 		 * @see #LocalSettings		 * @return A LocalSettings object with all settings.		 */		public function recallAll():LocalSettings		{			var ls:LocalSettings = new LocalSettings();			for (var key:String in _so.data)			{				ls.put(key, _so.data[key]);			}			return ls;		}						/**		 * Tries to store the specified settings.		 * 		 * @see #LocalSettings		 * @param settings the settings object with data that needs to be stored.		 */		public function store(settings:LocalSettings):void		{			var status:String;			var data:Object = settings.data;						for (var key:Object in data)			{				_so.data[key] = data[key];			}						try			{				status = _so.flush(_minDiskSpace);			}			catch (e:Error)			{				// TODO Add logging.				//Log.error(toString() + " Local settings could not be stored! ("				//	+ e.message + ").");				dispatchEvent(new LocalSettingsEvent(LocalSettingsEvent.ERROR, e.message));			}						if (status != null)			{				switch (status)				{					case SharedObjectFlushStatus.PENDING:						_so.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);						dispatchEvent(new LocalSettingsEvent(LocalSettingsEvent.PENDING));						break;					case SharedObjectFlushStatus.FLUSHED:						// TODO Add logging.						//Log.debug(toString() + " Local settings flushed to disk.");						dispatchEvent(new LocalSettingsEvent(LocalSettingsEvent.FLUSHED));						break;				}			}		}						/**		 * Purges all of the stored data and deletes the shared object from the disk.		 */		public function clear():void		{			_so.clear();		}						/**		 * Returns a String Representation of LocalSettingsManager.		 * 		 * @return A String Representation of LocalSettingsManager.		 */		override public function toString():String		{			return "[LocalSettingsManager]";		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Returns the singleton instance of LocalSettingsManager.		 */		public static function get instance():LocalSettingsManager		{			if (_instance == null)			{				_singletonLock = true;				_instance = new LocalSettingsManager();				_singletonLock = false;			}			return _instance;		}				/**		 * The minimum disk space available in bytes that the user must		 * grant for the settings data to be stored on disk. The default is 51200 (50Kb).		 */		public function get minDiskSpace():int		{			return _minDiskSpace;		}		public function set minDiskSpace(v:int):void		{			_minDiskSpace = v;		}						/**		 * The current size of the local settings object, in bytes.		 */		public function get size():uint		{			return _so.size;		}				////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @private		 */		private function onNetStatus(e:NetStatusEvent):void		{			_so.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);						switch (e.info.code)			{				case SharedObjectStatus.FLUSH_SUCCESS:					/* User granted permission, data saved! */					dispatchEvent(new LocalSettingsEvent(LocalSettingsEvent.FLUSHED));					break;				case SharedObjectStatus.FLUSH_FAILED:					/* User denied permission, data not saved! */					dispatchEvent(new LocalSettingsEvent(LocalSettingsEvent.FAILED));					break;			}		}						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Sets up the class.		 * @private		 */		private function setup():void		{			try			{				_so = SharedObject.getLocal("localSettings");				}			catch (e:Error)			{				// TODO Add logging.				//Log.error(toString() + " Local settings object could not be created! ("				//	+ e.message + ").");				dispatchEvent(new LocalSettingsEvent(LocalSettingsEvent.ERROR, e.message));			}		}	}}