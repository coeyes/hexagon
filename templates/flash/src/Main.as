package {	import commands.CommandInvoker;	import commands.env.InitApplicationCommand;	import managers.CommandManager;	import model.Config;	import model.Locale;	import util.Log;	import view.ApplicationUI;	import com.hexagonstar.core.Application;	import com.hexagonstar.display.StageReference;	import com.hexagonstar.env.command.ICommandListener;	import com.hexagonstar.env.console.CLICommand;	import com.hexagonstar.env.console.Console;	import com.hexagonstar.env.event.CommandCompleteEvent;	import com.hexagonstar.env.event.CommandErrorEvent;	import com.hexagonstar.env.event.CommandProgressEvent;	import flash.events.Event;	import flash.events.EventDispatcher;	/** 	 * An event indicating that the application is ready for	 * user interaction after initialization steps are done.	 */	[Event(name="applicationInitialized", type="flash.events.Event")]			/**	 * The central class, or 'Mediator' of the application.	 * @author Sascha Balkau	 */	public final class Main extends EventDispatcher implements ICommandListener	{		////////////////////////////////////////////////////////////////////////////////////////		// Constants                                                                          //		////////////////////////////////////////////////////////////////////////////////////////				public static const APPLICATION_INITIALIZED:String = "applicationInitialized";						////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				private static var _instance:Main;				private var _app:Application;		private var _appInfo:AppInfo;		private var _ui:ApplicationUI;		private var _console:Console;		private var _embeddedAssets:EmbeddedAssets;		private var _commandManager:CommandManager;		private var _commandInvoker:CommandInvoker;				private var _config:Config;		private var _locale:Locale;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new instance of Main. As Main is a Singleton it is required		 * to use the instance getter instead of direct instantiation.		 */		public function Main()		{			if (_instance)			{				throw new Error("Tried to instantiate Main through"					+ " it's constructor. Use Main.instance instead!");			}		}						/**		 * Invokes the application's (user-defined) initialization process.		 * @private		 */		public function init():void		{			_commandManager.execute(new InitApplicationCommand(this));		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				public static function get instance():Main		{			if (!_instance) _instance = new Main();			return _instance;		}						public static function get app():Application		{			return _instance._app;		}						public static function get ui():ApplicationUI		{			return _instance._ui;		}						public static function get config():Config		{			return _instance._config;		}						public static function get locale():Locale		{			return _instance._locale;		}						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Invoked by App after the application has finished loading.		 * 		 * @param app a reference to the application class.		 */		public function onApplicationLoaded(app:Application):void		{			_app = app;						preInit();			init();		}						/**		 * Invoked whenever the ApplicationInitCommand dispatches a progress event.		 * @private		 */		public function onCommandProgress(e:CommandProgressEvent):void		{			Log.debug("ApplicationInitProgress #" + e.progress + ": "  + e.progressMessage);		}						/**		 * Invoked if the ApplicationInitCommand dispatches an error event.		 * @private		 */		public function onCommandError(e:CommandErrorEvent):void		{			Log.error("ApplicationInitError: " + e.text);		}						/**		 * Invoked when the ApplicationInitCommand dispatches a complete event.		 * @private		 */		public function onCommandComplete(e:CommandCompleteEvent):void		{			Log.debug("ApplicationInitComplete.");			Log.enabled = _config.loggingEnabled;						/* Dispatch event to signal that the app is ready */			dispatchEvent(new Event(APPLICATION_INITIALIZED));		}						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Executes tasks that need to be done before the init process is executed.		 * This usually includes creating the application's user interface. This method		 * should only need to be called once at application start.		 * @private		 */		private function preInit():void		{			Log.monitor(_app.stage);			Log.info(AppInfo.APP_NAME + " v" + AppInfo.APP_VERSION				+ " (build #" + AppInfo.APP_BUILD + ")");						/* Set stage reference */			StageReference.stage = _app.stage;						/* Create Config and Locale model */			_config = new Config();			_locale = new Locale();						_ui = new ApplicationUI();			_app.addChild(_ui);						/* TODO Command creation should go somewhere else! */			var cmd1:CLICommand = new CLICommand();			cmd1.command = "appInit";			cmd1.help = "Initializes the application.";			cmd1.handler = "appInit";			var cmd2:CLICommand = new CLICommand();			cmd2.command = "appInfo";			cmd2.help = "Displays application information string.";			cmd2.handler = "appInfo";						_commandManager = CommandManager.instance;			_commandInvoker = new CommandInvoker();						_console = Console.instance;			_console.setFont(EmbeddedAssets.CONSOLE_FONT, EmbeddedAssets.CONSOLE_FONT_SIZE);			_console.cliCommandInvoker = _commandInvoker;			_console.addCLICommand(cmd1);			_console.addCLICommand(cmd2);			_app.addChild(_console);		}	}}