/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.env.console{	import com.hexagonstar.data.types.Byte;	import com.hexagonstar.data.types.ColumnText;	import com.hexagonstar.data.types.Time;	import flash.system.System;	import flash.utils.getTimer;		/**	 * Handles the execution of commands entered into the Console CLI. This class	 * provides a default set of Console commands but can be extended to implement	 * application-specific commands or functions. The extending handler class must	 * then implement the ICLICommandInvoker marker interface.	 */	public class CLICommandInvoker implements ICLICommandInvoker	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				protected var _console:Console;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new CLICommandInvoker instance.		 */		public function CLICommandInvoker()		{			_console = Console.instance;		}				/**		 * consoleMessage		 */		public function consoleMessage(msg:String, level:int = 1):void		{			_console.trace(msg, level);		}						/**		 * consoleClear		 */		public function consoleClear():void		{			_console.clear();		}						/**		 * consoleHide		 */		public function consoleHide():void		{			_console.clearInput();			_console.toggle();		}						/**		 * consoleHelp		 */		public function consoleHelp(commands:Vector.<CLICommand>):void		{			var s:String = "\nConsole Commands:\n";			var t:ColumnText = new ColumnText(2);			for each (var c:CLICommand in commands)			{				t.add("\t" + c.command, "(" + c.help + ")");			}			_console.trace(s + t.toString());		}						/**		 * consoleMem		 */		public function consoleMem():void		{			_console.trace("Memory used: " + new Byte(System.totalMemory).toString());		}						/**		 * consoleTime		 */		public function consoleTime():void		{			_console.trace("Running since " + new Time(getTimer()).toString());		}						/**		 * consoleBufferSize		 */		public function consoleBufferSize():void		{			_console.trace("Current buffer size: " + _console.bufferSize + "/"				+ _console.maxBufferSize + " bytes");		}						/**		 * consoleGC		 */		public function consoleGC():void		{			var a:String = new Byte(System.totalMemory).toString();			System.gc();			var b:String = new Byte(System.totalMemory).toString();			_console.trace("Garbage collection executed, mem before: " + a + ", mem after: " + b);		}						/**		 * consoleFull		 */		public function consoleFull():void		{			_console.toggleSize();		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////	}}