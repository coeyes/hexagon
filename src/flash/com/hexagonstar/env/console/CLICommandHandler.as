/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.env.console{	import com.hexagonstar.data.types.Byte;	import com.hexagonstar.data.types.Time;		import flash.system.System;	import flash.utils.getTimer;		/**	 * Handles the execution of commands entered into the Console CLI.	 */	public class CLICommandHandler	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				protected var _console:Console;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new CLICommandHandler instance.		 */		public function CLICommandHandler()		{			_console = Console.instance;		}				/**		 * consoleMessage		 */		public function consoleMessage(msg:String, level:int = 1):void		{			_console.trace(msg, level);		}						/**		 * consoleClear		 */		public function consoleClear():void		{			_console.clear();		}						/**		 * consoleHide		 */		public function consoleHide():void		{			_console.clearInput();			_console.toggle();		}						/**		 * consoleHelp		 */		public function consoleHelp(commands:Vector.<CLICommand>):void		{			var s:String = "\nConsole Commands:\n";			for each (var c:CLICommand in commands)			{				s += c.command + " (" + c.help + ")\n";			}			_console.trace(s);		}						/**		 * consoleMem		 */		public function consoleMem():void		{			_console.trace("Memory used: " + new Byte(System.totalMemory).toString());		}						/**		 * consoleTime		 */		public function consoleTime():void		{			_console.trace("Running since " + new Time(getTimer()).toString());		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////			}}