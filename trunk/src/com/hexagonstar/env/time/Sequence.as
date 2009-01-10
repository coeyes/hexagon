/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.env.time{	import com.hexagonstar.env.event.RemovableEventDispatcher;	import com.hexagonstar.env.event.SequenceEvent;	import com.hexagonstar.env.exec.IResumable;		import flash.events.Event;	import flash.events.IEventDispatcher;			[Event(name="start",	type="com.hexagonstar.env.event.SequenceEvent")]	[Event(name="stop",		type="com.hexagonstar.env.event.SequenceEvent")]	[Event(name="complete",	type="com.hexagonstar.env.event.SequenceEvent")]	[Event(name="resume",	type="com.hexagonstar.env.event.SequenceEvent")]	[Event(name="loop",		type="com.hexagonstar.env.event.SequenceEvent")]			/**	 * Creates a sequence of methods calls that wait for a specified event and/or delay.	 * 	 * @example	 * <pre>	 *	package	 *	{	 *		import flash.display.Sprite;	 *		import com.hexagonstar.env.time.Sequence;	 *		import com.hexagonstar.env.event.SequenceEvent;	 *			 *		public class Example extends Sprite	 * 		{	 *			private var _sequence:Sequence;	 *			private var _box:Sprite;	 * 				 *			public function Example()	 *			{	 *				_box = new Sprite();	 *				_box.graphics.beginFill(0xFF00FF);	 *				_box.graphics.drawRect(0, 0, 100, 100);	 *				_box.graphics.endFill();	 *				addChild(_box);	 *					 *				_sequence = new Sequence(true);	 *				_sequence.addTask(hideBox, 500);	 *				_sequence.addTask(showBox, 500);	 *				_sequence.addEventListener(SequenceEvent.LOOP, onLoop);	 *				_sequence.start();	 *			}	 *				 *			private function hideBox():void	 *			{	 *				_box.visible = false;	 *			}	 *				 *			private function showBox():void	 *			{	 *				_box.visible = true;	 *			}	 *				 *			private function onLoop(e:SequenceEvent):void	 *			{	 *				trace("Sequence has looped " + e.loops + " times.");	 *			}	 * 		}	 *	}	 * </pre>	 */	public class Sequence extends RemovableEventDispatcher implements IResumable	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				protected var _isRunning:Boolean;		protected var _isLooping:Boolean;		protected var _hasDelayCompleted:Boolean;		protected var _sequence:Vector.<Task>;		protected var _interval:Interval;		protected var _currentTaskID:int;		protected var _loops:int;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new Sequence.		 * 		 * @param isLooping Indicates if the Sequence repeats once		 *         completed (true); or stops (false).		 */		public function Sequence(isLooping:Boolean = false)		{			super();						_isLooping = isLooping;			_sequence = new Vector.<Task>();			_interval = Interval.setTimeOut(onDelayComplete, 1);			_currentTaskID = -1;		}						/**		 * Adds a method to be called to the Sequence.		 * 		 * @param closure The function to execute.		 * @param delay The time in milliseconds before the method will be called.		 * @param scope The event dispatcher scope in which to listen for the complete event.		 * @param completeEventName The name of the event the class waits to receive		 *         before continuing.		 * @param position Specifies the index of the insertion in the sequence order;		 *         defaults to the next position.		 */		public function addTask(closure:Function,								delay:Number = 0,								scope:IEventDispatcher = null,								completeEventName:String = null,								position:int = -1):void		{			_sequence.splice((position == -1)				? _sequence.length				: position, 0, new Task(closure, delay, scope, completeEventName));		}						/**		 * Removes a method from being called by the Sequence.		 * 		 * @param closure The function to remove from execution.		 */		public function removeTask(closure:Function):void		{			var l:int = _sequence.length;			while (l--)			{				if (_sequence[l].closure == closure)				{					_sequence[l] = null;					_sequence.splice(l, 1);				}			}		}						/**		 * Starts the Sequence from the beginning.		 * 		 * @sends SequenceEvent#START - Dispatched when Sequence starts.		 */		public function start():void		{			_interval.reset();			_isRunning = true;			_loops = 0;			onStartDelay();			createEvent(SequenceEvent.START);		}						/**		 * Stops the Sequence at its current position.		 * 		 * @sends SequenceEvent#STOP - Dispatched when Sequence stops.		 */		public function stop():void		{			if (!_isRunning) return;						_interval.reset();			_isRunning = false;			createEvent(SequenceEvent.STOP);		}						/**		 * Resumes sequence from stopped position.		 * 		 * @sends SequenceEvent#RESUME - Dispatched when Sequence is resumed.		 */		public function resume():void		{			if (!_isRunning) return; //TODO Shouldn't this be (_isRunning)?						if (_currentTaskID == -1)			{				start();				return;			}						_isRunning = true;						if (_hasDelayCompleted) onStartDelay();			else _interval.start();						createEvent(SequenceEvent.RESUME);		}						/**		 * Disposes the object.		 */		override public function dispose():void 		{			removeCurrentListener();			_interval.dispose();			super.dispose();		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Determines if the Sequence is currently running (true), or if		 * it is stopped (false).		 */		public function get isRunning():Boolean		{			return _isRunning;		}				/**		 * Indicates if the Sequence repeats once completed (true); or stops (false).		 */		public function get isLooping():Boolean		{			return _isLooping;		}				public function set isLooping(v:Boolean):void		{			_isLooping = v;		}				/**		 * The number of times the sequence has run since it started.		 */		public function get loops():int		{			return _loops;		}				protected function get current():Task		{			return _sequence[_currentTaskID];		}						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				protected function onDelayComplete():void		{			_hasDelayCompleted = true;						if (!current.completeEventName)			{				current.closure();				onStartDelay();			} 			else 			{				current.scope.addEventListener(current.completeEventName, onStartDelay);				current.closure();			}		}						/**		 * @sends SequenceEvent#LOOP - Dispatched when Sequence is completed and is looping.		 * @sends SequenceEvent#COMPLETE - Dispatched when Sequence has completed.		 */		protected function onStartDelay(e:Event = null):void		{			if (_currentTaskID != -1) removeCurrentListener();						if (!_isRunning) return;						_hasDelayCompleted = false;						if (++_currentTaskID >= _sequence.length)			{				_currentTaskID--;				removeCurrentListener();				_currentTaskID = -1;				_loops++;								if (_isLooping)				{					onStartDelay();					createEvent(SequenceEvent.LOOP);				}				else				{					createEvent(SequenceEvent.COMPLETE);				}								return;			}						if (current.delay <= 0)			{				onDelayComplete();			}			else			{				_interval.reset();				_interval.delay = current.delay;				_interval.start();			}		}						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @private		 */		protected function removeCurrentListener():void		{			if (current.completeEventName != null)				current.scope.removeEventListener(current.completeEventName, onStartDelay);		}						/**		 * @private		 */		protected function createEvent(eventName:String):void		{			var e:SequenceEvent = new SequenceEvent(eventName);			e.loops = _loops;			dispatchEvent(e);		}	}}/* ------------------------------------------------------------------------------------------- */import flash.events.IEventDispatcher;/** * Task Class */class Task {	public var closure:Function;	public var delay:Number;	public var scope:IEventDispatcher;	public var completeEventName:String;		function Task(closure:Function,					delay:Number,					scope:IEventDispatcher,					completeEventName:String)	{		this.closure = closure;		this.delay = delay;		this.scope = scope;		this.completeEventName = completeEventName;	}}