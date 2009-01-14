/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.env.exec{	import com.hexagonstar.env.event.CommandCompleteEvent;	import com.hexagonstar.env.event.CommandErrorEvent;	import com.hexagonstar.env.event.CommandProgressEvent;	import com.hexagonstar.env.event.RemovableEventDispatcher;	import com.hexagonstar.env.exception.AbstractMethodException;			[Event(name="complete", type="com.hexagonstar.env.event.CommandCompleteEvent")]	[Event(name="progress", type="com.hexagonstar.env.event.CommandProgressEvent")]	[Event(name="error", type="com.hexagonstar.env.event.CommandErrorEvent")]			/**	 * An abstract class that should be extended by concrete command implementations.	 * 	 * @author Sascha Balkau	 */	public class Command extends RemovableEventDispatcher	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				protected var _progress:int = 0;		protected var _progressMessage:String;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new Command instance.		 */		public function Command()		{			super();		}						/**		 * Executes the command. Abstract method.		 */ 		public function execute():void		{			throw new AbstractMethodException("execute() must be overriden by subclasses.");		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @return The command's progress.		 */		public function get progress():int		{			return _progress;		}				/**		 * @return The Message associated to the command's progress.		 */		public function get progressMessage():String		{			return _progressMessage;		}						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Notify listeners that the command has completed.		 */ 		protected function notifyComplete():void		{			_progress = 100;			dispatchEvent(new CommandCompleteEvent(this));		}						/**		 * Notify listeners that the command has updated progress.		 */ 		protected function notifyProgress(progress:int, progressMsg:String = null):void		{			_progress = progress;			if (progressMsg) _progressMessage = progressMsg;			dispatchEvent(new CommandProgressEvent(this));		}						/**		 * Notify listeners that an error has occured executing the command.		 */ 		protected function notifyError(progress:int, errorMsg:String):void		{			_progress = progress;			var e:CommandErrorEvent = new CommandErrorEvent(this);			e.text = errorMsg;			dispatchEvent(e);		}	}}