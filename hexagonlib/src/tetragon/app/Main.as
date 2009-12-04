/* * tetragon - Application framework for web/desktop-based Flash & Flex projects. *    ____ *   /    / TETRAGON *  /____/  FRAMEWORK *  * Licensed under the MIT License * Copyright (c) 2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package {	import model.Config;	import model.Data;	import setup.*;	import view.*;	import com.hexagonstar.display.StageReference;	import com.hexagonstar.event.CommandEvent;	import com.hexagonstar.framework.IAppInfo;	import com.hexagonstar.framework.command.env.InitApplicationCommand;	import com.hexagonstar.framework.managers.CommandManager;	import com.hexagonstar.framework.setup.*;	import com.hexagonstar.framework.util.Log;	import com.hexagonstar.framework.view.IApplicationUI;	import flash.display.DisplayObject;	import flash.display.Sprite;	import flash.events.Event;	import flash.events.EventDispatcher;	/** 	 * An event indicating that the application is ready for user interaction after	 * all initialization steps are done.	 */	[Event(name="applicationInitialized", type="flash.events.Event")]			/**	 * The Main class acts as a central hub for the application.	 */	public class Main extends EventDispatcher	{		////////////////////////////////////////////////////////////////////////////////////////		// Constants                                                                          //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Constant definition that is used to identify the app initialized event.		 */		public static const APPLICATION_INITIALIZED:String = "applicationInitialized";						////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				/** @private */		private static var _instance:Main;		/** @private */		private static var _singletonLock:Boolean = false;				/** @private */		private var _appInfo:IAppInfo;		/** @private */		private var _app:Sprite;		/** @private */		private var _ui:IApplicationUI;		/** @private */		private var _config:Config;		/** @private */		private var _data:Data;		/** @private */		private var _commandManager:CommandManager;		/** @private */		private var _setup:ISetup;		/** @private */		private var _airSetup:ISetup;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new Main instance.		 */		public function Main()		{			if (!_singletonLock)			{				throw new Error("Tried to instantiate Main through it's constructor."					+ " Use the instance property instead.");			}		}						/**		 * Initializes the application by executing the InitApplication command.		 */		public function init():void		{			_commandManager.execute(new InitApplicationCommand(),				onAppInitComplete, onAppInitError, null, onAppInitProgress);		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Returns the singleton instance of Main.		 */		public static function get instance():Main		{			if (_instance == null)			{				_singletonLock = true;				_instance = new Main();				_singletonLock = false;			}			return _instance;		}						/**		 * Returns a reference to AppInfo.		 */		public static function get appInfo():IAppInfo		{			return _instance._appInfo;		}						/**		 * Returns a reference to App.		 */		public static function get app():Sprite		{			return _instance._app;		}						/**		 * Returns a reference to the ApplicationUI.		 */		public static function get ui():IApplicationUI		{			return _instance._ui;		}						/**		 * Returns a reference to Config.		 */		public static function get config():Config		{			return _instance._config;		}						/**		 * Returns a reference to Data.		 */		public static function get data():Data		{			return _instance._data;		}						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Invoked by App after the application has finished loading. This method is		 * only used by the application entry class when the application has finished		 * preloading. It should not be called manually.		 * 		 * @private		 * @param app A reference to the application class.		 */		public function onApplicationLoaded(app:Sprite, appInfo:IAppInfo):void		{			_app = app;			_appInfo = appInfo;						setup();			init();		}						/**		 * Invoked whenever the ApplicationInitCommand dispatches a progress event.		 * 		 * @private		 */		private function onAppInitProgress(e:CommandEvent):void		{			/* After app init progress #1 the app config was loaded and we can initiate			 * the intermediate setup so that log, console and fps monitor are available			 * as soon as possible. */			if (e.progress == 1)			{				createUI();				postUISetup();			}						Log.debug("ApplicationInitProgress #" + e.progress + ": "  + e.message);		}						/**		 * Invoked if the ApplicationInitCommand dispatches an error event.		 * @private		 */		private function onAppInitError(e:CommandEvent):void		{			Log.error("ApplicationInitError: "  + e.message);		}						/**		 * Invoked when the ApplicationInitCommand dispatches a complete event.		 * @private		 */		private function onAppInitComplete(e:CommandEvent):void		{			Log.debug("ApplicationInitComplete.");						/* execute final setup steps. In an AIR app this is used to make			 * the application window visible after initialization is done. */			finalSetup();						/* Dispatch event to signal that the app is ready. */			dispatchEvent(new Event(APPLICATION_INITIALIZED));		}						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Executes tasks that need to be done before the application init process is being		 * executed. This typically includes creating the application's UI as well as		 * instantiating other objects that exist throught the whole application life time.		 * This method should only ever need to be called once during application life time,		 * i.e everything that is being set up here should only be necessary to set up once		 * and exist until the application is closed.		 * 		 * @private		 */		private function setup():void		{			/* Set stage reference as early as possible.  */			StageReference.stage = _app.stage;						/* Create standard data models. */			_config = new Config();			_data = new Data();						/* Create command manager which is used to manage command execution. */			_commandManager = CommandManager.instance;						/* Create and execute branch-specific pre-UI setups that are used to set			 * up objects that differ among the runtime and framework app types. */			preUISetup();		}						/**		 * Creates the compilation-specific setup which is used to encapsulate setup code		 * that should only be available for the compiled application type. I.e. FlashSetup		 * is used for generic web-based Flash apps, FlexSetup is used for web-based Flex		 * apps and AIRSetup is provided if the application is not a web-based app but a		 * desktop-based AIR application.		 * 		 * @private		 */		private function preUISetup():void		{			/*FDT_IGNORE*/			CONFIG::IS_FLASH			/*FDT_IGNORE*/			{				_setup = new FlashSetup();				_setup.preUISetup();			}						/*FDT_IGNORE*/			CONFIG::IS_FLEX			/*FDT_IGNORE*/			{				_setup = new FlexSetup();				_setup.preUISetup();			}						/*FDT_IGNORE*/			CONFIG::IS_AIR			/*FDT_IGNORE*/			{				_airSetup = new AIRSetup();				_airSetup.preUISetup();			}		}						/**		 * Creates the application UI. the application UI is the wrapper for all other		 * display classes. Depending on the application type it either creates an		 * ApplicationUI (for Flash-based apps) or an FlexApplicationUI (for Flex-based		 * apps).		 * 		 * @private		 */		private function createUI():void		{			/*FDT_IGNORE*/			CONFIG::IS_FLASH			/*FDT_IGNORE*/			{				_ui = new ApplicationUI();				_app.addChild(DisplayObject(_ui));			}						/*FDT_IGNORE*/			CONFIG::IS_FLEX			/*FDT_IGNORE*/			{				_ui = new FlexApplicationUI();				_app.addChild(DisplayObject(_ui));			}		}						/**		 * Executes setup tasks that are required after the UI has been created.		 * 		 * @private		 */		private function postUISetup():void		{			_setup.postUISetup();						/*FDT_IGNORE*/			CONFIG::IS_AIR			/*FDT_IGNORE*/			{				_airSetup.postUISetup();			}						/* Initialize the Logger */			Log.init();			Log.filterLevel = _config.loggingFilterLevel;			Log.enabled = _config.loggingEnabled;						/* Set the default locale as the currently used locale. */			config.currentLocale = config.defaultLocale.toLowerCase();		}						/**		 * Executes final setup steps. This needs to execute any tasks that should be done		 * after the application has finished initializing but before it becomes ready for		 * user interaction.		 * 		 * @private		 */		private function finalSetup():void		{			_setup.finalSetup();						/*FDT_IGNORE*/			CONFIG::IS_AIR			/*FDT_IGNORE*/			{				_airSetup.finalSetup();			}		}	}}