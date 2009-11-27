/* * tetragon - Application framework for Flash, Flash/AIR, Flex & Flex/AIR. *  * Licensed under the MIT License * Copyright (c) 2008-2009 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.framework.command.file{	import com.hexagonstar.framework.io.loaders.ILoader;	import com.hexagonstar.pattern.cmd.Command;	import flash.events.ErrorEvent;	import flash.events.Event;		/**	 * Abstract class for commands that use an ILoader to load data.	 * 	 * @author Sascha Balkau	 * @version 1.0.0	 */	public class AbstractLoadCommand extends Command	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				/** @private */		protected var _loader:ILoader;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new AbstractLoadCommand instance.		 */		public function AbstractLoadCommand()		{			super();		}						/**		 * Executes the load command. You should override this method, instantiate the		 * required ILoader in it and place any other load preparation like for example		 * adding parsers to the ILoader and after that place a call to super.execute.		 */		override public function execute():void		{			super.execute();						_loader.addEventListener(Event.COMPLETE, onLoaderComplete);			_loader.addEventListener(ErrorEvent.ERROR, onLoaderError);			_loader.load();		}						/**		 * Aborts the command's execution.		 */		override public function abort():void		{			super.abort();			_loader.abort();		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @inheritDoc		 */		override public function get name():String		{			/* Abstract method! */			return null;		}						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @private		 */		protected function onLoaderComplete(e:Event):void		{			complete();		}						/**		 * @private		 */		protected function onLoaderError(e:ErrorEvent):void		{			notifyError(e.text);		}						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @private		 */		override protected function complete():void		{			_loader.removeEventListener(Event.COMPLETE, onLoaderComplete);			_loader.removeEventListener(ErrorEvent.ERROR, onLoaderError);			_loader.dispose();						super.complete();		}	}}