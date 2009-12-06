/* * rhombus - Application framework for web/desktop-based Flash & Flex projects. *  *  /\ RHOMBUS *  \/ FRAMEWORK *  * Licensed under the MIT License * Copyright (c) 2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package setup{	import env.cli.CLIAppCommands;	import com.hexagonstar.display.StageReference;	import com.hexagonstar.framework.setup.ISetup;	import com.hexagonstar.framework.view.console.Console;	import flash.display.Sprite;	import flash.display.StageDisplayState;	import flash.geom.Rectangle;		/**	 * Branch-specific setup class that contains setup instructions that are being	 * executed if the application is a Flash app (and not not a Flex app).	 * 	 * @author Sascha Balkau	 * @version 1.0.0	 */	public class FlashSetup implements ISetup	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				/** @private */		private var _app:Sprite;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Constructs a new FlashSetup instance.		 */		public function FlashSetup()		{			_app = Main.app;		}						/**		 * Executes setup tasks that need to be done before the application UI is created.		 */		public function preUISetup():void		{		}						/**		 * Executes setup tasks that need to be done after the application UI is created.		 */		public function postUISetup():void		{		}						/**		 * Executes setup tasks that need to be done after the application init process		 * has finished but before the application grants user interaction or executes		 * any further things that happen after the app initialization.		 */		public function finalSetup():void		{			_app.stage.fullScreenSourceRect = new Rectangle(0, 0,				StageReference.stage.stageWidth, StageReference.stage.stageHeight);						/* Check if app should run in fullscreen mode. */			if (Main.config.useFullscreen)			{				var fullscreenMode:String = StageDisplayState.FULL_SCREEN;				/*FDT_IGNORE*/				CONFIG::IS_AIR				/*FDT_IGNORE*/				{					fullscreenMode = StageDisplayState.FULL_SCREEN_INTERACTIVE;				}				_app.stage.displayState = fullscreenMode;			}						/* Create app-specific CLI commands. */			new CLIAppCommands(Console.cli).create();		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////	}}