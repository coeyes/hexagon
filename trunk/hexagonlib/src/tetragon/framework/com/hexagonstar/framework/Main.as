/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.framework{	import com.hexagonstar.display.StageReference;	import com.hexagonstar.event.CommandEvent;	import com.hexagonstar.framework.command.env.InitApplicationCommand;	import com.hexagonstar.framework.env.cli.CLICommand;	import com.hexagonstar.framework.managers.CommandManager;	import com.hexagonstar.framework.model.Config;	import com.hexagonstar.framework.model.Data;	import com.hexagonstar.framework.setup.*;	import com.hexagonstar.framework.util.Log;	import com.hexagonstar.framework.view.ApplicationUI;	import com.hexagonstar.framework.view.FlexApplicationUI;	import com.hexagonstar.framework.view.IApplicationUI;	import com.hexagonstar.framework.view.console.Console;	import flash.display.DisplayObject;	import flash.display.Sprite;	import flash.events.Event;	import flash.events.EventDispatcher;	/** 	 * An event indicating that the application is ready for user interaction after	 * all initialization steps are done.	 */	[Event(name="applicationInitialized", type="flash.events.Event")]			/**	 * Main Class	 */	public class Main extends EventDispatcher	{		////////////////////////////////////////////////////////////////////////////////////////		// Constants                                                                          //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Constant definition that is used to identify the app initialized event.		 */		public static const APPLICATION_INITIALIZED:String = "applicationInitialized";						////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				/** @private */		private static var _instance:Main;		/** @private */		private static var _singletonLock:Boolean = false;				/** @private */		private var _appInfo:AppInfo = new AppInfo();		/** @private */		//private var _embeddedAssets:EmbeddedAssets;				/** @private */		private var _app:Sprite;		/** @private */		private var _ui:IApplicationUI;		/** @private */		private var _config:Config;		/** @private */		private var _data:Data;		/** @private */		private var _commandManager:CommandManager;		/** @private */		private var _setup:ISetup;		/** @private */		private var _airSetup:ISetup;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new Main instance.		 */		public function Main()		{			if (!_singletonLock)			{				throw new Error("Tried to instantiate Main through it's constructor."					+ " Use the instance property instead.");			}		}						/**		 * Initializes the application by executing the InitApplication command.		 */		public function init():void		{			_commandManager.execute(new InitApplicationCommand(),				onAppInitComplete, onAppInitError, null, onAppInitProgress);		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Returns the singleton instance of Main.		 */		public static function get instance():Main		{			if (_instance == null)			{				_singletonLock = true;				_instance = new Main();				_singletonLock = false;			}			return _instance;		}						/**		 * Returns a reference to AppInfo.		 */		public static function get appInfo():AppInfo		{			return _instance._appInfo;		}						/**		 * Returns a reference to App.		 */		public static function get app():Sprite		{			return _instance._app;		}						/**		 * Returns a reference to the ApplicationUI.		 */		public static function get ui():IApplicationUI		{			return _instance._ui;		}						/**		 * Returns a reference to Config.		 */		public static function get config():Config		{			return _instance._config;		}						/**		 * Returns a reference to Data.		 */		public static function get data():Data		{			return _instance._data;		}						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Invoked by App after the application has finished loading. This method is		 * only used by the application entry class when the application has finished		 * preloading. It should not be called manually.		 * 		 * @private		 * @param app A reference to the application class.		 */		public function onApplicationLoaded(app:Sprite):void		{			_app = app;			setup();			init();		}						/**		 * Invoked whenever the ApplicationInitCommand dispatches a progress event.		 * 		 * @private		 */		private function onAppInitProgress(e:CommandEvent):void		{			/* After app init progress #1 the app config was loaded and we can initiate			 * the intermediate setup so that log, console and fps monitor are available			 * as soon as possible. */			if (e.progress == 1)			{				intermediateSetup();			}						Log.debug("ApplicationInitProgress #" + e.progress + ": "  + e.message);		}						/**		 * Invoked if the ApplicationInitCommand dispatches an error event.		 * @private		 */		private function onAppInitError(e:CommandEvent):void		{			Log.error("ApplicationInitError: "  + e.message);		}						/**		 * Invoked when the ApplicationInitCommand dispatches a complete event.		 * @private		 */		private function onAppInitComplete(e:CommandEvent):void		{			Log.debug("ApplicationInitComplete.");						/* execute final setup steps. In an AIR app this is used to make			 * the application window visible after initialization is done. */			finalSetup();						/* Dispatch event to signal that the app is ready. */			dispatchEvent(new Event(APPLICATION_INITIALIZED));		}						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Executes tasks that need to be done before the application init process is being		 * executed. This typically includes creating the application's UI as well as		 * instantiating other objects that exist throught the whole application life time.		 * This method should only ever need to be called once during application life time,		 * i.e everything that is being set up here should only be necessary to set up once		 * and exist until the application is closed.		 * 		 * @private		 */		private function setup():void		{			/* Set stage reference as early as possible.  */			StageReference.stage = _app.stage;						/* Create standard data models. */			_config = new Config();			_data = new Data();						/* Create command manager which is used to manage command execution. */			_commandManager = CommandManager.instance;						/* Create and execute branch-specific pre-UI setups that are used to set			 * up objects that differ among the runtime and framework app types. */			preUISetup();			 			 /* Create the application UI. */			createUI();						/* Execute post-UI setups. */			postUISetup();		}						/**		 * Creates the compilation-specific setup which is used to encapsulate setup code		 * that should only be available for the compiled application type. I.e. FlashSetup		 * is used for generic web-based Flash apps, FlexSetup is used for web-based Flex		 * apps and AIRSetup is provided if the application is not a web-based app but a		 * desktop-based AIR application.		 * 		 * @private		 */		private function preUISetup():void		{			/*FDT_IGNORE*/			CONFIG::IS_FLASH			/*FDT_IGNORE*/			{				_setup = new FlashSetup();				_setup.preUISetup();			}						/*FDT_IGNORE*/			CONFIG::IS_FLEX			/*FDT_IGNORE*/			{				_setup = new FlexSetup();				_setup.preUISetup();			}						/*FDT_IGNORE*/			CONFIG::IS_AIR			/*FDT_IGNORE*/			{				_airSetup = new AIRSetup();				_airSetup.preUISetup();			}		}						/**		 * Creates the application UI. the application UI is the wrapper for all other		 * display classes. Depending on the application type it either creates an		 * ApplicationUI (for Flash-based apps) or an FlexApplicationUI (for Flex-based		 * apps).		 * 		 * @private		 */		private function createUI():void		{			/*FDT_IGNORE*/			CONFIG::IS_FLASH			/*FDT_IGNORE*/			{				_ui = new ApplicationUI();				_app.addChild(DisplayObject(_ui));			}						/*FDT_IGNORE*/			CONFIG::IS_FLEX			/*FDT_IGNORE*/			{				_ui = new FlexApplicationUI();				_app.addChild(DisplayObject(_ui));			}		}						/**		 * Executes setup tasks that are required after the UI has been created.		 * 		 * @private		 */		private function postUISetup():void		{			_setup.postUISetup();						/*FDT_IGNORE*/			CONFIG::IS_AIR			/*FDT_IGNORE*/			{				_airSetup.postUISetup();			}		}						/**		 * Executes actions and sets config properties that should be available right after		 * the app.ini has been loaded but before any other data is loaded. Called by		 * Main.onCommandProgress and doesn't need to be called manually.		 * 		 * @private		 */		private function intermediateSetup():void		{			/* Initialize the Logger */			Log.init();			Log.filterLevel = _config.loggingFilterLevel;			Log.enabled = _config.loggingEnabled;						/* Set the default locale as the currently used locale. */			config.currentLocale = config.defaultLocale.toLowerCase();						/* Call intermediateSetup tasks dependable on used compilation type. */			_setup.intermediateSetup();		}						/**		 * Executes final setup steps. This needs to execute any tasks that should be done		 * after the application has finished initializing but before it becomes ready for		 * user interaction.		 * 		 * @private		 */		private function finalSetup():void		{			_setup.finalSetup();						/*FDT_IGNORE*/			CONFIG::IS_AIR			/*FDT_IGNORE*/			{				_airSetup.finalSetup();			}						createConsoleCommands();		}						/**		 * createConsoleCommands		 * @private		 */		private function createConsoleCommands():void		{			var console:Console = Console.instance;						var cmd1:CLICommand = new CLICommand();			cmd1.command = "appInit";			cmd1.help = "Initializes the application.";			cmd1.handler = "appInit";			console.addCLICommand(cmd1);						var cmd2:CLICommand = new CLICommand();			cmd2.command = "appInfo";			cmd2.help = "Displays application information string.";			cmd2.handler = "appInfo";			console.addCLICommand(cmd2);						if (_config.fpsMonitorEnabled)			{				var cmd3:CLICommand = new CLICommand();				cmd3.command = "appFPS";				cmd3.help = "Toggles the FPS Monitor on/off.";				cmd3.handler = "appFPSToggle";				console.addCLICommand(cmd3);			}						var cmd4:CLICommand = new CLICommand();			cmd4.command = "appFullscreen";			cmd4.help = "Toggles fullscreen mode on/off.";			cmd4.handler = "appFullscreenToggle";			console.addCLICommand(cmd4);						var cmd5:CLICommand = new CLICommand();			cmd5.command = "appClose";			cmd5.help = "Closes the application.";			cmd5.handler = "appClose";			console.addCLICommand(cmd5);		}	}}