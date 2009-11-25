/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.env{	import com.hexagonstar.env.settings.LocalSettings;	import com.hexagonstar.env.settings.LocalSettingsManager;	import flash.display.NativeWindow;	import flash.display.Screen;	import flash.events.NativeWindowBoundsEvent;	import flash.geom.Point;		/**	 * @author Sascha Balkau	 */	public class WindowBoundsManager	{		////////////////////////////////////////////////////////////////////////////////////////		// Constants                                                                          //		////////////////////////////////////////////////////////////////////////////////////////				/** @private */		private static const WINDOW_POSITION:String	= "windowPosition";		/** @private */		private static const WINDOW_SIZE:String		= "windowSize";						////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				/** @private */		private static var _instance:WindowBoundsManager;		/** @private */		private static var _singletonLock:Boolean = false;				/** @private */		private var _settingsManager:LocalSettingsManager;		/** @private */		private var _settings:LocalSettings;		/** @private */		private var _window:NativeWindow;		/** @private */		private var _isInitialized:Boolean;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new instance of the class.		 */		public function WindowBoundsManager()		{			if (!_singletonLock)			{				throw new Error("Tried to instantiate WindowBoundsManager through"					+ " it's constructor. Use the instance property instead.");			}						_settingsManager = LocalSettingsManager.instance;			_settings = new LocalSettings();			_isInitialized = false;		}						/**		 * Init the manager for the given window.		 */		public function init(window:NativeWindow):void		{			if (!_isInitialized)			{				_isInitialized = true;				_window = window;								recallWindowBounds();								_window.addEventListener(NativeWindowBoundsEvent.RESIZE, onWindowResize);				_window.addEventListener(NativeWindowBoundsEvent.MOVE, onWindowMove);			}		}						/**		 * Saves the window position and size.		 */		public function storeWindowBounds():void		{			var winPos:Point = _window.bounds.topLeft;			var winSize:Point = new Point();			winSize.x = _window.bounds.bottomRight.x - winPos.x;			winSize.y = _window.bounds.bottomRight.y - winPos.y;						_settings.put(WINDOW_POSITION, winPos);			_settings.put(WINDOW_SIZE, winSize);						_settingsManager.store(_settings);		}						/**		 * recallWindowBounds		 */		public function recallWindowBounds():void		{			var maxWinSize:Point = getMaxWinSize();			var lastPos:Object = _settingsManager.recall(WINDOW_POSITION);			var lastSize:Object = _settingsManager.recall(WINDOW_SIZE);						if (lastPos)			{				_window.x = lastPos["x"];				_window.y = lastPos["y"];			}						if (lastSize)			{				_window.width = lastSize["x"];				_window.height = lastSize["y"];			}		}						/**		 * Check the position of the window, ensuring that its onscreen.		 * (Does nothing at the moment).		 */		public function ensureWindowOnscreen():void		{			// TODO		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Returns the singleton instance of WindowBoundsManager.		 */		public static function get instance():WindowBoundsManager		{			if (_instance == null)			{				_singletonLock = true;				_instance = new WindowBoundsManager();				_singletonLock = false;			}			return _instance;		}						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @private		 */		private function onWindowResize(e:NativeWindowBoundsEvent = null):void		{			ensureWindowOnscreen();		}						/**		 * @private		 */		private function onWindowMove(e:NativeWindowBoundsEvent):void		{			ensureWindowOnscreen();		}						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Helper function to get the maximum window position, as best we can.		 */ 		private function getMaxWinSize():Point		{			var screen:Screen = Screen(Screen.getScreensForRectangle(_window.bounds)[0]);			return screen.visibleBounds.bottomRight;		}	}}