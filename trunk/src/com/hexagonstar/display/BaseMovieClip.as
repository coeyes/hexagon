/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.display{	import com.hexagonstar.env.IDisposable;	import com.hexagonstar.env.event.IRemovableEventDispatcher;	import com.hexagonstar.env.event.ListenerManager;	import com.hexagonstar.env.time.EnterFrame;		import flash.display.FrameLabel;	import flash.display.MovieClip;	import flash.events.Event;			/**	 * A MovieClip that adhere's to the IRemovableEventDispatcher and IDisposable and that	 * provides several new features like an isPlaying property, framescript listeners	 * and reverse playback.	 * 	 * TODO Reverse Playback code needs testing!!	 */	public class BaseMovieClip extends MovieClip implements IRemovableEventDispatcher,		IDisposable	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				protected var _isPlaying:Boolean = true;		protected var _listenerManager:ListenerManager;		protected var _isDisposed:Boolean;		protected var _isReversing:Boolean;		protected var _reverseController:EnterFrame;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new BaseMovieClip instance.		 */		public function BaseMovieClip()		{			super();			_listenerManager = ListenerManager.getManager(this);			_reverseController = EnterFrame.instance;			addFrameScripts();		}						/**		 * {@inheritDoc}		 */		override public function gotoAndPlay(frame:Object, scene:String = null):void		{			_isPlaying = true;			stopReversing();			super.gotoAndPlay(frame, scene);		}						/**		 * Sends the playhead to the specified frame on and reverses from that frame.		 * 		 * @param frame A number representing the frame number, or a string representing		 *         the label of the frame, to which the playhead is sent.		 */		public function gotoAndReverse(frame:Object):void		{			_isPlaying = true;			super.gotoAndStop(frame);			playReverse();		}						/**		 * {@inheritDoc}		 */		override public function gotoAndStop(frame:Object, scene:String = null):void		{			/* If we are reversing, we are also still playing. */			if (!_isReversing)			{				_isPlaying = false;				stopReversing();			}						super.gotoAndStop(frame, scene);		}						/**		 * {@inheritDoc}		 */		override public function nextFrame():void		{			_isPlaying = false;			stopReversing();			super.nextFrame();		}						/**		 * {@inheritDoc}		 */		override public function nextScene():void		{			_isPlaying = true;			stopReversing();			super.nextScene();		}						/**		 * {@inheritDoc}		 */		override public function play():void		{			_isPlaying = true;			stopReversing();			super.play();		}						/**		 * The opposite of play(). Plays the timeline in reverse from the		 * current playhead position.		 */		public function reverse():void		{			_isPlaying = true;			playReverse();		}						/**		 * {@inheritDoc}		 */		override public function prevFrame():void		{			/* If we are reversing, we are also still playing. */			if (!_isReversing) _isPlaying = false;						super.prevFrame();		}						/**		 * {@inheritDoc}		 */		override public function prevScene():void		{			_isPlaying = true;			super.prevScene();		}						/**		 * {@inheritDoc}		 */		override public function stop():void		{			_isPlaying = false;			stopReversing();			super.stop();		}						/**		 * @exclude		 */		override public function addEventListener(type:String,													listener:Function,													useCapture:Boolean = false,													priority:int = 0,													useWeakReference:Boolean = false):void		{			super.addEventListener(type, listener, useCapture, priority, useWeakReference);			_listenerManager.addEventListener(type, listener, useCapture, priority,				useWeakReference);		}				/**		 * @exclude		 */		override public function removeEventListener(type:String,													listener:Function,													useCapture:Boolean = false):void		{			super.removeEventListener(type, listener, useCapture);			_listenerManager.removeEventListener(type, listener, useCapture);		}				/**		 * Removes all event listeners.		 */		public function removeEventListeners():void		{			if (_reverseController.hasEventListener(Event.ENTER_FRAME))				_reverseController.removeEventListener(Event.ENTER_FRAME, onReversing);						_listenerManager.removeEventListeners();		}						/**		 * Removes all events that report to the specified listener.		 * 		 * @param listener The listener function that processes the event.		 */		public function removeEventsForListener(listener:Function):void		{			_listenerManager.removeEventsForListener(listener);		}						/**		 * Removes all events of a specific type.		 * 		 * @param type The type of event.		 */		public function removeEventsForType(type:String):void		{			_listenerManager.removeEventsForType(type);		}						/**		 * {@inheritDoc}		 * 		 * Calling dispose on a base display object also removes it from its current parent.		 */		public function dispose():void 		{			removeEventListeners();			_listenerManager.dispose();			_isDisposed = true;						if (parent) parent.removeChild(this);		}						/**		 * Returns a string representation of the object		 * 		 * @return A string representation of the object.		 */		override public function toString():String		{			return "[BaseMovieClip, totalFrames=" + totalFrames + "]";		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @return true if the MovieClip is playing, otherwise false.		 */		public function get isPlaying():Boolean		{			return _isPlaying;		}				/**		 * Determines if the MovieClip is currently reversing (true), or is		 * stopped or playing (false).		 */		public function get isReversing():Boolean		{			return _isReversing;		}				public function get isDisposed():Boolean 		{			return this._isDisposed;		}				////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Dispatches an event that consists of the exact framelabel String		 * of the frame that the MovieClip's playhead is currently in.		 * 		 * @private		 */		protected function onFrameLabel():void		{			dispatchEvent(new Event(currentLabel, true));		}						/**		 * Invoked whenever the playhead reverses.		 * @private		 */		protected function onReversing(e:Event):void		{			if (currentFrame == 1) gotoAndStop(totalFrames);			else prevFrame();		}						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Adds frame scripts so that events can be dispatched when a specific		 * frame label is reached.		 * 		 * @private		 */		protected function addFrameScripts():void		{			var l:int = currentLabels.length;			for (var i:int = 0; i < l; i++)			{				var label:FrameLabel = currentLabels[i];				addFrameScript(label.frame - 1, onFrameLabel);			}		}						/**		 * @private		 */		protected function playReverse():void		{			if (_isReversing) return;						_isReversing = true;			_reverseController.addEventListener(Event.ENTER_FRAME, onReversing);		}						/**		 * @private		 */		protected function stopReversing():void		{			if (!_isReversing) return;						_isReversing = false;			_reverseController.removeEventListener(Event.ENTER_FRAME, onReversing);		}	}}