/*
 * hexagonlib - Multi-Purpose ActionScript 3 Library.
 *       __    __
 *    __/  \__/  \__    __
 *   /  \__/HEXAGON \__/  \
 *   \__/  \__/  LIBRARY _/
 *            \__/  \__/
 *
 * Licensed under the MIT License
 * 
 * Copyright (c) 2007 Sascha Balkau / Hexagon Star Softworks
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
package com.hexagonstar.motion.tween
{
	/**
	 * HTweenTimeline is a powerful sequencing engine for HTween. It allows you to build
	 * a virtual timeline with tweens, actions (callbacks), and labels. It supports all
	 * of the features of HTween, so you can repeat, reflect, and pause the timeline.
	 * You can even embed timelines within each other. HTweenTimeline adds about 1.2kb
	 * above HTween.
	 */
	public class HTweenTimeline extends HTween
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * If true, callbacks added with addCallback will not be called. This does not
		 * affect event callbacks like onChange, which can be disabled with suppressEvents.
		 * This can be handy for preventing large numbers of callbacks from being called
		 * when manually changing the position of a timeline (ex. calling
		 * <code>.end()</code>).
		 */
		public var suppressCallbacks:Boolean;
		
		/** @private **/
		protected var _tweens:Vector.<HTween>;
		/** @private **/
		protected var _tweenStartPositions:Vector.<Number>;
		/** @private **/
		protected var _callbacks:Vector.<Callback>;
		/** @private **/
		protected var _labels:Object;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Constructs a new HTweenTimeline instance. Note that because HTweenTimeline
		 * extends HTween, it can be used to tween a target directly, in addition to using
		 * its timeline features (for example, to synch tweening an animation with a
		 * timeline sequence).
		 * 
		 * @param target The object whose properties will be tweened. Defaults to null.
		 * @param duration The length of the tween in frames or seconds depending on the
		 *            timingMode. Defaults to 10.
		 * @param values An object containing destination property values. For example, to
		 *            tween to x=100, y=100, you could pass <code>{x:100, y:100}</code> as
		 *            the props object.
		 * @param properties An object containing properties to set on this tween. For
		 *            example, you could pass {ease:myEase} to set the ease property of the
		 *            new instance. It also supports a single special property "swapValues"
		 *            that will cause <code>.swapValues</code> to be called after the values
		 *            specified in the values parameter are set.
		 * @param pluginData An object containing data for installed plugins to use with
		 *            this tween. See <code>.pluginData</code> for more information.
		 * @param tweens An array of alternating start positions and tween instances. For
		 *            example, the following array would add 3 tweens starting at positions
		 *            2, 6, and 8: <code>[2, tween1, 6, tween2, 8, tween3]</code>
		 **/
		public function HTweenTimeline(target:Object = null,
											duration:Number = 1,
											values:Object = null,
											properties:Object = null,
											pluginData:Object = null,
											tweens:Array = null):void
		{
			_tweens = new Vector.<HTween>();
			_tweenStartPositions = new Vector.<Number>();
			_callbacks = new Vector.<Callback>();
			_labels = {};
			
			addTweens(tweens);
			super(target, duration, values, properties, pluginData);
			
			/* unlike HTween, which waits for a setValue to start playing,
			 * HTweenTimeline starts immediately. */
			if (autoPlay)
			{
				paused = false;
			}
		}
		
		
		/**
		 * Sets a property value on a specified target object. This is provided to make it
		 * easy to set properties in a HTweenTimeline using <code>addCallback</code>. For
		 * example, to set the <code>visible</code> property to true on a movieclip "foo" at
		 * 3 seconds into the timeline, you could use the following code:<br/>
		 * <code>myTimeline.addCallback(3,HTweenTimeline.setPropertyValue,[foo,"visible",true]);
		 * </code>
		 * 
		 * @param target The object to set the property value on.
		 * @param propertyName The name of the property to set.
		 * @param value The value to assign to the property.
		 */
		public static function setPropertyValue(target:Object,
													 propertyName:String,
													 value:*):void
		{
			target[propertyName] = value;
		}
		
		
		/**
		 * Adds a tween to the timeline, which will start playing at the specified start
		 * position. The tween will play synchronized with the timeline, with all of its
		 * behaviours intact (ex. <code>repeat</code>, <code>reflect</code>) except for
		 * <code>delay</code> (which is accomplished with the <code>position</code>
		 * parameter instead).
		 * 
		 * @param position The starting position for this tween in frames or seconds (as per
		 *            the timing mode of this tween).
		 * @param tween The HTween instance to add. Note that this can be any subclass of
		 *            HTween, including another HTweenTimeline.
		 */
		public function addTween(position:Number, tween:HTween):void
		{
			if (tween == null || isNaN(position))
			{
				return;
			}
			
			tween.autoPlay = false;
			tween.paused = true;
			var index:int = -1;
			while (++index < _tweens.length && _tweenStartPositions[index] < position) {}
			_tweens.splice(index, 0, tween);
			_tweenStartPositions.splice(index, 0, position);
			tween.position = calculatedPosition - position;
		}
		
		
		/**
		 * Shortcut method for adding a number of tweens at once.
		 * 
		 * @param tweens An array of alternating positions and tween instances. For example,
		 *            the following array would add 3 tweens starting at positions 2, 6, and
		 *            8: <code>[2, tween1, 6, tween2, 8, tween3]</code>
		 */
		public function addTweens(tweens:Array):void
		{
			if (tweens == null)
			{
				return;
			}
			
			for (var i:int = 0; i < tweens.length; i += 2)
			{
				addTween(tweens[i], tweens[i + 1] as HTween);
			}
		}
		
		
		/**
		 * Removes the specified tween. Note that this will remove all instances of the
		 * tween if has been added multiple times to the timeline.
		 * 
		 * @param tween The HTween instance to remove.
		 */
		public function removeTween(tween:HTween):void
		{
			for (var i:int = _tweens.length; i >= 0; i--)
			{
				if (_tweens[i] == tween)
				{
					_tweens.splice(i, 1);
					_tweenStartPositions.splice(i, 1);
				}
			}
		}
		
		
		/**
		 * Adds a label at the specified position. You can use <code>gotoAndPlay</code> or
		 * <code>gotoAndStop</code> to jump to labels.
		 * 
		 * @param position The position to add the label at in frames or seconds (as per the
		 *            timing mode of this tween).
		 * @param label The label to add.
		 */
		public function addLabel(position:Number, label:String):void
		{
			_labels[label] = position;
		}
		
		
		/**
		 * Removes the specified label.
		 *
		 * @param label The label to remove.
		 */
		public function removeLabel(label:String):void
		{
			delete(_labels[label]);
		}
		
		
		/**
		 * Adds a callback function at the specified position. When the timeline's playhead
		 * passes over or lands on the position while playing the callback will be called
		 * with the parameters specified. You can also optionally specify a callback and
		 * parameters to use if the timeline is playing in reverse (when reflected for
		 * example). <br/>
		 * <br/>
		 * You can add multiple callbacks at a specified position, however it is important
		 * to note that they will be played in the same order (most recently added first)
		 * playing both forwards and in reverse. You can enforce the order they are called
		 * in by offsetting the callbacks' positions by a tiny amount (ex. one at 2s, and
		 * one at 2.001s). <br/>
		 * <br/>
		 * Note that this can be used in conjunction with the static
		 * <code>setPropertyValue</code> method to easily set properties on objects in the
		 * timeline.
		 * 
		 * @param labelOrPosition The position or label to add the callback at in frames or
		 *            seconds (as per the timing mode of this tween).
		 * @param forwardCallback The function to call when playing forwards.
		 * @param forwardParameters Optional array of parameters to pass to the callback
		 *            when it is called when playing forwards.
		 * @param reverseCallback The function to call when playing in reverse.
		 * @param reverseParameters Optional array of parameters to pass to the callback
		 *            when it is called when playing in reverse.
		 */
		public function addCallback(labelOrPosition:*,
										forwardCallback:Function,
										forwardParameters:Array = null,
										reverseCallback:Function = null,
										reverseParameters:Array = null):void
		{
			var position:Number = resolveLabelOrPosition(labelOrPosition);
			if (isNaN(position)) 
			{
				return;
			}
			
			var callback:Callback = new Callback(position, forwardCallback, forwardParameters,
				reverseCallback, reverseParameters);
			
			var l:int = _callbacks.length;
			for (var i:int = l - 1; i >= 0; i--)
			{
				if (position > _callbacks[i].position)
				{
					break;
				}
			}
			
			_callbacks.splice(i + 1, 0, callback);
		}
		
		
		/**
		 * Removes the callback(s) at the specified label or position.
		 * 
		 * @param labelOrPosition The position of the callback(s) to remove in frames or
		 *            seconds (as per the timing mode of this tween).
		 */
		public function removeCallback(labelOrPosition:*):void
		{
			var position:Number = resolveLabelOrPosition(labelOrPosition);
			if (isNaN(position))
			{
				return;
			}
			
			var l:int = _callbacks.length;
			for (var i:int = 0; i < l; i++) 
			{
				if (position == _callbacks[i].position)
				{
					_callbacks.splice(i, 1);
				}
			}
		}
		
		
		/**
		 * Jumps the timeline to the specified label or numeric position and plays it.
		 * 
		 * @param labelOrPosition The label name or numeric position in frames or seconds
		 *            (as per the timing mode of this tween) to jump to.
		 */
		public function gotoAndPlay(labelOrPosition:*):void
		{
			goto(labelOrPosition);
			paused = false;
		}
		
		
		/**
		 * Jumps the timeline to the specified label or numeric position and pauses it.
		 * 
		 * @param labelOrPosition The label name or numeric position in frames or seconds
		 *            (as per the timing mode of this tween) to jump to.
		 */
		public function gotoAndStop(labelOrPosition:*):void
		{
			goto(labelOrPosition);
			paused = true;
		}
		
		
		/**
		 * Jumps the timeline to the specified label or numeric position without affecting
		 * its paused state.
		 * 
		 * @param labelOrPosition The label name or numeric position in frames or seconds
		 *            (as per the timing mode of this tween) to jump to.
		 */
		public function goto(labelOrPosition:*):void
		{
			var pos:Number = resolveLabelOrPosition(labelOrPosition);
			if (!isNaN(pos))
			{
				position = pos;
			}
		}
		
		
		/**
		 * Returns the position for the specified label. If a numeric position is specified,
		 * it is returned unchanged.
		 * 
		 * @param labelOrPosition The label name or numeric position in frames or seconds
		 *            (as per the timing mode of this tween) to resolve.
		 */
		public function resolveLabelOrPosition(labelOrPosition:*):Number
		{
			return (isNaN(labelOrPosition)) ? _labels[String(labelOrPosition)] : labelOrPosition;
		}
		
		
		/**
		 * Calculates and sets the duration of the timeline based on the tweens and
		 * callbacks that have been added to it.
		 */
		public function calculateDuration():void
		{
			var d:Number = 0;
			if (_callbacks.length > 0)
			{
				d = _callbacks[_callbacks.length - 1].position;
			}
			
			for (var i:int = 0; i < _tweens.length; i++)
			{
				if (_tweens[i].duration + _tweenStartPositions[i] > d)
				{
					d = _tweens[i].duration + _tweenStartPositions[i];
				}
			}
			duration = d;
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		
		override public function set position(v:Number):void
		{
			/* delay event callbacks until we're done */
			var tmpSuppressEvents:Boolean = suppressEvents;
			suppressEvents = true;
			
			/* run all the normal HTween logic */
			super.position = v;
			
			/* update tweens */
			var repeatIndex:Number = _position / duration >> 0;
			var rev:Boolean = (reflect && repeatIndex % 2 >= 1);
			var i:int;
			var l:int = _tweens.length;
			
			if (rev)
			{
				for (i = 0; i < l; i++)
				{
					_tweens[i].position = calculatedPosition - _tweenStartPositions[i];
				}
			}
			else
			{
				for (i = l - 1; i >= 0; i--)
				{
					_tweens[i].position = calculatedPosition - _tweenStartPositions[i];
				}
			}
			
			if (!suppressCallbacks)
			{
				checkCallbacks();
			}
			
			/* handle events now that everything is complete */
			suppressEvents = tmpSuppressEvents;
			if (onChange != null && !suppressEvents)
			{
				onChange(this);
			}
			
			if (onComplete != null && !suppressEvents && v >= repeatCount * duration
				&& repeatCount > 0)
			{
				onComplete(this);
			}
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * checks for callbacks between the previous and current position (inclusive of
		 * current, exclusive of previous).
		 * @private
		 */
		protected function checkCallbacks():void
		{
			if (_callbacks.length == 0)
			{
				return;
			}
			
			var repeatIndex:uint = _position / duration >> 0;
			var previousRepeatIndex:uint = positionOld / duration >> 0;
			
			if (repeatIndex == previousRepeatIndex || (repeatCount > 0
				&& _position >= duration * repeatCount))
			{
				checkCallbackRange(calculatedPositionOld, calculatedPosition);
			}
			else
			{
				/* GDS: this doesn't currently support multiple repeats
				 * in one tick (ie. more than a single repeat). */
				var rev:Boolean = (reflect && previousRepeatIndex % 2 >= 1);
				checkCallbackRange(calculatedPositionOld, rev ? 0 : duration);
				rev = (reflect && repeatIndex % 2 >= 1);
				checkCallbackRange(rev ? duration : 0, calculatedPosition, !reflect);
			}
		}
		
		
		/**
		 * checks for callbacks between a contiguous start and end position (ie. not broken
		 * by repeats).
		 * @private
		 */
		protected function checkCallbackRange(startPos:Number,
													endPos:Number,
													includeStart:Boolean = false):void
		{
			var sPos:Number = startPos;
			var ePos:Number = endPos;
			var i:int = -1;
			var j:int = _callbacks.length;
			var k:int = 1;
			
			if (startPos > endPos)
			{
				/* running backwards, flip everything */
				sPos = endPos;
				ePos = startPos;
				i = j;
				j = k = -1;
			}
			
			while ((i += k) != j)
			{
				var callback:Callback = _callbacks[i];
				var pos:Number = callback.position;
				
				if ( (pos > sPos && pos < ePos) || (pos == endPos)
					|| (includeStart && pos == startPos))
				{
					if (k == 1)
					{
						if (callback.forward != null)
						{
							callback.forward.apply(this, callback.forwardParams);
						}
					}
					else
					{
						if (callback.reverse != null)
						{
							callback.reverse.apply(this, callback.reverseParams);
						}
					}
				}
			}
		}
	}
}


/**
 * @private
 */
class Callback 
{
	public var position:Number;
	public var forward:Function;
	public var reverse:Function;
	public var forwardParams:Array;
	public var reverseParams:Array;
	
	public function Callback(p:Number, f:Function, fp:Array, r:Function, rp:Array) 
	{
		position = p;
		forward = f;
		reverse = r;
		forwardParams = fp;
		reverseParams = rp;
	}
}
