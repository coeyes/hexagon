/* * tetragon - Application framework for Flash, Flash/AIR, Flex & Flex/AIR. *  * Licensed under the MIT License * Copyright (c) 2008-2009 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.framework.env.cli{	import com.hexagonstar.data.types.Byte;	import com.hexagonstar.data.types.Time;	import com.hexagonstar.display.text.ColumnText;	import com.hexagonstar.framework.command.env.CloseApplicationCommand;	import com.hexagonstar.framework.managers.CommandManager;	import com.hexagonstar.framework.view.console.Console;	import com.hexagonstar.framework.view.console.FPSMonitor;	import flash.display.StageDisplayState;	import flash.system.Capabilities;	import flash.system.System;	import flash.utils.getTimer;		/**	 * Handles the execution of commands entered into the Console CLI. This class	 * provides a default set of Console commands but can be extended to implement	 * application-specific commands or functions. The extending handler class must	 * then implement the ICLICommandInvoker marker interface.	 * 	 * @author Sascha Balkau	 * @version 1.0.0	 */	public class CLICommandInvoker	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				/** @private */		protected var _console:Console;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new CLICommandInvoker instance.		 */		public function CLICommandInvoker(console:Console)		{			_console = console;		}				/**		 * consoleMessage		 */		public function consoleMessage(msg:String, level:int = 2):void		{			_console.log(msg, level);		}						/**		 * consoleClear		 */		public function consoleClear():void		{			_console.clear();		}						/**		 * consoleHide		 */		public function consoleHide():void		{			_console.clearInput();			_console.toggle();		}						/**		 * consoleHelp		 */		public function consoleHelp(commands:Vector.<CLICommand>):void		{			var s:String = "\nConsole Commands:\n";			var t:ColumnText = new ColumnText(2);			for each (var c:CLICommand in commands)			{				t.add(["\t" + c.command, "(" + c.help + ")"]);			}			_console.log(s + t.toString());		}						/**		 * consoleMem		 */		public function consoleMem():void		{			_console.log("Memory used: " + new Byte(System.totalMemory).toString());		}						/**		 * consoleTime		 */		public function consoleTime():void		{			_console.log("Running since " + new Time(getTimer()).toString());		}						/**		 * consoleBufferSize		 */		public function consoleBufferSize():void		{			_console.log("Current buffer size: " + _console.bufferSize + "/"				+ _console.maxBufferSize + " bytes");		}						/**		 * consoleGC		 */		public function consoleGC():void		{			var a:String = new Byte(System.totalMemory).toString();			System.gc();			var b:String = new Byte(System.totalMemory).toString();			_console.log("Garbage collection executed, mem before: " + a + ", mem after: " + b);		}						/**		 * consoleFull		 */		public function consoleFull():void		{			_console.toggleSize();		}						/**		 * consoleRuntime		 */		public function consoleRuntime():void		{			var d:String = Capabilities.isDebugger.toString();			var t:String = Capabilities.playerType;			var v:String = Capabilities.version;			var a:Array = v.split(" ");			var p:String = a.shift();			a = String(a[0]).split(",");			v = a[0] + "." + a[1] + "." + a[2] + " (" + a[3] + ")";			_console.log("runtime version: " + v + ", type: " + t + ", platform: " + p				+ ", debugger: " + d);		}						/**		 * appInit		 */		public function appInit():void		{			Main.instance.init();		}						/**		 * appInfo		 */		public function appInfo():void		{			_console.log(Main.appInfo.name				+ " v" + Main.appInfo.version				+ " " + Main.appInfo.releaseStage				+ " build #" + Main.appInfo.build				+ " (" + Main.appInfo.buildDate				+ ") -- " + Main.appInfo.copyright				+ " " + Main.appInfo.year);		}						/**		 * appFPSToggle		 */		public function appFPSToggle():void		{			FPSMonitor.instance.toggle();		}						/**		 * appFullscreenToggle		 */		public function appFullscreenToggle():void		{			var state:String = Main.app.stage.displayState;						/*FDT_IGNORE*/			CONFIG::IS_AIR			/*FDT_IGNORE*/			{				if (state == StageDisplayState.FULL_SCREEN_INTERACTIVE)				{					state = StageDisplayState.NORMAL;				}				else				{					state = StageDisplayState.FULL_SCREEN_INTERACTIVE;				}				Main.app.stage.displayState = state;				return;			}						if (state == StageDisplayState.FULL_SCREEN)			{				state = StageDisplayState.NORMAL;			}			else			{				state = StageDisplayState.FULL_SCREEN;			}			Main.app.stage.displayState = state;		}						/**		 * appClose		 */		public function appClose():void		{			CommandManager.instance.execute(new CloseApplicationCommand());		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				public function get console():Console		{			return _console;		}		public function set console(v:Console):void		{			_console = v;		}						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////	}}