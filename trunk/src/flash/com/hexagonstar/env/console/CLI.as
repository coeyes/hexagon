/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.env.console{	/**	 * A Comand Line Interpreter that processes inputs made in the Console's command line.	 * 	 * @author Sascha Balkau	 */	public class CLI	{		////////////////////////////////////////////////////////////////////////////////////////		// Constants                                                                          //		////////////////////////////////////////////////////////////////////////////////////////						////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				protected var _commands:Vector.<CLICommand>;		protected var _commandHandler:ICLICommandHandler;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new CLI instance.		 */		public function CLI()		{			_commands = new Vector.<CLICommand>();			addDefaultCommands();		}						/**		 * Processes the input entered in the TextInput.		 */		public function processInput(input:String):void		{			if (!_commandHandler) _commandHandler = new CLICommandHandler();						var found:Boolean = false;			for each (var c:CLICommand in _commands)			{				if (input.toLowerCase() == c.command.toLowerCase())				{					found = true;					try					{						(_commandHandler[c.handler] as Function).apply(null, c.arguments);					}					catch (e:Error)					{						_commandHandler.consoleMessage("CLI: " + e.message, Console.LEVEL_ERROR);					}					break;				}			}						if (!found)			{				_commandHandler.consoleMessage("Unknown command: " + input);			}		}						/**		 * addCommand		 */		public function addCommand(command:CLICommand):void		{			_commands.push(command);		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				public function get commandHandler():ICLICommandHandler		{			return _commandHandler;		}				public function set commandHandler(v:ICLICommandHandler):void		{			_commandHandler = v;		}						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * addDefaultCommands		 * @private		 */		protected function addDefaultCommands():void		{			var cmd1:CLICommand = new CLICommand();			cmd1.command = "clear";			cmd1.help = "Clears the console.";			cmd1.handler = "consoleClear";						var cmd2:CLICommand = new CLICommand();			cmd2.command = "gc";			cmd2.help = "Forces a garbage collection mark/sweep.";			cmd2.handler = "consoleGC";						var cmd3:CLICommand = new CLICommand();			cmd3.command = "help";			cmd3.help = "Displays the command help.";			cmd3.handler = "consoleHelp";			cmd3.arguments = [_commands];						var cmd4:CLICommand = new CLICommand();			cmd4.command = "hide";			cmd4.help = "Hides the console.";			cmd4.handler = "consoleHide";						var cmd5:CLICommand = new CLICommand();			cmd5.command = "mem";			cmd5.help = "Displays memory currently consumed by application.";			cmd5.handler = "consoleMem";						var cmd6:CLICommand = new CLICommand();			cmd6.command = "time";			cmd6.help = "Displays the time that has passed since application start.";			cmd6.handler = "consoleTime";						addCommand(cmd1);			addCommand(cmd2);			addCommand(cmd3);			addCommand(cmd4);			addCommand(cmd5);			addCommand(cmd6);		}	}}