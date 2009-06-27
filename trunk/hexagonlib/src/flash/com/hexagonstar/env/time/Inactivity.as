/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.env.time{	import com.hexagonstar.display.StageReference;	import com.hexagonstar.env.event.InactivityEvent;	import com.hexagonstar.env.event.RemovableEventDispatcher;	import com.hexagonstar.env.exec.IRunnable;	import flash.display.Stage;	import flash.events.Event;	import flash.events.KeyboardEvent;	import flash.events.MouseEvent;	[Event(name="active", type="com.hexagonstar.env.event.InactivityEvent")]	[Event(name="inactive", type="com.hexagonstar.env.event.InactivityEvent")]			/**	 * Detects user inactivity by checking for a void in mouse movement and key presses.	 * You must first initialize StageReference before using this class.	 * 	 * @example	 * <pre>	 *	package	 *	{	 *		import flash.display.Sprite;	 *		import com.hexagonstar.env.time.Inactivity;	 *		import com.hexagonstar.display.StageReference;	 *		import com.hexagonstar.env.event.InactivityEvent;	 *			 *		public class Example extends Sprite	 *		{	 *			protected var _inactivity:Inactivity;	 *				 *			public function Example()	 *			{	 *				StageReference.setStage(stage);	 *				// User should be considered inactive after 3 seconds:	 *				_inactivity = new Inactivity(3000);	 *				_inactivity.addEventListener(InactivityEvent.INACTIVE, onUserInactive);	 *				_inactivity.addEventListener(InactivityEvent.ACTIVE, onUserActive);	 *				_inactivity.start();	 *			}	 *				 *			public function onUserInactive(e:InactivityEvent):void	 *			{	 *				trace("User inactive for " + e.milliseconds + " milliseconds.");	 *			}	 *				 *			public function onUserActive(e:InactivityEvent):void	 *			{	 *				trace("User active after being inactive for " + e.milliseconds	 *				    + " milliseconds.");	 *			}	 *		}	 *	}	 * </pre>	 */	public class Inactivity extends RemovableEventDispatcher implements IRunnable	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				protected var _delay:uint;		protected var _interval:Interval;		protected var _stopwatch:Stopwatch;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates an Inactivity. You must first initialize StageReference before		 * using this class.		 * 		 * @param delay The time delay in milliseconds until a user is considered inactive.		 */		public function Inactivity(delay:uint = 3000)		{			super();						_delay = delay;			_stopwatch = new Stopwatch();		}						/**		 * Starts watching for user inactivity.		 */		public function start():void		{			if (!_interval)			{				_interval = Interval.setTimeOut(onUserInactive, delay);			}						if (_interval.running) return;						var stage:Stage = StageReference.stage;			stage.addEventListener(Event.RESIZE, onUserInput);			stage.addEventListener(KeyboardEvent.KEY_DOWN, onUserInput);			stage.addEventListener(KeyboardEvent.KEY_UP, onUserInput);			stage.addEventListener(MouseEvent.MOUSE_DOWN, onUserInput);			stage.addEventListener(MouseEvent.MOUSE_MOVE, onUserInput);						_stopwatch.start();			_interval.start();		}				/**		 * Stops watching for user inactivity.		 */		public function stop():void 		{			if (!_interval) return;						_interval.reset();						var stage:Stage = StageReference.stage;			stage.removeEventListener(Event.RESIZE, onUserInput);			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onUserInput);			stage.removeEventListener(KeyboardEvent.KEY_UP, onUserInput);			stage.removeEventListener(MouseEvent.MOUSE_DOWN, onUserInput);			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onUserInput);		}						/**		 * Disposes the object.		 */		override public function dispose():void		{			stop();			_interval.dispose();			super.dispose();		}				////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				public function get delay():uint		{			return _delay;		}		public function set delay(v:uint):void		{			_delay = v;		}						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @sends InactivityEvent#INACTIVE - Dispatched when the user is inactive.		 */		protected function onUserInactive():void		{			_interval.stop();			var e:InactivityEvent = new InactivityEvent(InactivityEvent.INACTIVE);			e.milliseconds = _interval.delay;			dispatchEvent(e);			_stopwatch.start();		}				/**		 * @sends InactivityEvent#ACTIVATED - Dispatched when the user becomes active after a period of inactivity.		 */		protected function onUserInput(event:Event):void 		{			if (!_interval.running)			{				var e:InactivityEvent = new InactivityEvent(InactivityEvent.ACTIVE);				e.milliseconds = _stopwatch.time + _interval.delay;				dispatchEvent(e);				_stopwatch.stop();			}						_interval.reset();			_interval.start();		}	}}