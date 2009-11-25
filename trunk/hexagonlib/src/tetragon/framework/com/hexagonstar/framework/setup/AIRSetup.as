package com.hexagonstar.framework.setup
{
	import com.hexagonstar.env.WindowBoundsManager;
	import com.hexagonstar.framework.Main;
	import com.hexagonstar.framework.command.env.CloseApplicationCommand;

	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.geom.Rectangle;

	
	/**
	 * AIRSetup Class
	 * @author Sascha Balkau <sascha@hexagonstar.com>
	 */
	public class AIRSetup implements ISetup
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/** @private */
		private var _app:Sprite;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Constructs a new AIRSetup instance.
		 */
		public function AIRSetup()
		{
			_app = Main.app;
		}
		
		
		/**
		 * Executes setup tasks that need to be done before the application UI is created.
		 */
		public function preUISetup():void
		{
			/* set this to false, when we close the application we first do an update. */
			NativeApplication.nativeApplication.autoExit = false;
			
			/* recall app window bounds */
			WindowBoundsManager.instance.init(_app.stage.nativeWindow);
		}
		
		
		/**
		 * Executes setup tasks that need to be done after the application UI is created.
		 */
		public function postUISetup():void
		{
			/* We listen to CLOSING from both the stage and the UI. If the user closes the
			 * app through the taskbar, Event.CLOSING is emitted from the stage. Otherwise,
			 * it could be emitted from TitleBarConrols. */
			Main.ui.addEventListener(Event.CLOSING, onApplicationClosing);
			_app.stage.nativeWindow.addEventListener(Event.CLOSING, onApplicationClosing);
			_app.stage.nativeWindow.addEventListener(Event.CLOSE, onApplicationClose);
			
			_app.stage.addEventListener(FullScreenEvent.FULL_SCREEN, onFullScreen);
		}
		
		
		/**
		 * Executes setup tasks that need to be done after the application init process
		 * has been initiated and right after the application config was loaded.
		 */
		public function intermediateSetup():void
		{
		}
		
		
		/**
		 * Executes setup tasks that need to be done after the application init process
		 * has finished but before the application grants user interaction or executes
		 * any further things that happen after the app initialization.
		 */
		public function finalSetup():void
		{
			// TODO make fullScreenSourceRect size dynamic calculated!
			_app.stage.fullScreenSourceRect = new Rectangle(0, 0, 1024, 640);
			_app.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			
			/* Make application visible */
			_app.stage.nativeWindow.visible = true;
			_app.stage.nativeWindow.activate();
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Event Handlers                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		private function onApplicationClosing(e:Event):void
		{
			e.preventDefault();
			var cmd:CloseApplicationCommand = new CloseApplicationCommand();
			cmd.execute();
		}
		
		
		/**
		 * @private
		 */
		private function onApplicationClose(e:Event):void
		{
			NativeApplication.nativeApplication.exit();
		}
		
		
		/**
		 * @private
		 */
		private function onFullScreen(e:FullScreenEvent):void
		{
			if (!e.fullScreen)
			{
				WindowBoundsManager.instance.recallWindowBounds();
			}
			
		}
	}
}
