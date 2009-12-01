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
package com.hexagonstar.framework.managers
{
	import com.hexagonstar.event.CommandEvent;
	import com.hexagonstar.pattern.cmd.Command;
	import com.hexagonstar.pattern.cmd.ICommandListener;
	import com.hexagonstar.pattern.cmd.PausableCommand;

	
	/**
	 * A Singleton that can be used to manage command execution. You call the execute
	 * method and specify a command and any handler methods that should be notified of
	 * broadcasted command events. After the command has finished execution all it's
	 * event listeners are automatically removed. The CommandManager also makes sure
	 * that the same command is not executed more than once at the same time.
	 * 
	 * @see com.hexagonstar.pattern.cmd.Command
	 * @see com.hexagonstar.pattern.cmd.CompositeCommand
	 * @see com.hexagonstar.pattern.cmd.PausableCommand
	 * @see com.hexagonstar.pattern.cmd.ICommandListener
	 * @see com.hexagonstar.event.CommandEvent
	 * 
	 * @author Sascha Balkau
	 * @version 1.0.0
	 */
	public class CommandManager implements ICommandListener
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/** @private */
		private static var _instance:CommandManager;
		/** @private */
		private static var _singletonLock:Boolean = false;
		
		/** @private */
		private var _executingCommands:Vector.<CommandDO>;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new instance of the class.
		 */
		public function CommandManager()
		{
			if (!_singletonLock)
			{
				throw new Error("Tried to instantiate CommandManager through"
					+ " it's constructor. Use CommandManager.instance instead!");
			}
			
			_executingCommands = new Vector.<CommandDO>();
		}

		
		/**
		 * Executes the specified command.
		 * 
		 * @param cmd The command to execute.
		 * @param completeHandler An optional complete handler that is called once the
		 *            command has completed.
		 * @param errorHandler An optional error handler that is called if the command
		 *            broadcasts an error event.
		 * @param abortHandler An optional abort handler that is called if the command
		 *            has been aborted.
		 * @param progressHandler An optional complete handler that is called everytime the
		 *            command broadcasts a progress event.
		 * @return true if the command is being executed successfully, false if not (e.g. if
		 *         the same command instance is already in execution).
		 */
		public function execute(cmd:Command,
								   completeHandler:Function = null,
								   errorHandler:Function = null,
								   abortHandler:Function = null,
								   progressHandler:Function = null):Boolean
		{
			if (!isExecuting(cmd))
			{
				var c:CommandDO = new CommandDO();
				c.command = cmd;
				c.completeHandler = completeHandler;
				c.errorHandler = errorHandler;
				c.abortHandler = abortHandler;
				c.progressHandler = progressHandler;
				
				_executingCommands.push(c);
				addCommandListeners(c);
				cmd.execute();
				
				return true;
			}
			else
			{
				/* Do nothing else if specified command is currently in execution. */
				return false;
			}
		}
		
		
		/**
		 * Aborts all currently executed commands.
		 */
		public function abortAll():void
		{
			for each (var c:CommandDO in _executingCommands)
			{
				c.command.abort();
			}
		}
		
		
		/**
		 * Checks if the specified command is currently being executed.
		 */
		public function isExecuting(cmd:Command):Boolean
		{
			for each (var c:CommandDO in _executingCommands)
			{
				if (cmd == c.command) return true;
			}
			return false;
		}
		
		
		/**
		 * Returns a String Representation of CommandManager.
		 * 
		 * @return A String Representation of CommandManager.
		 */
		public function toString():String
		{
			return "[CommandManager]";
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Returns the singleton instance of CommandManager.
		 */
		public static function get instance():CommandManager
		{
			if (_instance == null)
			{
				_singletonLock = true;
				_instance = new CommandManager();
				_singletonLock = false;
			}
			return _instance;
		}
		
		
		/**
		 * Returns the amount of commands that are currently in execution.
		 */
		public function get executingCommandCount():int
		{
			return _executingCommands.length;
		}
		
		
		/**
		 * Pauses or unpauses all currently executed commands that support being paused and
		 * unpaused.
		 */
		public function set paused(v:Boolean):void
		{
			for each (var c:CommandDO in _executingCommands)
			{
				if (c.command is PausableCommand)
				{
					PausableCommand(c.command).paused = v;
				}
			}
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Event Handlers                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		public function onCommandComplete(e:CommandEvent):void
		{
			/* After complete remove the command from the executing commands queue */
			removeCommand(e.command);
		}
		
		
		/**
		 * @private
		 */
		public function onCommandAbort(e:CommandEvent):void
		{
			/* After abort remove the command from the executing commands queue */
			removeCommand(e.command);
		}
		
		
		/**
		 * @private
		 */
		public function onCommandError(e:CommandEvent):void
		{
			/* Only used for debugging! */
		}
		
		
		/**
		 * @private
		 */
		public function onCommandProgress(e:CommandEvent):void
		{
			/* Only used for debugging! */
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Adds event listeners for the command in the specified commandDO. If the command's
		 * listener property has a listener object assigned this will add event listeners to
		 * that listener object. Otherwise it will check if any of the optional event
		 * handlers were specified with a call to CommandManager.execute() and if any of
		 * them are assigned this method adds event listeners to these.
		 * 
		 * @private
		 * @param cmdDO The command data object with the command that needs listeners added.
		 */
		private function addCommandListeners(cmdDO:CommandDO):void
		{
			var cmd:Command = cmdDO.command;
			var l:ICommandListener = cmd.listener;
			
			/* If the command has a listener assigned we use it to broadcast events
			 * to. Otherwise the command must have handler methods manually assigned */
			if (l)
			{
				cmd.addEventListener(CommandEvent.COMPLETE, l.onCommandComplete);
				cmd.addEventListener(CommandEvent.ERROR, l.onCommandError);
				cmd.addEventListener(CommandEvent.ABORT, l.onCommandAbort);
				cmd.addEventListener(CommandEvent.PROGRESS, l.onCommandProgress);
			}
			else
			{
				if (cmdDO.completeHandler != null)
					cmd.addEventListener(CommandEvent.COMPLETE, cmdDO.completeHandler);
				if (cmdDO.errorHandler != null)
					cmd.addEventListener(CommandEvent.ERROR, cmdDO.errorHandler);
				if (cmdDO.abortHandler != null)
					cmd.addEventListener(CommandEvent.ABORT, cmdDO.abortHandler);
				if (cmdDO.progressHandler != null)
					cmd.addEventListener(CommandEvent.PROGRESS, cmdDO.progressHandler);
			}
			
			/* Add event listeners that call handlers in the command manager */
			cmd.addEventListener(CommandEvent.COMPLETE, onCommandComplete);
			cmd.addEventListener(CommandEvent.ERROR, onCommandError);
			cmd.addEventListener(CommandEvent.ABORT, onCommandAbort);
			cmd.addEventListener(CommandEvent.PROGRESS, onCommandProgress);
		}
		
		
		/**
		 * First tries to find the commandDO that is associated with the specified command
		 * and removes it from the executing commands queue. After that any event listeners
		 * are removed from the command.
		 * 
		 * @private
		 * @param c The command to remove.
		 */
		private function removeCommand(c:Command):void
		{
			/* Find the commandDO that the specified command is part of and remove it */
			var cmdDO:CommandDO;
			for (var i:int = 0; i < _executingCommands.length; i++)
			{
				if (c == _executingCommands[i].command)
				{
					cmdDO = _executingCommands.splice(i, 1)[0];
					break;
				}
			}
			
			/* Remove all event listeners from the command */
			if (cmdDO)
			{
				var cmd:Command = cmdDO.command;
				var l:ICommandListener = cmd.listener;
				
				if (l)
				{
					cmd.removeEventListener(CommandEvent.COMPLETE, l.onCommandComplete);
					cmd.removeEventListener(CommandEvent.ERROR, l.onCommandError);
					cmd.removeEventListener(CommandEvent.ABORT, l.onCommandAbort);
					cmd.removeEventListener(CommandEvent.PROGRESS, l.onCommandProgress);
				}
				
				if (cmdDO.completeHandler != null)
					cmd.removeEventListener(CommandEvent.COMPLETE, cmdDO.completeHandler);
				if (cmdDO.errorHandler != null)
					cmd.removeEventListener(CommandEvent.ERROR, cmdDO.errorHandler);
				if (cmdDO.abortHandler != null)
					cmd.removeEventListener(CommandEvent.ABORT, cmdDO.abortHandler);
				if (cmdDO.progressHandler != null)
					cmd.removeEventListener(CommandEvent.PROGRESS, cmdDO.progressHandler);
				
				cmd.removeEventListener(CommandEvent.COMPLETE, onCommandComplete);
				cmd.removeEventListener(CommandEvent.ERROR, onCommandError);
				cmd.removeEventListener(CommandEvent.ABORT, onCommandAbort);
				cmd.removeEventListener(CommandEvent.PROGRESS, onCommandProgress);
			}
			else
			{
				/* CommandDO belonging to the command was not found,
				 * something's foul here. This should never happen! */
				 throw new Error(toString() + " no CommandDO found for the command!");
			}
		}
	}
}

import com.hexagonstar.pattern.cmd.Command;


/**
 * Command Data Object
 * @private
 */
class CommandDO
{
	public var command:Command;
	public var completeHandler:Function;
	public var errorHandler:Function;
	public var abortHandler:Function;
	public var progressHandler:Function;
}
