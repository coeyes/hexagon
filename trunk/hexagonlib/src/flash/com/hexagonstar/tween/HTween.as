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
 * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks
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
package com.hexagonstar.tween 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	/**
	 * This event is dispatched each time the tween updates properties
	 * on its target. It will be dispatched each "tick" during the TWEEN.
	 *
	 * @eventType flash.events.Event
	 */
	[Event(name="change", type="flash.events.Event")]

	/**
	 * Dispatched when a tween copies its initial properties and starts tweening.
	 * In tweens with a delay of 0, this event will fire immediately when it
	 * starts playing. In tweens with a delay set, this will fire when the delay
	 * state is ended, and the tween state is entered.
	 *
	 * @eventType flash.events.Event
	 */
	[Event(name="init", type="flash.events.Event")]

	/**
	 * Dispatched when a tween ends (its position equals its duration).
	 *
	 * @eventType flash.events.Event
	 */
	[Event(name="complete", type="flash.events.Event")]

	
	/**
	 * HTween Class
	 */
	public class HTween extends EventDispatcher 
	{
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/** Constant for the TIME timingMode. **/
		public static const MODE_TIME:String		= "time";
		/** Constant for the FRAME timingMode. **/
		public static const MODE_FRAME:String	= "frame";
		/** Constant for the HYBRID timingMode. **/
		public static const MODE_HYBRID:String	= "hybrid";
		
		/** Constant for the START state. **/
		public static const STATE_START:String	= "start";
		/** Constant for the DELAY state. **/
		public static const STATE_DELAY:String	= "delay";
		/** Constant for the TWEEN state. **/
		public static const STATE_TWEEN:String	= "tween";
		/** Constant for the END state. **/
		public static const STATE_END:String		= "end";
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
	
		protected static var _timingMode:String;
		protected static var _timeInterval:uint = 40;
		protected static var _activeTicker:ITicker;
		protected static var _pauseAll:Boolean = false;
		protected static var _defaultEasing:Function;
		
		protected static var _rotationProperties:Object =
		{
			rotation: true,
			rotationX: true,
			rotationY: true,
			rotationZ: true
		};
		
		protected static var _snappingProperties:Object =
		{
			x: true,
			y: true
		};
		
		/* keeps active tweens in memory */
		protected static var _activeTweens:Dictionary = new Dictionary();
		
		protected var _autoPlay:Boolean = true;
		protected var _autoRotation:Boolean = false;
		protected var _autoVisible:Boolean = true;
		protected var _reflect:Boolean = false;
		protected var _snapping:Boolean = false;
		protected var _paused:Boolean = true;
		protected var _reversed:Boolean;
		
		protected var _position:Number = 0;
		protected var _tweenPosition:Number = 0;
		protected var _duration:Number = 1;
		protected var _delay:Number = 0;
		protected var _repeat:int = 0;
		
		protected var _target:Object;
		protected var _nextTween:HTween;
		protected var _data:*;
		protected var _ticker:ITicker;
		protected var _proxy:TargetProxy;
		
		protected var _isInitialized:Boolean;
		protected var _isInTick:Boolean;
		protected var _lockStartProperties:Boolean;
		
		protected var _startValues:Object;
		protected var _endValues:Object;
		protected var _assignmentTarget:Object;
		protected var _assignmentProperty:String;
		protected var _propertyTarget:Object;
		protected var _positionOffset:Number;
		protected var _prevPosition:Number;
		protected var _prevTweenPosition:Number;
		
		protected var _easing:Function = linearEasing;
		protected var _mathRound:Function = Math.round;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Constructs a new HTween instance.
		 *
		 * @param target The object whose properties will be tweened. Defaults to null.
		 * @param duration The length of the tween in frames or seconds depending on the
		 *         timingMode. Defaults to 10.
		 * @param properties An object containing end property values. For example, to
		 *         tween to x=100, y=100, you could pass {x:100, y:100} as the props object.
		 * @param tweenProperties An object containing properties to set on this tween. For
		 *         example, you could pass {ease:myEase} to set the ease property of the new
		 *         instance. This also provides a shortcut for setting up event listeners.
		 *         See .setTweenProperties() for more information.
		 */
		public function HTween(target:Object = null,
								  duration:Number = 10,
								  properties:Object = null,
								  tweenProperties:Object = null)
		{
			_ticker = activeTicker;
			this.target = target;
			_duration = duration;
			_easing = _defaultEasing || linearEasing;
			setProperties(properties);
			setTweenProperties(tweenProperties);
		}
		
		
		/**
		 * The default easing function used by HTween.
		 */
		public static function linearEasing(t:Number, b:Number, c:Number, d:Number):Number
		{
			return t;
		}
		
		
		/**
		 * Shorthand method for making multiple setProperty calls quickly. This removes
		 * any existing target property values on the tween.<br/><br/>
		 * 
		 * <b>Example:</b> set x and y end values:<br/>
		 * <code>myHTween.setProperties({x:200, y:400});</code>
		 * 
		 * @param properties An object containing end property values.
		 */
		public function setProperties(properties:Object):void
		{
			_endValues = {};
			for (var n:String in properties)
			{
				setProperty(n, properties[n]);
			}
		}
		
		
		/**
		 * Sets the numeric end value for a property on the target object that you
		 * would like to tween. For example, if you wanted to tween to a new x position,
		 * you could use: myHTween.setProperty("x",400). Non-numeric values are ignored.
		 * 
		 * @param name The name of the property to tween.
		 * @param value The numeric end value (the value to tween to).
		 */
		public function setProperty(name:String, value:Number):void
		{
			if (isNaN(value)) return;
			_endValues[name] = value;
			
			if (_lockStartProperties && _startValues[name] == null)
			{
				_startValues[name] = _propertyTarget[name];
			}
			
			invalidate();
		}
		
		
		/**
		 * Returns the end value for the specified property if one exists.
		 * 
		 * @param name The name of the property to return a end value for.
		 */
		public function getProperty(name:String):Number
		{
			return _endValues[name];
		}
		
		
		/**
		 * Removes a end value from the tween. This prevents the HTween instance
		 * from tweening the property.
		 * 
		 * @param name The name of the end property to delete.
		 */
		public function deleteProperty(name:String):Boolean
		{
			return delete(_endValues[name]);
		}
		
		
		/**
		 * Returns the hash table of all end properties and their values. This is
		 * a copy of the internal hash of values, so modifying the returned object
		 * will not affect the tween.
		 */
		public function getProperties():Object
		{
			return copyObject(_endValues);
		}
		
		
		/**
		 * Allows you to manually assign the start property values for a tween. These
		 * are the properties that will be applied when the tween is at tween position 0.
		 * Normally these are automatically copied from the target object on initialization,
		 * or whenever a end value changes. You can also use the lockStartProperties
		 * property to ensure your start properties are not reinitialized after you set them.
		 * 
		 * @param properties An object containing start property values.
		 */
		public function setStartProperties(properties:Object):void
		{
			_startValues = copyObject(properties);
			_isInitialized = true;
		}
		
		
		/**
		 * Returns the hash table of all start properties and their values. This is a
		 * copy of the internal hash of values, so modifying the returned object will
		 * not affect the tween.
		 */
		public function getStartProperties():Object
		{
			return copyObject(_startValues);
		}
		
		
		/**
		 * Shortcut method for setting multiple properties on the tween instance quickly.
		 * This does not set end values (ie. the value to tween to). This method also
		 * provides you with a quick method for adding listeners to specific events, using
		 * the special properties: initListener, completeListener, changeListener.<br/><br/>
		 * 
		 * <b>Example:</b> This will set the duration, reflect, and nextTween properties
		 * of a tween, and add a listener for the complete event:<br/>
		 * <code>myTween.setTweenProperties({duration:4, reflect:true, nextTween:anotherTween,
		 * completeListener:completeHandlerFunction});</code>
		 */
		public function setTweenProperties(properties:Object):void
		{
			if (!properties) return;
			
			var positionValue:Number;
			
			if ("position" in properties)
			{
				positionValue = properties.position;
				delete(properties.position);
			}
			
			if ("initListener" in properties)
			{
				addEventListener(Event.INIT, properties.initListener, false, 0, true);
				delete(properties.initListener);
			}
			
			if ("completeListener" in properties)
			{
				addEventListener(Event.COMPLETE, properties.completeListener, false, 0, true);
				delete(properties.completeListener);
			}
			
			if ("changeListener" in properties)
			{
				addEventListener(Event.CHANGE, properties.changeListener, false, 0, true);
				delete(properties.changeListener);
			}
			
			for (var n:String in properties)
			{
				this[n] = properties[n];
			}
			
			if (!isNaN(positionValue))
			{
				setPosition(positionValue, true);
			}
		}
		
		
		/**
		 * Toggles the reversed property and inverts the current tween position.
		 * This will cause a tween to reverse playing visually.
		 * 
		 * TODO There is currently an issue with this functionality for tweens
		 * with a repeat of -1.
		 * 
		 * @param suppressEvents Indicates whether to suppress any events or
		 *         callbacks that are generated as a result of the position change.
		 */
		public function reverse(suppressEvents:Boolean = true):void
		{
			var pos:Number = (_repeat == -1)
				? _duration - _position % _duration
				: (_repeat + 1) * _duration - _position;
			
			if (_reflect)
			{
				_reversed =
					((_position / _duration % 2 >= 1) == (pos / _duration % 2 >= 1)) != _reversed;
			}
			else
			{
				_reversed = !_reversed;
			}
			
			setPosition(pos, suppressEvents);
		}
		
		
		/**
		 * Invalidate forces the tween to repopulate all of the initial properties from
		 * the target object, and start playing if autoplay is set to true. If the tween
		 * is currently playing, then it will also set the position to 0. For example,
		 * if you changed the x and y position of a the target object while the tween was
		 * playing, you could call invalidate on it to force it to resume the tween with
		 * the new property values.
		 */
		public function invalidate():void
		{
			_isInitialized = false;
			if (_position > 0)
			{
				_position = 0;
				updatePositionOffset();
			}
			if (_autoPlay)
			{
				paused = false;
			}
		}
		
		
		/**
		 * Pauses the tween by stopping tick from being automatically called. This also
		 * releases the tween for garbage collection if it is not referenced externally.
		 */
		public function pause():void
		{
			paused = true;
		}
		
		
		/**
		 * Plays a tween by incrementing the position property each frame. This also
		 * prevents the tween from being garbage collected while it is active. This is
		 * achieved by way of two methods:<br/>
		 * 1. If the target object is an IEventDispatcher, then the tween will subscribe
		 * to a dummy event using a hard reference. This allows the tween to be garbage
		 * collected if its target is also collected, and there are no other external
		 * references to it.<br/>
		 * 2. If the target object is not an IEventDispatcher, then the tween is placed
		 * in the activeTweens list, to prevent collection until it is paused or reaches
		 * the end of the transition).
		 * Note that pausing all tweens via the HTween.pauseAll static property will not
		 * free the tweens for collection.
		 */
		public function play():void
		{
			paused = false;
		}
		
		
		/**
		 * Jumps the tween to its beginning. This is the same as setting
		 * <code>position = -delay</code>.
		 */
		public function beginning():void
		{
			setPosition(-_delay);
		}
		
		
		/**
		 * Jumps the tween to its end. This is the same as setting
		 * <code>position = (repeat + 1) * duration</code>.
		 */
		public function end():void
		{
			setPosition((_repeat == -1) ? _duration : (_repeat + 1) * _duration);
		}
		
		
		/**
		 * Allows you to tween objects that require re-assignment whenever they are
		 * modified by reassigning the target object to a specified property of another
		 * object. For example, in order for changes to a colorTransform object to be
		 * visible, it must be assigned back to the <code>.transform.colorTransform</code>
		 * property of a display object. To make this work, you would call <code>
		 * myTween.setAssignment(myDisplayObject.transform,"colorTransform");</code>
		 * This will also cause HTween to retrieve the target each time it copies its
		 * initial values.<br/><br/>
		 * 
		 * <b>Note:</b> this does not work with filters, as they must be assigned to an
		 * array first, and then to the filters property. Use HTweenFilter instead.
		 *
		 * @param assignmentTarget The object to reassign the property on.
		 * @param assignmentProperty The name of the property to reassign the target to.
		 */
		public function setAssignment(assignmentTarget:Object = null,
										  assignmentProperty:String = null):void
		{
			_assignmentTarget = assignmentTarget;
			_assignmentProperty = assignmentProperty;
			_isInitialized = false;
		}
		
		
		/**
		 * Sets the position of the tween. Using the position property will always suppress
		 * events and callbacks, whereas the setPosition method allows you to manually set
		 * the position and specify whether to suppress events or not.
		 * 
		 * @param value The position to jump to in seconds or frames (depending on the
		 *         timingMode).
		 * @param suppressEvents Indicates whether to suppress events and callbacks
		 *         generated from the change in position.
		 */
		public function setPosition(position:Number, suppressEvents:Boolean = true):void
		{
			_prevPosition = _position;
			_position = position;
			
			if (!_isInTick && !paused) 
			{ 
				updatePositionOffset();
			}
			
			var maxPos:Number = (_repeat + 1) * _duration;
			var tp:Number;
			
			if (position < 0)
			{
				tp = _reversed ? _duration : 0;
			}
			else if (_repeat == -1 || position < maxPos)
			{
				tp = position % _duration;
				if ((_reflect && position / _duration % 2 >= 1) != _reversed)
				{
					tp = _duration - tp;
				}
			}
			else 
			{
				tp = ((_reflect && _repeat % 2 >= 1) != _reversed) ? 0 : _duration;
			}
			
			if (tp == _tweenPosition) return;
			
			_prevTweenPosition = _tweenPosition;
			_tweenPosition = tp;
			
			if (!suppressEvents && hasEventListener(Event.CHANGE))
			{
				dispatchEvent(new Event(Event.CHANGE));
			}
			
			if (!_isInitialized && _prevPosition <= 0 && _position >= 0)
			{
				init();
				if (!suppressEvents && hasEventListener(Event.INIT))
				{
					dispatchEvent(new Event(Event.INIT));
				}
			}
			
			updateProperties();
			
			if (_repeat != -1 && _prevPosition < maxPos && position >= maxPos)
			{
				if (!suppressEvents && hasEventListener(Event.COMPLETE))
				{
					dispatchEvent(new Event(Event.COMPLETE));
				}
				
				paused = true;
				if (_nextTween) _nextTween.paused = false;
			}
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Setting this to true pauses all tween instances. This does not affect
		 * individual tweens' .paused property.
		 */
		static public function get pauseAll():Boolean
		{
			return _pauseAll;
		}
		static public function set pauseAll(v:Boolean):void
		{
			_pauseAll = v;
		}
		
		
		/**
		 * Specifies the default easing function to use with new tweens. If null,
		 * HTween.linearEase will be used.
		 */
		static public function get defaultEasing():Function
		{
			return _defaultEasing;
		}
		static public function set defaultEasing(v:Function):void
		{
			_defaultEasing = v;
		}
		
		
		/**
		 * A hash table specifying properties that should be affected by autoRotation.
		 */
		static public function get rotationProperties():Object
		{
			return _rotationProperties;
		}
		static public function set rotationProperties(v:Object):void
		{
			_rotationProperties = v;
		}
		
		
		/**
		 * A hash table specifying properties that should have their value rounded
		 * (snapped) before being applied. This can be toggled for each tween instance
		 * basis with the .snapping property.
		 */
		static public function get snappingProperties():Object
		{
			return _snappingProperties;
		}
		static public function set snappingProperties(v:Object):void
		{
			_snappingProperties = v;
		}
		
		
		/**
		 * Indicates whether the tween should automatically play when an end value
		 * is changed.
		 */
		public function get autoPlay():Boolean
		{
			return _autoPlay;
		}
		public function set autoPlay(v:Boolean):void
		{
			_autoPlay = v;
		}
		
		
		/**
		 * When true, the tween will always rotate in the shortest direction to reach
		 * an end rotation value. For example, rotating from 355 degress to 5 degrees
		 * will rotate 10 degrees clockwise with .autoRotation set to true.
		 * It would rotate 350 degrees counter-clockwise with .autoRotation set to false.
		 * This affects all properties specified in the static .rotationProperties hash table.
		 */
		public function get autoRotation():Boolean
		{
			return _autoRotation;
		}
		public function set autoRotation(v:Boolean):void
		{
			_autoRotation = v;
		}
		
		
		/**
		 * Indicates whether the target's visible property should automatically be set
		 * to false when its alpha value is tweened to 0 or less. Only affects objects
		 * with a visible property.
		 */
		public function get autoVisible():Boolean
		{
			return _autoVisible;
		}
		public function set autoVisible(v:Boolean):void
		{
			_autoVisible = v;
		}
		
		
		/**
		 * Allows you to associate arbitrary data with your tween. For example, you might
		 * use this to reference specific data when handling events from tweens.
		 */
		public function get data():*
		{
			return _data;
		}
		public function set data(v:*):void
		{
			_data = v;
		}
		
		
		/**
		 * The length of the tween in frames or seconds (depending on the timingMode).
		 * Setting this will also update any child transitions that have synchDuration
		 * set to true.
		 */
		public function get duration():Number
		{
			return _duration;
		}
		public function set duration(v:Number):void
		{
			_duration = v;
		}
		
		
		/**
		 * The easing function to use for calculating the tween. This can be any standard
		 * tween function, such as the tween functions in fl.motion.easing.* that come
		 * with Flash CS3. New tweens will have this set to the defaultTween. Setting
		 * this to null will cause HTween to throw null reference errors.
		 */
		public function get easing():Function
		{
			return _easing;
		}
		public function set easing(v:Function):void
		{
			_easing = v;
		}
		
		
		/**
		 * Specifies another HTween instance that will have paused=false called on it when
		 * this tween completes.
		 */
		public function get nextTween():HTween
		{
			return _nextTween;
		}
		public function set nextTween(v:HTween):void
		{
			_nextTween = v;
		}
		
		
		/**
		 * Indicates whether the tween should use the reflect mode when repeating. If
		 * reflect is set to true, then the tween will play backwards on every other
		 * repeat. This has similar effects to reversed, but the properties are exclusive
		 * of one another.
		 * For instance, with reversed set to false, reflected set to true, and a repeat
		 * of 1, the tween will play from start to end, then repeat and reflect to play
		 * from end to start.
		 * If in the previous example reversed was instead set to true, the tween would
		 * play from end to start, then repeat and reflect to play from start to end.
		 * Finally, with reversed set to false, reflected set to false, and a repeat
		 * of 1, the tween will play from start to end, then repeat from start to end.
		 */
		public function get reflect():Boolean
		{
			return _reflect;
		}
		public function set reflect(v:Boolean):void
		{
			_reflect = v;
		}
		
		
		/**
		 * The number of times this tween will repeat. If 0, the tween will only run once.
		 * If 1 or more, the tween will repeat that many times. If -1, the tween will
		 * repeat forever.
		 */
		public function get repeat():int
		{
			return _repeat;
		}
		public function set repeat(v:int):void
		{
			_repeat = v;
		}
		
		
		/**
		 * If set to true, tweened values specified by snappingProperties will be
		 * rounded (snapped) before they are assigned to the target.
		 */
		public function get snapping():Boolean
		{
			return _snapping;
		}
		public function set snapping(v:Boolean):void
		{
			_snapping = v;
		}
		
		
		/**
		 * Indicates how HTween should deal with timing. This can be set to HTween.TIME,
		 * HTween.FRAME, or HTween.HYBRID.<br/><br/>
		 * 
		 * In frame mode, HTween will update once every frame, and all positional values
		 * are specified in frames (duration, position, delay, etc).<br/><br/>
		 * 
		 * In time mode, updates will occur at an interval specified by the timeInterval
		 * property, independent of the frame rate, and all positional values are specified
		 * in seconds.<br/><br/>
		 * 
		 * In hybrid mode, all updates occur on a frame, but all positional values are
		 * specified in seconds. Each frame the tween will calculate it's position based on
		 * the elapsed time. This offers lower CPU usage, and a more familiar time-based
		 * interface, but can result in choppy animations in high CPU situations.<br/><br/>
		 * 
		 * The hybrid mode generally provides the smoothest results. The frame mode makes
		 * it easy to synch tweens with timeline animations. You can change modes at any
		 * time, but existing tweens will continue to use the mode that was active when
		 * they were created.
		 */
		public static function get timingMode():String
		{
			return _timingMode;
		}
		public static function set timingMode(v:String):void
		{
			v = (v == MODE_FRAME || v == MODE_TIME) ? v : MODE_HYBRID;
			if (v == _timingMode) return;
			
			_timingMode = v;
			
			if (_timingMode == MODE_TIME)
			{
				_activeTicker = new TimeTicker();
				TimeTicker(_activeTicker).interval = _timeInterval / 1000;
			}
			else if (_timingMode == MODE_FRAME)
			{
				_activeTicker = new FrameTicker();
			}
			else
			{
				_activeTicker = new HybridTicker();
			}
		}
		
		
		/**
		 * Sets the time in milliseconds between updates when timingMode is set to
		 * HTween.TIME ("time"). Setting this to a lower number will generally result
		 * in smoother animations but higher CPU usage. Defaults to 40ms (~25 updates
		 * per second).
		 */
		public static function get timeInterval():uint
		{
			return _timeInterval;
		}
		public static function set timeInterval(v:uint):void 
		{
			_timeInterval = v;
			if (_activeTicker is TimeTicker)
				TimeTicker(_activeTicker).interval = _timeInterval / 1000;
		}
		
		
		/**
		 * The currently active Ticker object.
		 **/
		public static function get activeTicker():ITicker
		{
			if (!_timingMode)
			{
				timingMode = MODE_HYBRID;
			}
			return _activeTicker;
		}
		
		
		/**
		 * The proxy object allows you to work with the properties and methods of the target object directly through HTween.
		 * Numeric property assignments will be used by HTween as end values. The proxy will return HTween end values
		 * when they are set, or the target's property values if they are not. Delete operations on properties will result in a deleteProperty
		 * call. All other property access and method execution through proxy will be passed directly to the target object.
		 * <br/><br/>
		 * <b>Example 1:</b> Equivalent to calling myHTween.setProperty("scaleY",2.5):<br/>
		 * <code>myHTween.proxy.scaleY = 2.5;</code>
		 * <br/><br/>
		 * <b>Example 2:</b> Gets the current rotation value from the target object (because it hasn't been set yet on the HTween), adds 100 to it, and then
		 * calls setProperty on the HTween instance with the appropriate value:<br/>
		 * <code>myHTween.proxy.rotation += 100;</code>
		 * <br/><br/>
		 * <b>Example 3:</b> Sets an end property value (through setProperty) for scaleX, then retrieves it from HTween (because it will always return
		 * end values when available):<br/>
		 * <code>trace(myHTween.proxy.scaleX); // 1 (value from target, because no end value is set)<br/>
		 * myHTween.proxy.scaleX = 2; // set a end value<br/>
		 * trace(myHTween.proxy.scaleX); // 2 (end value from HTween)<br/>
		 * trace(myHTween.target.scaleX); // 1 (current value from target)</code>
		 * <br/><br/>
		 * <b>Example 4:</b> Property deletions only affect end properties on HTween, not the target object:<br/>
		 * <code>myHTween.proxy.rotation = 50; // set a end value<br/>
		 * trace(myHTween.proxy.rotation); // 50 (end value from HTween)<br/>
		 * delete(myHTween.proxy.rotation); // delete the end value<br/>
		 * trace(myHTween.proxy.rotation); // 0 (current value from target)</code>
		 * <br/><br/>
		 * <b>Example 5:</b> Non-numeric property access is passed through to the target:<br/>
		 * <code>myHTween.proxy.blendMode = "multiply"; // passes value assignment through to the target<br/>
		 * trace(myHTween.target.blendMode); // "multiply" (value from target)<br/>
		 * trace(myHTween.proxy.blendMode); // "multiply" (value passed through from target)</code>
		 * <br/><br/>
		 * <b>Example 6:</b> Method calls are passed through to target:<br/>
		 * <code>myHTween.proxy.gotoAndStop(30); // gotoAndStop(30) will be called on the target</code>
		 */
		public function get proxy():Object
		{
			if (_proxy == null)
			{
				_proxy = new TargetProxy(this);
			}
			return _proxy;
		}
		
		
		/**
		 * Gets and sets the position in the tween in frames or seconds (depending on the timingMode). This value can be any number, and will be resolved to a tweenPosition value
		 * prior to being applied to the tweened values. See tweenPosition for more information.
		 * <br/><br/>
		 * <b>Negative values</b><br/>
		 * Values below 0 will always resolve to a tweenPosition of 0. Negative values can be used to set up a delay on the tween, as the tween will have to count up to 0 before initing.
		 * <br/><br/>
		 * <b>Positive values</b><br/>
		 * Positive values are resolved based on the duration, repeat, reflect, and reversed properties.
		 */
		public function get position():Number
		{
			return _position;
		}
		public function set position(v:Number):void
		{
			setPosition(v, true);
		}
		
		
		/**
		 * Indicates whether the tween is currently paused. See play() and pause() for more information.
		 */
		public function get paused():Boolean
		{
			return _paused;
		}
		public function set paused(v:Boolean):void
		{
			if (v == _paused) return;
			_paused = v;
			
			if (v)
			{
				_ticker.removeEventListener("tick", onTick);
			}
			else
			{
				_ticker.addEventListener("tick", onTick, false, 0, true);
				if (_repeat != -1 && _position >= _duration * (_repeat + 1))
				{
					setPosition(0, true);
				}
				else
				{
					updatePositionOffset();
				}
			}
			setGCLock(!v);
		}
		
		
		/**
		 * Returns the calculated absolute position in the tween. This is a deterministic value between 0 and duration calculated
		 * from the current position based on the duration, repeat, reflect, and reversed properties.
		 * <br/><br/>
		 * For example, a tween with a position
		 * of 5 on a tween with a duration of 3, and repeat set to true would have a tweenPosition of 2 (2 seconds into the first repeat).
		 * The same tween with reflect set to true would have a tweenPosition of 1 (because it would be 2 seconds into the first repeat which is
		 * playing backwards). With reflect and reversed set to true it would have a tweenPosition of 2.
		 * <br/><br/>
		 * Tweens with a position less than 0 will have a tweenPosition of 0. Tweens with a position greater than <code>duration*(repeat+1)</code>
		 * (the total length of the tween) will have a tweenPosition equal to duration.
		 */
		public function get tweenPosition():Number
		{
			return _tweenPosition;
		}
		
		
		/**
		 * The target object to tween. This can be any kind of object.
		 */
		public function get target():Object
		{
			return _target;
		}
		public function set target(v:Object):void
		{
			_propertyTarget = _target = (v === null) ? {} : v;
			_isInitialized = false;
		}
		
		
		/**
		 * Returns the object that will have its property tweened. In a standard HTween, this will usually be the same as target, except if an assignmentTarget was set.
		 * This also makes it easy for subclasses like HTweenFilter can divert the property target.
		 */
		public function get propertyTarget():Object
		{
			return _propertyTarget;
		}
		
		
		/**
		 * Indicates whether a tween should run in reverse. In the simplest examples this means that the tween will play from its end values to its start values.
		 * See "reflect" for more information on how these two related properties interact. Also see reverse().
		 */
		public function get reversed():Boolean
		{
			return _reversed;
		}
		public function set reversed(v:Boolean):void
		{
			if (v == _reversed) return;
			_reversed = v;
			
			/* we force an init so that it jumps to the proper position immediately
			 * without flicker. */
			if (!_isInitialized) init();
			
			setPosition(_position, true);
		}
		
		
		/**
		 * Returns the current positional state of the tween. This does not indicate if the tween is paused - use the .paused property for this. Possible values are: <code>
		 * HTween.START, HTween.DELAY, HTween.TWEEN, HTween.END</code><br/>
		 * The beginning state indicates the tween either has not been played. The tween's position will equal -delay.<br/>
		 * The delayPhase state indicates that the tween is active (running), but is currently delaying prior to initing. The tween's position is less than 0. Note that it may be paused.<br/>
		 * The tweenPhase state indicates that the tween has inited, and is tweening the property values. Note that it may be paused.<br/>
		 * The end state indicates that the tween has completed playing. Setting any new properties on the tween will reset it, and set its state to beginning.
		 * <br/><br/>
		 * New tweens with autoplay set to false start with a state of START. When first played, a tween will have a state of either DELAY (if delay > 0) or TWEEN (if delay == 0).
		 * When the delay ends, and tweening begins, the state will change to TWEEN. When the tween reaches its end <code>position == duration*(repeat+1)</code>, the state will be set to END. If you change any end
		 * properties on an ended tween, its state will be set back to START.
		 */
		public function get state():String
		{
			return (_position == -_delay && _paused)
				? STATE_START
				: (_position < 0)
				? STATE_DELAY
				: (_repeat != -1 && _position >= (_repeat + 1) * _duration)
				? STATE_END
				: STATE_TWEEN;
		}
		
		
		/**
		 * The length of the delay in frames or seconds (depending on the timingMode).
		 * The delay occurs before a tween reads initial values or starts playing.
		 */
		public function get delay():Number
		{
			return _delay;
		}
		public function set delay(v:Number):void
		{
			if (_position == -_delay) setPosition(-v);
			_delay = v;
		}
		
		
		/**
		 * If set to true, this prevents the tween from reinitializing its start properties automatically (ex. when end properties change).
		 * If start properties have not already been initialized, this will also cause the tween to immediate initialize them.
		 * Note that this will prevent new start property values from being initialized when invalidating, so it could cause unexpected behaviour
		 * if you modify the tween while it is playing.
		 */
		public function get lockStartProperties():Boolean
		{
			return _lockStartProperties;
		}
		public function set lockStartProperties(v:Boolean):void
		{
			if (v && !_isInitialized) init();
			_lockStartProperties = v;
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Event Handlers                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * empty listener used by setGCLock.
		 * @private
		 */
		protected function onNonExistentEvent(e:Event):void 
		{
		}
		
		
		/**
		 * handles tick events while playing.
		 * @private
		 */
		protected function onTick(e:Event):void 
		{
			_isInTick = true;
			if (_pauseAll) 
			{ 
				updatePositionOffset(); 
			}
			else 
			{ 
				setPosition(_ticker.position - _positionOffset, false); 
			}
			_isInTick = false;
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * copies the initial target properties into the local startValues store.
		 * @private
		 */
		protected function init():void
		{
			_isInitialized = true;
			
			if (_lockStartProperties) return;
			
			_startValues = {};
			
			if (_assignmentTarget && _assignmentProperty) 
			{ 
				_propertyTarget = _assignmentTarget[_assignmentProperty]; 
			}
			
			for (var n:String in _endValues) 
			{
				if (_autoRotation && _rotationProperties[n]) 
				{
					var r:Number = _endValues[n] = _endValues[n] % 360;
					var tr:Number = _propertyTarget[n] % 360;
					_startValues[n] = tr + ((Math.abs(tr - r) < 180) ? 0 : (tr > r) ? -360 : 360);
				} 
				else 
				{
					_startValues[n] = _propertyTarget[n];
				}
			}
		}
		
		
		/**
		 * logic that runs each frame. Calculates eased position, updates properties,
		 * and reassigns the target if an assignmentTarget was set.
		 * 
		 * @private
		 */
		protected function updateProperties():void
		{
			var ratio:Number = _easing(_tweenPosition / _duration, 0, 1, 1);
			
			for (var n:String in _endValues)
			{
				updateProperty(n, _startValues[n], _endValues[n], ratio);
			}
			
			if (_autoVisible && "alpha" in _endValues && "alpha" in _propertyTarget
				&& "visible" in _propertyTarget)
			{ 
				_propertyTarget.visible = _propertyTarget.alpha > 0; 
			}
			
			if (_assignmentTarget && _assignmentProperty) 
			{ 
				_assignmentTarget[_assignmentProperty] = _propertyTarget; 
			}
		}
		
		
		/**
		 * updates a single property. Mostly for overriding.
		 * @private
		 */
		protected function updateProperty(property:String,
											  startValue:Number,
											  endValue:Number,
											  tweenRatio:Number):void
		{
			var value:Number = startValue + (endValue - startValue) * tweenRatio;
			
			if (_snapping && _snappingProperties[property]) 
			{ 
				value = _mathRound(value); 
			}
			
			if (property == "currentFrame") 
			{ 
				_propertyTarget.gotoAndStop(value << 0); 
			}
			else 
			{ 
				_propertyTarget[property] = value; 
			}
		}
		
		
		/**
		 * locks or unlocks the tween in memory.
		 * @private
		 */
		protected function setGCLock(value:Boolean):void
		{
			if (value) 
			{
				if (_target is IEventDispatcher) 
				{ 
					_target.addEventListener("GDS__NONEXISTENT_EVENT", onNonExistentEvent,
						false, 0, false);
				}
				else 
				{ 
					_activeTweens[this] = true; 
				}
			} 
			else 
			{
				if (_target is IEventDispatcher) 
				{ 
					_target.removeEventListener("GDS__NONEXISTENT_EVENT", onNonExistentEvent);
				}
				delete(_activeTweens[this]);
			}
		}
		
		
		/**
		 * copies an object's dynamic properties.
		 * @private
		 */
		protected function copyObject(o:Object):Object
		{
			var copy:Object = {};
			for (var n:String in o) 
			{
				copy[o] = o[n];
			}
			return copy;
		}
		
		
		/**
		 * updates the current positionOffset based on the current ticker position.
		 * @private
		 */
		protected function updatePositionOffset():void
		{
			_positionOffset = _ticker.position - _position;
		}
	}
}


import com.hexagonstar.tween.HTween;

import flash.display.Shape;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.events.TimerEvent;
import flash.utils.Proxy;
import flash.utils.Timer;
import flash.utils.flash_proxy;
import flash.utils.getTimer;


/* --------------------------------------------------------------------------------------- */

interface ITicker extends IEventDispatcher
{
	function get position():Number;
}


/* --------------------------------------------------------------------------------------- */

class TimeTicker extends EventDispatcher implements ITicker
{
	protected var _timer:Timer;
	
	public function TimeTicker():void 
	{
		_timer = new Timer(20);
		_timer.start();
		_timer.addEventListener(TimerEvent.TIMER, onTimer);
	}
	
	public function get position():Number
	{
		return getTimer() / 1000;
	}
	
	public function set interval(v:Number):void
	{
		_timer.delay = v * 1000;
	}
	
	protected function onTimer(e:TimerEvent):void 
	{
		dispatchEvent(new Event("tick"));
		e.updateAfterEvent();
	}
}


/* --------------------------------------------------------------------------------------- */

class FrameTicker extends EventDispatcher implements ITicker
{
	protected var _shape:Shape;
	protected var _position:Number = 0;
	
	public function FrameTicker():void
	{
		_shape = new Shape();
		_shape.addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	
	public function get position():Number 
	{
		return _position;
	}
	
	protected function onEnterFrame(e:Event):void
	{
		_position++;
		dispatchEvent(new Event("tick"));
	}
}


/* --------------------------------------------------------------------------------------- */

class HybridTicker extends EventDispatcher implements ITicker
{
	protected var _shape:Shape;
	
	public function HybridTicker():void 
	{
		_shape = new Shape();
		_shape.addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	
	public function get position():Number 
	{
		return getTimer() / 1000;
	}
	
	protected function onEnterFrame(e:Event):void 
	{
		dispatchEvent(new Event("tick"));
	}
}


/* --------------------------------------------------------------------------------------- */

dynamic class TargetProxy extends Proxy
{
	private var _tween:HTween;
	
	public function TargetProxy(tween:HTween):void 
	{
		_tween = tween;
	}
	
	/* proxy methods */
	flash_proxy override function callProperty(methodName:*, ...args:Array):*
	{
		return _tween.propertyTarget[methodName].apply(null, args); // GDS: propertyTarget.
	}
	
	flash_proxy override function getProperty(p:*):*
	{
		var v:Number = _tween.getProperty(p);
		return (isNaN(v)) ? _tween.propertyTarget[p] : v;
	}
	
	flash_proxy override function setProperty(p:*, v:*):void
	{
		if (isNaN(v)) 
		{
			_tween.propertyTarget[p] = v;
		}
		else
		{
			_tween.setProperty(String(p), Number(v));
		}
	}
	
	flash_proxy override function deleteProperty(p:*):Boolean
	{
		return _tween.deleteProperty(p);
	}
}
