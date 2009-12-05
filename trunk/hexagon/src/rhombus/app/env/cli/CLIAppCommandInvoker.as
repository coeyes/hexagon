/*
 * rhombus - Application framework for web/desktop-based Flash & Flex projects.
 * 
 *  /\ RHOMBUS
 *  \/ FRAMEWORK
 * 
 * Licensed under the MIT License
 * Copyright (c) 2008 Sascha Balkau / Hexagon Star Softworks
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
package env.cli
{
	import com.hexagonstar.event.CommandEvent;
	import com.hexagonstar.framework.command.env.CloseApplicationCommand;
	import com.hexagonstar.framework.command.file.LoadLocaleCommand;
	import com.hexagonstar.framework.env.cli.CLICommandInvoker;
	import com.hexagonstar.framework.managers.CommandManager;
	import com.hexagonstar.framework.util.Log;
	import com.hexagonstar.framework.view.console.FPSMonitor;

	import flash.display.StageDisplayState;

	
	/**
	 * @author Sascha Balkau
	 * @version 1.0.0
	 */
	public class CLIAppCommandInvoker extends CLICommandInvoker
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new CLICommandInvoker instance.
		 */
		public function CLIAppCommandInvoker()
		{
			super();
		}
		
		
		/**
		 * appInit
		 */
		public function appInit():void
		{
			Main.instance.init();
		}
		
		
		/**
		 * appInfo
		 */
		public function appInfo():void
		{
			_console.log(Main.appInfo.name
				+ " v" + Main.appInfo.version
				+ " " + Main.appInfo.releaseStage
				+ " build #" + Main.appInfo.build
				+ " (" + Main.appInfo.buildDate
				+ ") -- copyright (c) " + Main.appInfo.copyright
				+ " " + Main.appInfo.year);
		}
		
		
		/**
		 * appFPSToggle
		 */
		public function appFPSToggle():void
		{
			FPSMonitor.instance.toggle();
		}
		
		
		/**
		 * appFullscreenToggle
		 */
		public function appFullscreenToggle():void
		{
			var state:String = Main.app.stage.displayState;
			
			/*FDT_IGNORE*/
			CONFIG::IS_AIR
			/*FDT_IGNORE*/
			{
				if (state == StageDisplayState.FULL_SCREEN_INTERACTIVE)
				{
					state = StageDisplayState.NORMAL;
				}
				else
				{
					state = StageDisplayState.FULL_SCREEN_INTERACTIVE;
				}
				Main.app.stage.displayState = state;
				return;
			}
			
			if (state == StageDisplayState.FULL_SCREEN)
			{
				state = StageDisplayState.NORMAL;
			}
			else
			{
				state = StageDisplayState.FULL_SCREEN;
			}
			Main.app.stage.displayState = state;
		}
		
		
		/**
		 * appClose
		 */
		public function appClose():void
		{
			CommandManager.instance.execute(new CloseApplicationCommand());
		}
		
		
		/**
		 * setLocale
		 */
		public function setLocale(localeID:String = ""):void
		{
			if (localeID.length > 0)
			{
				Main.commandManager.execute(new LoadLocaleCommand(localeID),
					onLoadLocaleComplete, onLoadLocaleError);
			}
			else
			{
				Log.info("Current locale: " + Main.config.currentLocale);
			}
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Event Handlers                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		protected function onLoadLocaleComplete(e:CommandEvent):void
		{
			Main.config.currentLocale = LoadLocaleCommand(e.command).localeID;
			Log.info("Locale changed to [" + Main.config.currentLocale + "].");
			/* Update UI after locale was changed. */
			Main.ui.update();
		}
		
		
		/**
		 * @private
		 */
		protected function onLoadLocaleError(e:CommandEvent):void
		{
			Log.error("Error loading locale for ["
				+ LoadLocaleCommand(e.command).localeID + "].");
		}
	}
}
