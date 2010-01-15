/* * rhombus - Application framework for web/desktop-based Flash & Flex projects. *  *  /\ RHOMBUS *  \/ FRAMEWORK *  * Licensed under the MIT License * Copyright (c) 2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package view{	import env.cli.CLIAppCommandInvoker;	import view.screen.TestScreen;	import com.hexagonstar.framework.event.ScreenEvent;	import com.hexagonstar.framework.view.IApplicationUI;	import com.hexagonstar.framework.view.console.Console;	import com.hexagonstar.framework.view.console.FPSMonitor;	import com.hexagonstar.framework.view.screen.ScreenManager;	import flash.display.Sprite;	import flash.events.Event;		/**	 * ApplicationUI is the main wrapper for all other display objects in a Flash-based	 * application. It contains the console, the fps monitor and the screen container	 * which in turn acts as a wrapper for any screens.	 * 	 * @author Sascha Balkau	 * @version 1.0.0	 */	public class ApplicationUI extends Sprite implements IApplicationUI	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				/** @private */		protected var _screenContainer:Sprite;		/** @private */		protected var _screenManager:ScreenManager;		/** @private */		protected var _fpsMonitor:FPSMonitor;		/** @private */		protected var _console:Console;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new ApplicationUI instance.		 */		public function ApplicationUI()		{			super();			setup();		}						/**		 * Updates the view. This method should be called only if children		 * of the view need to be updated, e.g. after localization has been		 * changed or if the children need to be re-layouted.		 */		public function update():void		{			_screenManager.updateScreen();		}						/**		 * Disposes the view to clean up resources that are no longer in use. Normally		 * this is never called here since the ApplicationUI exists during the whole app lifetime.		 */		public function dispose():void		{			removeEventListeners();		}						/**		 * Returns a String Representation of the view.		 * 		 * @return A String Representation of the view.		 */		override public function toString():String		{			return "[ApplicationUI]";		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * A reference to the screen manager.		 */		public function get screenManager():ScreenManager		{			return _screenManager;		}						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Called after Main broadcasts the application initialized event.		 * @private		 */		protected function onAppInitialized(e:Event):void		{			/* You should open your initial screen here by using the screen manager. */			_screenManager.openScreen(TestScreen, true);		}						/**		 * @private		 */		protected function onScreenOpened(e:ScreenEvent):void		{		}						/**		 * @private		 */		protected function onScreenClosed(e:ScreenEvent):void		{		}						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @private		 */		protected function setup():void		{			createChildren();			layoutChildren();			addEventListeners();		}						/**		 * @private		 */		protected function createChildren():void		{			_screenContainer = new Sprite();			addChild(_screenContainer);						_screenManager = new ScreenManager(_screenContainer);						createFPSMonitor();			createConsole();		}						/**		 * @private		 */		protected function createFPSMonitor():void		{			if (!_fpsMonitor && Main.config.fpsMonitorEnabled)			{				_fpsMonitor = FPSMonitor.instance;				_fpsMonitor.pollInterval = Main.config.fpsMonitorPollInterval;				addChild(_fpsMonitor);			}		}						/**		 * @private		 */		protected function createConsole():void		{			if (!_console && Main.config.consoleEnabled)			{				_console = Console.instance;				_console.cliCommandInvoker = new CLIAppCommandInvoker();				_console.consoleEnabled = Main.config.consoleEnabled;				_console.transparency = Main.config.consoleTransparency;				_console.maxBufferSize = Main.config.consoleMaxBufferSize;				addChild(_console);								if (Main.config.consoleEnabled && Main.config.consoleAutoOpen)				{					_console.toggle();				}			}		}						/**		 * @private		 */		protected function layoutChildren():void		{		}						/**		 * @private		 */		protected function addEventListeners():void		{			Main.instance.addEventListener(Main.APPLICATION_INITIALIZED, onAppInitialized);			_screenManager.addEventListener(ScreenEvent.OPENED, onScreenOpened);			_screenManager.addEventListener(ScreenEvent.CLOSED, onScreenClosed);		}						/**		 * @private		 */		protected function removeEventListeners():void		{			Main.instance.removeEventListener(Main.APPLICATION_INITIALIZED, onAppInitialized);			_screenManager.removeEventListener(ScreenEvent.OPENED, onScreenOpened);			_screenManager.removeEventListener(ScreenEvent.CLOSED, onScreenClosed);		}	}}