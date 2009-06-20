/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.tween{	import com.hexagonstar.data.structures.IIterator;	import com.hexagonstar.data.structures.queues.Queue;	import com.hexagonstar.env.exception.IllegalArgumentException;	import com.hexagonstar.env.exception.IndexOutOfBoundsException;	import com.hexagonstar.math.easing.IEasing;	import com.hexagonstar.math.easing.QuadEasing;	import com.hexagonstar.tween.HTween;	import com.hexagonstar.tween.HTweenTimeline;	import com.hexagonstar.util.debug.Debug;	import flash.display.DisplayObject;	import flash.events.Event;	import flash.events.EventDispatcher;		/**	 * A wrapper class for HTweenTimeline that can be used to create a 'slide show'	 * from a number of display objects.	 * 	 * @author Sascha Balkau <sascha@hexagonstar.com>	 */	public class HTweenSlideShow extends EventDispatcher	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				protected var _timeline:HTweenTimeline;				protected var _currentPos:Number;		protected var _displayDuration:Number;		protected var _tweenInDuration:Number;		protected var _tweenOutDuration:Number;		protected var _gapDuration:Number;				protected var _easingIn:Function;		protected var _easingOut:Function;				protected var _tweenInEndValues:Object;		protected var _tweenOutEndValues:Object;				protected var _tweenPositions:Array;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new instance.		 * 		 * @param parent The container to that all added display objects are added.		 */		public function HTweenSlideShow(displayDuration:Number = 5.0,											tweenInDuration:Number = 0.5,											tweenOutDuration:Number = 0.5,											easingIn:Function = null,											easingOut:Function = null)		{			_currentPos = 0;			_gapDuration = 0;			_tweenPositions = [];						_displayDuration = displayDuration;			_tweenInDuration = tweenInDuration;			_tweenOutDuration = tweenOutDuration;						if (easingIn != null)			{				_easingIn = easingIn;			}			else			{				var e:IEasing = new QuadEasing();				_easingIn = e.easeIn;			}						_easingOut = easingOut || _easingIn;						super();						createChildren();			addEventListeners();		}						public function setTweenInEndProperties(properties:Object):void		{			_tweenInEndValues = {};			for (var n:String in properties)			{				_tweenInEndValues[n] = properties[n];			}		}						public function setTweenOutEndProperties(properties:Object):void		{			_tweenOutEndValues = {};			for (var n:String in properties)			{				_tweenOutEndValues[n] = properties[n];			}		}						/**		 * Adds a display object to the slideshow.		 */		public function addDisplayObject(displayObject:DisplayObject):void		{			var tweenI:HTween = new HTween(displayObject, _tweenInDuration, _tweenInEndValues,				{easing: _easingIn});			var tweenO:HTween = new HTween(displayObject, _tweenOutDuration, _tweenOutEndValues,				{easing: _easingOut});						_timeline.addTween(_currentPos, tweenI);			_timeline.addTween((_currentPos + _tweenInDuration + _displayDuration), tweenO);						_tweenPositions.push(_currentPos + _tweenInDuration);						//Debug.trace("fadeIn: " + _currentPos + "\tfadeOut: "			//	+ (_currentPos + _tweenInDuration + _displayDuration));						_currentPos += _tweenInDuration + _displayDuration + _gapDuration + _tweenOutDuration;		}						/**		 * setDisplayObjectQueue		 */		public function setDisplayObjectQueue(queue:Queue):void		{			var i:IIterator = queue.iterator();			while (i.hasNext)			{				var next:Object = i.next;				if (next is DisplayObject)				{					addDisplayObject(DisplayObject(next));				}				else				{					throw new IllegalArgumentException(toString()						+ " The specified queue may only contain non-display objects!");				}			}		}						/**		 * Starts the display cycling.		 */		public function play():void		{			Debug.traceObj(_tweenPositions);			_timeline.calculateDuration();			_timeline.duration += _gapDuration;			_timeline.play();		}						/**		 * Pauses the cycler.		 */		public function pause():void		{			paused = true;		}						/**		 * gotoAndStop		 * 		 * @param nr The display object index number.		 */		public function gotoAndStop(nr:int):void		{			if (nr < 0 || nr > _tweenPositions.length - 1)			{				throw new IndexOutOfBoundsException(toString()					+ " The specified display object index [" + nr + "] is out of bounds!");				return;			}						_timeline.gotoAndStop(_tweenPositions[nr]);		}						/**		 * gotoAndPlay		 * 		 * @param nr The display object index number.		 */		public function gotoAndPlay(nr:int):void		{			if (nr < 0 || nr > _tweenPositions.length - 1)			{				throw new IndexOutOfBoundsException(toString()					+ " The specified display object index [" + nr + "] is out of bounds!");				return;			}						_timeline.gotoAndPlay(_tweenPositions[nr]);		}				/**		 * dispose		 */		public function dispose():void		{			removeEventListeners();		}						/**		 * Returns a String Representation of HTweenSlideShow.		 * 		 * @return A String Representation of HTweenSlideShow.		 */		override public function toString():String		{			return "[HTweenSlideShow]";		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * The time in seconds how long a displayobject is being displayed		 * before it tweens out. The default is 5.		 */		public function get displayDuration():Number		{			return _displayDuration;		}		public function set displayDuration(v:Number):void		{			_displayDuration = v;		}						/**		 * Shortcut setter to set both tween in and tween out durations as the same value.		 */		public function set tweenDuration(v:Number):void		{			_tweenInDuration = _tweenOutDuration = v;		}						/**		 * The duration time in seconds that the slideshow uses for the tween-in		 * animation. The default is 0.5		 */		public function get tweenInDuration():Number		{			return _tweenInDuration;		}		public function set tweenInDuration(v:Number):void		{			_tweenInDuration = v;		}						/**		 * The duration time in seconds that the slideshow uses for the tween-out		 * animation. The default is 0.5		 */		public function get tweenOutDuration():Number		{			return _tweenOutDuration;		}		public function set tweenOutDuration(v:Number):void		{			_tweenOutDuration = v;		}						/**		 * The duration in seconds that the slideshow waits between every		 * displayobject. the default is 0.		 */		public function get gapDuration():Number		{			return _gapDuration;		}		public function set gapDuration(v:Number):void		{			_gapDuration = v;		}						/**		 * Shortcut setter to set both easinIn and easingOut as the same function.		 */		public function set easing(v:Function):void		{			_easingIn = _easingOut = v;		}						/**		 * The easing function used for the tween-in animation.		 * The default is QuadEasing.easeIn.		 */		public function get easingIn():Function		{			return _easingIn;		}		public function set easingIn(v:Function):void		{			_easingIn = v;		}						/**		 * The easing function used for the tween-out animation.		 * The default is QuadEasing.easeIn.		 */		public function get easingOut():Function		{			return _easingOut;		}		public function set easingOut(v:Function):void		{			_easingOut = v;		}						/**		 * The total duration of the slideshow in seconds. 		 */		public function get duration():Number		{			return _timeline.calculateDuration();		}						/**		 * The number of times the slideshow will repeat. If 0, it will only run once.		 * If 1 or more, it will repeat that many times. If -1, it will repeat forever.		 */		public function get repeat():int		{			return _timeline.repeat;		}		public function set repeat(v:int):void		{			_timeline.repeat = v;		}						public function get paused():Boolean		{			return _timeline.paused;		}		public function set paused(v:Boolean):void		{			_timeline.paused = v;		}						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @private		 * Relays the events fired by timeline to any listeners of this class.		 */		protected function onTimelineEvent(e:Event):void		{			dispatchEvent(e);		}						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * createChildren		 * @private		 */		protected function createChildren():void		{			_timeline = new HTweenTimeline();			_timeline.autoPlay = false;			_timeline.repeat = -1;		}						/**		 * addEventListeners		 * @private		 */		protected function addEventListeners():void		{			_timeline.addEventListener(Event.INIT, onTimelineEvent);			_timeline.addEventListener(Event.CHANGE, onTimelineEvent);			_timeline.addEventListener(Event.COMPLETE, onTimelineEvent);		}						/**		 * removeEventListeners		 * @private		 */		protected function removeEventListeners():void		{			_timeline.removeEventListener(Event.INIT, onTimelineEvent);			_timeline.removeEventListener(Event.CHANGE, onTimelineEvent);			_timeline.removeEventListener(Event.COMPLETE, onTimelineEvent);		}	}}