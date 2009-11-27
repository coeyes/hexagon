/*
 * tetragon - Application framework for Flash, Flash/AIR, Flex & Flex/AIR.
 * 
 * Licensed under the MIT License
 * Copyright (c) 2008-2009 Sascha Balkau / Hexagon Star Softworks
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
package setup
{
	import com.hexagonstar.env.WindowBoundsManager;
	import com.hexagonstar.framework.command.env.CloseApplicationCommand;
	import com.hexagonstar.framework.setup.ISetup;

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
