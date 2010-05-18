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
	import com.hexagonstar.motion.tween.plugins.IHTweenPlugin;

	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	
	/**
	 * HTween is a light-weight instance oriented tween engine. This means that you
	 * instantiate tweens for specific purposes, and then reuse, update or discard them.
	 * This is different than centralized tween engines where you "register" tweens with
	 * a global object. This provides a more familiar and useful interface for object
	 * oriented programmers. <br/>
	 * <br/>
	 * In addition to a more traditional setValue/setValues tweening interface, HTween
	 * also provides a unique proxy interface to tween and access properties of target
	 * objects in a more dynamic fashion. This allows you to work with properties
	 * directly, and mostly ignore the details of the tween. The proxy "stands in" for
	 * your object when working with tweened properties. For example, you can modify end
	 * values (the value you are tweening to), in the middle of a tween. You can also
	 * access them dynamically, like so: <br/>
	 * <br/>
	 * <code>mySpriteTween.proxy.rotation += 50;</code> <br/>
	 * <br/>
	 * Assuming no end value has been set for rotation previously, the above example
	 * will get the current rotation from the target, add 50 to it, set it as the end
	 * value for rotation, and start the tween. If the tween has already started, it
	 * will adjust for the new values. This is a hugely powerful feature that requires a
	 * bit of exploring to completely understand. See the documentation for the "proxy"
	 * property for more information. <br/>
	 * <br/>
	 * For a light-weight engine (~3.5kb), HTween boasts a number of advanced features:
	 * <UL>
	 * <LI>frame and time based durations/positions which can be set per tween
	 * <LI>works with any numeric properties on any object (not just display objects)
	 * <LI>simple sequenced tweens using .nextTween
	 * <LI>pause and resume individual tweens or all tweens
	 * <LI>jump directly to the end or beginning of a tween with .end() or .beginning()
	 * <LI>jump to any arbitrary point in the tween with .position
	 * <LI>complete, init, and change callbacks
	 * <LI>smart garbage collector interactions (prevents collection while active,
	 * allows collection if target is collected)
	 * <LI>uses any standard ActionScript tween functions
	 * <LI>easy to set up in a single line of code
	 * <LI>can repeat or reflect a tween a specified number of times
	 * <LI>deterministic, so setting a position on a tween will (almost) always result
	 * in predictable results
	 * <LI>very powerful sequencing capabilities in conjunction with HTweenTimeline.
	 * </UL>
	 * <hr/>
	 * <b>Version 2 Notes (Oct 2, 2009):</b><br/>
	 * HTween version 2 constitutes a complete rewrite of the library. This version is
	 * 20% smaller than beta 5 (<3.5kb), it performs up to 5x faster, adds timeScale
	 * functionality, and supports a simple but robust plug-in model. The logic and
	 * source is also much simpler and easy to follow.
	 * <hr/>
	 * <b>Version 2.01 Notes (Dec 11, 2009):</b><br/>
	 * Minor update based on user feedback:
	 * <UL>
	 * <LI>added HTween.version property. (thanks Colin Moock for the request)
	 * <LI>added .dispatchEvents and HTween.defaultDispatchEvents properties, so you can
	 * enable AS3 events. (thanks Colin Moock for the request)
	 * <LI>fixed a problem with tweens in a timeline initing at the wrong time, and
	 * added support for position values less than -delay. (thanks Erik Blankinship for
	 * the bug report)
	 * <LI>fixed a problem with tween values being set to NaN before the controlling
	 * timeline started playing. (thanks to Erik for the bug report)
	 * <LI>added support for multiple callbacks at a single position to HTweenTimeline.
	 * (thanks to sharvey, edzis for the feature request)
	 * <LI>fixed issue with callbacks being called again when a timeline completes.
	 * (thanks to edzis for the bug report)
	 * </UL>
	 */
	public class HTween extends EventDispatcher 
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Indicates the version number for this build. The numeric value will always
		 * increase with the version number for easy comparison (ex. HTween.version >=
		 * 2.12). Currently, it incorporates the major version as the integer value, and the
		 * two digit build number as the decimal value. For example, the fourth build of
		 * version 3 would have version=3.04.
		 */
		public static var version:Number = 2.01;
		
		/**
		 * Sets the default value of dispatchEvents for new instances.
		 */
		public static var defaultDispatchEvents:Boolean = true;
		
		/**
		 * Specifies the default easing function to use with new tweens. Set to
		 * HTween.linearEase by default.
		 */
		public static var defaultEasing:Function;
		
		/**
		 * Setting this to true pauses all tween instances. This does not affect individual
		 * tweens' .paused property.
		 */
		public static var pauseAll:Boolean = false;
		
		/**
		 * Sets the time scale for all tweens. For example to run all tweens at half speed,
		 * you can set timeScaleAll to 0.5. It is multiplied against each tweens timeScale.
		 * For example a tween with timeScale=2 will play back at normal speed if
		 * timeScaleAll is set to 0.5.
		 */
		public static var timeScaleAll:Number = 1;
		
		/**
		 * Allows you to associate arbitrary data with your tween. For example, you might
		 * use this to reference specific data when handling event callbacks from tweens.
		 */
		public var data:*;
		
		/**
		 * The length of the tween in frames or seconds (depending on the timingMode).
		 * Setting this will also update any child transitions that have synchDuration set
		 * to true.
		 */
		public var duration:Number;
		
		/**
		 * The easing function to use for calculating the tween. This can be any standard
		 * tween function, such as the tween functions in fl.motion.easing.* that come with
		 * Flash CS3. New tweens will have this set to <code>defaultEasing</code>. Setting
		 * this to null will cause HTween to throw null reference errors.
		 */
		public var easing:Function;
		
		/**
		 * Specifies another HTween instance that will have <code>paused=false</code> set on
		 * it when this tween completes. This happens immediately before onComplete is
		 * called.
		 */
		public var nextTween:HTween;
		
		/**
		 * Stores data for plugins specific to this instance. Some plugins may allow you to
		 * set properties on this object that they use. Check the documentation for your
		 * plugin to see if any properties are supported. Most plugins also support a
		 * property on this object in the form PluginNameEnabled to enable or disable the
		 * plugin for this tween (ex. BlurEnabled for BlurPlugin). Many plugins will also
		 * store internal data in this object.
		 */
		public var pluginData:Object;
		
		/**
		 * The target object to tween. This can be any kind of object. You can retarget a
		 * tween at any time, but changing the target in mid-tween may result in unusual
		 * behaviour.
		 */
		public var target:Object;
		
		/**
		 * The number of times this tween will run. If 1, the tween will only run once. If 2
		 * or more, the tween will repeat that many times. If 0, the tween will repeat
		 * forever.
		 */
		public var repeatCount:int = 1;
		
		/**
		 * Allows you to scale the passage of time for a tween. For example, a tween with a
		 * duration of 5 seconds, and a timeScale of 2 will complete in 2.5 seconds. With a
		 * timeScale of 0.5 the same tween would complete in 10 seconds.
		 */
		public var timeScale:Number = 1;
		
		/**
		 * Indicates whether the tween should automatically play when an end value is changed.
		 * If this is set to true the tween will start playing as soon as it is created. By
		 * default this is set to false which means that either play() has to be called or
		 * the paused property is set to false to start the tween.
		 */
		public var autoPlay:Boolean = false;
		
		/**
		 * Indicates whether the tween should use the reflect mode when repeating. If
		 * reflect is set to true, then the tween will play backwards on every other repeat.
		 */
		public var reflect:Boolean;
		
		/**
		 * If true, durations and positions can be set in frames. If false, they are
		 * specified in seconds.
		 */
		public var useFrames:Boolean;
		
		/**
		 * If true, events/callbacks will not be called. As well as allowing for more
		 * control over events, and providing flexibility for extension, this results in a
		 * slight performance increase, particularly if useCallbacks is false.
		 */
		public var suppressEvents:Boolean = false;
		
		/**
		 * If true, it will dispatch init, change, and complete events in addition to
		 * calling the onInit, onChange, and onComplete callbacks. Callbacks provide
		 * significantly better performance, whereas events are more standardized and
		 * flexible (allowing multiple listeners, for example). <br/>
		 * <br/>
		 * By default this will use the value of defaultDispatchEvents.
		 */
		public var dispatchEvents:Boolean;
		
		/**
		 * Callback for the complete event. Any function assigned to this callback will be
		 * called when the tween finishes with a single parameter containing a reference to
		 * the tween. <br/>
		 * <br/>
		 * Ex.<br/>
		 * <code><pre>myTween.onComplete = myFunction;
		 * function myFunction(tween:HTween):void {
		 *	trace("tween completed");
		 * }</pre></code>
		 */
		public var onComplete:Function;
		
		/**
		 * Callback for the change event. Any function assigned to this callback will be
		 * called each frame while the tween is active with a single parameter containing a
		 * reference to the tween.
		 */
		public var onChange:Function;
		
		/**
		 * Callback for the init event. Any function assigned to this callback will be
		 * called when the tween inits with a single parameter containing a reference to the
		 * tween. Init is usually triggered when a tween finishes its delay period and
		 * becomes active, but it can also be triggered by other features that require the
		 * tween to read the initial values, like calling <code>.swapValues()</code>.
		 */
		public var onInit:Function;
		
		/**
		 * The position of the tween at the previous change. This should not be set directly.
		 * @private
		 */
		public var positionOld:Number;
		
		/**
		 * The eased ratio (generally between 0-1) of the tween at the current position.
		 * This should not be set directly.
		 * @private
		 */
		public var ratio:Number;
		
		/**
		 * The eased ratio (generally between 0-1) of the tween at the previous position.
		 * This should not be set directly.
		 * @private
		 */
		public var ratioOld:Number;
		
		/**
		 * The current calculated position of the tween. This is a deterministic value
		 * between 0 and duration calculated from the current position based on the
		 * duration, repeatCount, and reflect properties. This is always a value between 0
		 * and duration, whereas <code>.position</code> can range between -delay and
		 * repeatCount*duration. This should not be set directly.
		 * @private
		 */
		public var calculatedPosition:Number;
		
		/**
		 * The previous calculated position of the tween. See
		 * <code>.calculatedPosition</code> for more information. This should not be set
		 * directly.
		 * @private
		 */
		public var calculatedPositionOld:Number;
		
		/** @private */
		protected static var _hasStarPlugins:Boolean = false;
		/** @private */
		protected static var _plugins:Object = {};
		/** @private */
		protected static var _shape:Shape;
		/** @private */
		protected static var _time:Number;
		/** @private */
		protected static var _tickList:Dictionary = new Dictionary(true);
		/** @private */
		protected static var _gcLockList:Dictionary = new Dictionary(false);
		
		/** @private */
		protected var _delay:Number = 0;
		/** @private */
		protected var _values:Object;
		/** @private */
		protected var _paused:Boolean = true;
		/** @private */
		protected var _position:Number;
		/** @private */
		protected var _inited:Boolean;
		/** @private */
		protected var _initValues:Object;
		/** @private */
		protected var _rangeValues:Object;
		/** @private */
		protected var _proxy:TargetProxy;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		staticInit();
		
		/**
		 * Constructs a new HTween instance.
		 * 
		 * @param target The object whose properties will be tweened. Defaults to null.
		 * @param duration The length of the tween in frames or seconds depending on the
		 *            timingMode. Defaults to 1.
		 * @param values An object containing end property values. For example, to tween to
		 *            x=100, y=100, you could pass {x:100, y:100} as the values object.
		 * @param properties An object containing properties to set on this tween. For example,
		 *            you could pass {ease:myEase} to set the ease property of the new
		 *            instance. It also supports a single special property "swapValues" that
		 *            will cause <code>.swapValues</code> to be called after the values
		 *            specified in the values parameter are set.
		 * @param pluginData An object containing data for installed plugins to use with
		 *            this tween. See <code>.pluginData</code> for more information.
		 */
		public function HTween(target:Object = null,
									duration:Number = 1.0,
									values:Object = null,
									properties:Object = null,
									pluginData:Object = null)
		{
			easing = defaultEasing || linearEasing;
			dispatchEvents = defaultDispatchEvents;
			this.target = target;
			this.duration = duration;
			this.pluginData = copy(pluginData, {});
			
			if (properties)
			{
				var swap:Boolean = properties["swapValues"];
				delete(properties["swapValues"]);
			}
			
			copy(properties, this);
			resetValues(values);
			
			if (swap)
			{
				swapValues();
			}
			
			if (this.duration == 0 && delay == 0 && autoPlay)
			{
				position = 0;
			}
		}
		
		
		/**
		 * The default easing function used by HTween.
		 * 
		 * @param t time
		 * @param b begin position (not used)
		 * @param c change amount (not used)
		 * @param d duration (not used)
		 */
		public static function linearEasing(t:Number, b:Number, c:Number, d:Number):Number
		{
			return t;
		}
		
		
		/**
		 * Installs a plugin for the specified property. Plugins with high priority will
		 * always be called before other plugins for the same property. This method is
		 * primarily used by plugin developers. Plugins are normally installed by calling
		 * the install method on them, such as BlurPlugin.install(). <br/>
		 * <br/>
		 * Plugins can register to be associated with a specific property name, or to be
		 * called for all tweens by registering for the "*" property name. The latter will
		 * be called after all properties are inited or tweened for a particular HTween
		 * instance.
		 * 
		 * @param plugin The plugin object to register. The plugin should conform to the
		 *            IHTweenPlugin interface.
		 * @param propertyNames An array of property names to operate on (ex. "rotation"),
		 *            or "*" to register the plugin to be called for every HTween instance.
		 * @param highPriority If true, the plugin will be added to the start of the plugin
		 *            list for the specified property name, if false it will be added to the
		 *            end.
		 */
		public static function installPlugin(plugin:Object,
												  propertyNames:Array,
												  highPriority:Boolean = false):void
		{
			for (var i:int = 0; i < propertyNames.length; i++)
			{
				var propertyName:String = propertyNames[i];
				if (propertyName == "*")
				{
					_hasStarPlugins = true;
				}
				if (_plugins[propertyName] == null)
				{
					_plugins[propertyName] = [plugin];
					continue;
				}
				if (highPriority)
				{
					(_plugins[propertyName] as Array).unshift(plugin);
				}
				else
				{
					(_plugins[propertyName] as Array).push(plugin);
				}
			}
		}
		
		
		/**
		 * Sets the numeric end value for a property on the target object that you would
		 * like to tween. For example, if you wanted to tween to a new x position, you could
		 * use: myHTween.setValue("x",400).
		 * 
		 * @param name The name of the property to tween.
		 * @param value The numeric end value (the value to tween to).
		 */
		public function setValue(name:String, value:Number):void
		{
			_values[name] = value;
			invalidate();
		}
		
		
		/**
		 * Returns the end value for the specified property if one exists.
		 *
		 * @param name The name of the property to return a end value for.
		 */
		public function getValue(name:String):Number
		{
			return _values[name];
		}
		
		
		/**
		 * Removes a end value from the tween. This prevents the HTween instance from
		 * tweening the property.
		 * 
		 * @param name The name of the end property to delete.
		 */
		public function deleteValue(name:String):Boolean
		{
			delete(_rangeValues[name]);
			delete(_initValues[name]);
			return delete(_values[name]);
		}
		
		
		/**
		 * Shorthand method for making multiple setProperty calls quickly. This adds the
		 * specified properties to the values list. Passing a property with a value of null
		 * will delete that value from the list. <br/>
		 * <br/>
		 * <b>Example:</b> set x and y end values, delete rotation:<br/>
		 * <code>myHTween.setProperties({x:200, y:400, rotation:null});</code>
		 * 
		 * @param properties An object containing end property values.
		 */
		public function setValues(values:Object):void
		{
			copy(values, _values, true);
			invalidate();
		}
		
		
		/**
		 * Similar to <code>.setValues()</code>, but clears all previous end values before
		 * setting the new ones.
		 * 
		 * @param properties An object containing end property values.
		 */
		public function resetValues(values:Object = null):void
		{
			_values = {};
			setValues(values);
		}
		
		
		/**
		 * Returns the hash table of all end properties and their values. This is a copy of
		 * the internal hash of values, so modifying the returned object will not affect the
		 * tween.
		 */
		public function getValues():Object
		{
			return copy(_values, {});
		}
		
		
		/**
		 * Returns the initial value for the specified property. Note that the value will
		 * not be available until the tween inits.
		 */
		public function getInitValue(name:String):Number
		{
			return _initValues[name];
		}
		
		
		/**
		 * Swaps the init and end values for the tween, effectively reversing it. This
		 * should generally only be called before the tween starts playing. This will force
		 * the tween to init if it hasn't already done so, which may result in an onInit
		 * call. It will also force a render (so the target immediately jumps to the new
		 * values immediately) which will result in the onChange callback being called. <br/>
		 * <br/>
		 * You can also use the special "swapValues" property on the props parameter of the
		 * HTween constructor to call swapValues() after the values are set. <br/>
		 * <br/>
		 * The following example would tween the target from 100,100 to its current
		 * position:<br/>
		 * <code>new HTween(ball, 2, {x:100, y:100}, {swapValues:true});</code>
		 */
		public function swapValues():void
		{
			if (!_inited)
			{ 
				init(); 
			}
			
			var o:Object = _values;
			_values = _initValues;
			_initValues = o;
			
			for (var n:String in _rangeValues)
			{
				_rangeValues[n] *= -1;
			}
			
			if (_position < 0)
			{
				/* render it at position 0 */
				var pos:Number = positionOld;
				position = 0;
				_position = positionOld;
				positionOld = pos;
			}
			else
			{
				position = _position;
			}
		}
		
		
		/**
		 * Reads all of the initial values from target and calls the onInit callback. This
		 * is called automatically when a tween becomes active (finishes delaying) and when
		 * <code>.swapValues()</code> is called. It would rarely be used directly but is
		 * exposed for possible use by plugin developers or power users.
		 */
		public function init():void
		{
			_inited = true;
			_initValues = {};
			_rangeValues = {};
			
			for (var n:String in _values)
			{
				if (_plugins[n])
				{
					var pluginArr:Array = _plugins[n];
					var l:int = pluginArr.length;
					var value:Number = (n in target) ? target[n] : NaN;
					
					for (var i:int = 0; i < l; i++)
					{
						value = IHTweenPlugin(pluginArr[i]).init(this, n, value);
					}
					
					if (!isNaN(value))
					{
						_rangeValues[n] = _values[n] - (_initValues[n] = value);
					}
				}
				else
				{
					_rangeValues[n] = _values[n] - (_initValues[n] = target[n]);
				}
			}
			
			if (_hasStarPlugins)
			{
				pluginArr = _plugins["*"];
				l = pluginArr.length;
				
				for (i = 0; i < l; i++)
				{
					IHTweenPlugin(pluginArr[i]).init(this, "*", NaN);
				}
			}
			
			if (!suppressEvents)
			{
				if (dispatchEvents)
				{
					dispatchEvt(Event.INIT);
				}
				if (onInit != null)
				{
					onInit(this);
				}
			}
		}
		
		
		/**
		 * Jumps the tween to its beginning and pauses it. This is the same as setting
		 * <code>position=0</code> and <code>paused=true</code>.
		 */
		public function beginning():void
		{
			position = 0;
			paused = true;
		}
		
		
		/**
		 * Jumps the tween to its end and pauses it. This is roughly the same as setting
		 * <code>position=repeatCount*duration</code>.
		 */
		public function end():void
		{
			position = (repeatCount > 0) ? repeatCount * duration : duration;
		}
		
		
		
		/**
		 * Starts playing the tween.
		 */
		public function play():void
		{
			paused = false;
		}
		
		
		/**
		 * Pauses the tween.
		 */
		public function pause():void
		{
			paused = true;
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Plays or pauses a tween. You can still change the position value externally on a
		 * paused tween, but it will not be updated automatically. While paused is false,
		 * the tween is also prevented from being garbage collected while it is active. This
		 * is achieved in one of two ways:<br/>
		 * 1. If the target object is an IEventDispatcher, then the tween will subscribe to
		 * a dummy event using a hard reference. This allows the tween to be garbage
		 * collected if its target is also collected, and there are no other external
		 * references to it.<br/>
		 * 2. If the target object is not an IEventDispatcher, then the tween is placed in a
		 * global list, to prevent collection until it is paused or completes.<br/>
		 * Note that pausing all tweens via the HTween.pauseAll static property will not
		 * free the tweens for collection.
		 */
		public function get paused():Boolean
		{
			return _paused;
		}
		public function set paused(v:Boolean):void
		{
			if (v == _paused)
			{
				return;
			}
			
			_paused = v;
			
			if (_paused)
			{
				delete(_tickList[this]);
				if (target is IEventDispatcher)
				{
					IEventDispatcher(target).removeEventListener("_", invalidate);
				}
				delete(_gcLockList[this]);
			}
			else
			{
				if (isNaN(_position) || (repeatCount != 0 && _position >= repeatCount * duration))
				{
					/* reached the end, reset. */
					_inited = false;
					calculatedPosition =
					calculatedPositionOld =
					ratio =
					ratioOld =
					positionOld = 0;
					_position = -delay;
				}
				
				_tickList[this] = true;
				
				/* prevent garbage collection */
				if (target is IEventDispatcher)
				{
					IEventDispatcher(target).addEventListener("_", invalidate);
				}
				else
				{
					_gcLockList[this] = true;
				}
			}
		}
		
		
		/**
		 * Gets and sets the position of the tween in frames or seconds (depending on
		 * <code>.useFrames</code>). This value will be constrained between -delay and
		 * repeatCount*duration. It will be resolved to a <code>calculatedPosition</code>
		 * before being applied. <br/>
		 * <br/>
		 * <b>Negative values</b><br/>
		 * Values below 0 will always resolve to a calculatedPosition of 0. Negative values
		 * can be used to set up a delay on the tween, as the tween will have to count up to
		 * 0 before initing. <br/>
		 * <br/>
		 * <b>Positive values</b><br/>
		 * Positive values are resolved based on the duration, repeatCount, and reflect
		 * properties.
		 */
		public function get position():Number
		{
			return _position;
		}
		public function set position(v:Number):void
		{
			positionOld = _position;
			ratioOld = ratio;
			calculatedPositionOld = calculatedPosition;
			
			var maxPosition:Number = repeatCount * duration;
			var end:Boolean = (v >= maxPosition && repeatCount > 0);
			
			if (end)
			{
				if (calculatedPositionOld == maxPosition)
				{
					return;
				}
				
				_position = maxPosition;
				calculatedPosition = (reflect && !(repeatCount & 1)) ? 0 : duration;
			}
			else
			{
				_position = v;
				calculatedPosition = _position < 0 ? 0 : _position % duration;
				
				if (reflect && (_position / duration & 1))
				{
					calculatedPosition = duration - calculatedPosition;
				}
			}
			
			ratio = (duration == 0 && _position >= 0)
				? 1
				: easing(calculatedPosition / duration, 0, 1, 1);
			
			if (target && (_position >= 0 || positionOld >= 0)
				&& calculatedPosition != calculatedPositionOld)
			{
				if (!_inited)
				{
					init();
				}
				
				for (var n:String in _values)
				{
					var initVal:Number = _initValues[n];
					var rangeVal:Number = _rangeValues[n];
					var val:Number = initVal + rangeVal * ratio;
					var pluginArray:Array = _plugins[n];
					
					if (pluginArray)
					{
						var l:int = pluginArray.length;
						for (var i:int = 0; i < l; i++)
						{
							val = IHTweenPlugin(pluginArray[i]).tween(this, n, val, initVal,
								rangeVal, ratio, end);
						}
						
						if (!isNaN(val))
						{
							target[n] = val;
						}
					}
					else
					{
						target[n] = val;
					}
				}
			}
			
			if (_hasStarPlugins)
			{
				pluginArray = _plugins["*"];
				l = pluginArray.length;
				for (i = 0; i < l; i++)
				{
					IHTweenPlugin(pluginArray[i]).tween(this, "*", NaN, NaN, NaN, ratio, end);
				}
			}
			
			if (!suppressEvents)
			{
				if (dispatchEvents)
				{
					dispatchEvt(Event.CHANGE);
				}
				if (onChange != null)
				{
					onChange(this);
				}
			}
			
			if (end)
			{
				paused = true;
				if (nextTween)
				{
					nextTween.paused = false;
				}
				if (!suppressEvents)
				{
					if (dispatchEvents)
					{
						dispatchEvt(Event.COMPLETE);
					}
					if (onComplete != null)
					{
						onComplete(this);
					}
				}
			}
		}
		
		
		/**
		 * The length of the delay in frames or seconds (depending on
		 * <code>.useFrames</code>). The delay occurs before a tween reads initial values or
		 * starts playing.
		 */
		public function get delay():Number
		{
			return _delay;
		}
		public function set delay(v:Number):void
		{
			if (_position <= 0)
			{
				_position = -v;
			}
			_delay = v;
		}
		
		
		/**
		 * The proxy object allows you to work with the properties and methods of the target
		 * object directly through HTween. Numeric property assignments will be used by
		 * HTween as end values. The proxy will return HTween end values when they are set,
		 * or the target's property values if they are not. Delete operations on properties
		 * will result in a deleteProperty call. All other property access and method
		 * execution through proxy will be passed directly to the target object. <br/>
		 * <br/>
		 * <b>Example 1:</b> Equivalent to calling myHTween.setProperty("scaleY",2.5):<br/>
		 * <code>myHTween.proxy.scaleY = 2.5;</code> <br/>
		 * <br/>
		 * <b>Example 2:</b> Gets the current rotation value from the target object (because
		 * it hasn't been set yet on the HTween), adds 100 to it, and then calls setProperty
		 * on the HTween instance with the appropriate value:<br/>
		 * <code>myHTween.proxy.rotation += 100;</code> <br/>
		 * <br/>
		 * <b>Example 3:</b> Sets an end property value (through setProperty) for scaleX,
		 * then retrieves it from HTween (because it will always return end values when
		 * available):<br/>
		 * <code>trace(myHTween.proxy.scaleX); // 1 (value from target, because no end value
		 * is set)<br/>
		 * myHTween.proxy.scaleX = 2; // set a end value<br/>
		 * trace(myHTween.proxy.scaleX); // 2 (end value from HTween)<br/>
		 * trace(myHTween.target.scaleX); // 1 (current value from target)</code>
		 * <br/>
		 * <br/>
		 * <b>Example 4:</b> Property deletions only affect end properties on HTween, not
		 * the target object:<br/>
		 * <code>myHTween.proxy.rotation = 50; // set an end value<br/>
		 * trace(myHTween.proxy.rotation); // 50 (end value from HTween)<br/>
		 * delete(myHTween.proxy.rotation); // delete the end value<br/>
		 * trace(myHTween.proxy.rotation); // 0 (current value from target)</code>
		 * <br/>
		 * <br/>
		 * <b>Example 5:</b> Non-numeric property access is passed through to the target:<br/>
		 * <code>myHTween.proxy.blendMode = "multiply"; // passes value assignment through to
		 * the target<br/>
		 * trace(myHTween.target.blendMode); // "multiply" (value from target)<br/>
		 * trace(myHTween.proxy.blendMode); // "multiply" (value passed through proxy from
		 * target)</code>
		 * <br/>
		 * <br/>
		 * <b>Example 6:</b> Method calls are passed through to target:<br/>
		 * <code>myHTween.proxy.gotoAndStop(30); // gotoAndStop(30) will be called on the
		 * target</code>
		 */
		public function get proxy():TargetProxy
		{
			if (_proxy == null)
			{
				_proxy = new TargetProxy(this);
			}
			return _proxy;
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Event Handlers                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		protected static function onStaticTick(e:Event):void
		{
			var t:Number = _time;
			_time = getTimer() / 1000;
			
			if (pauseAll)
			{
				return;
			}
			
			var dt:Number = (_time - t) * timeScaleAll;
			
			for (var o:Object in _tickList)
			{
				var tween:HTween = o as HTween;
				tween.position = tween._position + (tween.useFrames ? timeScaleAll : dt)
					* tween.timeScale;
			}
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		protected static function staticInit():void
		{
			(_shape = new Shape()).addEventListener(Event.ENTER_FRAME, onStaticTick);
			_time = getTimer() / 1000;
		}
		
		
		/**
		 * @private
		 */
		protected function invalidate():void
		{
			_inited = false;
			if (_position > 0)
			{
				_position = 0;
			}
			if (autoPlay)
			{
				paused = false;
			}
		}
		
		
		/**
		 * @private
		 */
		protected function copy(o1:Object, o2:Object, smart:Boolean = false):Object
		{
			for (var n:String in o1)
			{
				if (smart && o1[n] == null)
				{
					delete(o2[n]);
				}
				else
				{
					o2[n] = o1[n];
				}
			}
			return o2;
		}
		
		
		/**
		 * @private
		 */
		protected function dispatchEvt(name:String):void
		{
			if (hasEventListener(name))
			{
				dispatchEvent(new Event(name));
			}
		}
	}
}

import com.hexagonstar.motion.tween.HTween;

import flash.utils.Proxy;
import flash.utils.flash_proxy;


/* --------------------------------------------------------------------------------------- */





/**
 * @private
 */
dynamic class TargetProxy extends Proxy
{
	private var tween:HTween;
	
	
	public function TargetProxy(t:HTween):void
	{
		tween = t;
	}
	
	/* proxy methods */
	
	flash_proxy override function callProperty(methodName:*, ...args:Array):*
	{
		return Function(tween.target[methodName]).apply(null, args);
	}
	
	flash_proxy override function getProperty(p:*):*
	{
		var value:Number = tween.getValue(p);
		return (isNaN(value)) ? tween.target[p] : value;
	}
	
	flash_proxy override function setProperty(p:*, v:*):void
	{
		if (v is Boolean || v is String || isNaN(v))
		{
			tween.target[p] = v;
		}
		else
		{
			tween.setValue(String(p), Number(v));
		}
	}
	
	flash_proxy override function deleteProperty(p:*):Boolean
	{
		tween.deleteValue(p);
		return true;
	}
}