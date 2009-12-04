/* * rhombus - Application framework for web/desktop-based Flash & Flex projects. *  *  /\ RHOMBUS *  \/ FRAMEWORK *  * Licensed under the MIT License * Copyright (c) 2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.framework.env.cli{	/**	 * CLIDefaultCommands Class	 * 	 * @author Sascha Balkau	 * @version 1.0.0	 */	public class CLIDefaultCommands	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				/** @private */		private var _cli:CLI;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new CLIDefaultCommands instance.		 */		public function CLIDefaultCommands(cli:CLI)		{			_cli = cli;		}						/**		 * create		 */		public function create():void		{			var cmd1:CLICommand = new CLICommand();			cmd1.command = "clear";			cmd1.help = "Clears the console.";			cmd1.handler = "consoleClear";			_cli.addCommand(cmd1);						var cmd7:CLICommand = new CLICommand();			cmd7.command = "bufferSize";			cmd7.help = "Displays the currently occupied buffer size of the console.";			cmd7.handler = "consoleBufferSize";			_cli.addCommand(cmd7);						var cmd8:CLICommand = new CLICommand();			cmd8.command = "full";			cmd8.help = "Toggles console size between fullscreen and halfscreen height.";			cmd8.handler = "consoleFull";			_cli.addCommand(cmd8);						var cmd2:CLICommand = new CLICommand();			cmd2.command = "gc";			cmd2.help = "Forces a garbage collection mark/sweep.";			cmd2.handler = "consoleGC";			_cli.addCommand(cmd2);						var cmd3:CLICommand = new CLICommand();			cmd3.command = "help";			cmd3.help = "Displays the command help.";			cmd3.handler = "consoleHelp";			cmd3.arguments = [_cli.commands];			_cli.addCommand(cmd3);						var cmd4:CLICommand = new CLICommand();			cmd4.command = "hide";			cmd4.help = "Hides the console.";			cmd4.handler = "consoleHide";			_cli.addCommand(cmd4);						var cmd5:CLICommand = new CLICommand();			cmd5.command = "mem";			cmd5.help = "Displays memory currently consumed by application.";			cmd5.handler = "consoleMem";			_cli.addCommand(cmd5);						var cmd9:CLICommand = new CLICommand();			cmd9.command = "runtime";			cmd9.help = "Displays information about the runtime the application is running in.";			cmd9.handler = "consoleRuntime";			_cli.addCommand(cmd9);						var cmd6:CLICommand = new CLICommand();			cmd6.command = "time";			cmd6.help = "Displays the time that has passed since application start.";			cmd6.handler = "consoleTime";			_cli.addCommand(cmd6);		}	}}