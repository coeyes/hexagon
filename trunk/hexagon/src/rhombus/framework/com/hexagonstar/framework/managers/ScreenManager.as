/* * rhombus - Application framework for web/desktop-based Flash & Flex projects. *  *  /\ RHOMBUS *  \/ FRAMEWORK *  * Licensed under the MIT License * Copyright (c) 2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.framework.managers{	import com.hexagonstar.framework.event.ScreenEvent;	import com.hexagonstar.framework.util.Log;	import com.hexagonstar.framework.view.screen.IScreen;	import com.hexagonstar.motion.tween.HTween;	import flash.display.DisplayObject;	import flash.display.DisplayObjectContainer;	import flash.events.Event;	import flash.events.EventDispatcher;		/**	 * Manages opening and closing as well as updating of screens.	 * 	 * @author Sascha Balkau	 * @version 1.0.0	 */	public class ScreenManager extends EventDispatcher	{		////////////////////////////////////////////////////////////////////////////////////////		// Constants                                                                          //		////////////////////////////////////////////////////////////////////////////////////////				protected static const TWEEN_DURATION:Number = 0.2;		protected static const TWEEN_IN_PROPERTIES:Object = {alpha: 1.0};		protected static const TWEEN_OUT_PROPERTIES:Object = {alpha: 0.0};						////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				/** @private */		protected var _screenParent:DisplayObjectContainer;		/** @private */		protected var _screen:IScreen;		/** @private */		protected var _nextScreen:DisplayObject;		/** @private */		protected var _openScreenClass:Class;		/** @private */		protected var _screenCloseDelay:Number;		/** @private */		protected var _isLoading:Boolean = false;		/** @private */		protected var _isAutoStart:Boolean = false;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new ScreenManager instance.		 * 		 * @param screenParent the parent container for all screens.		 * @param screenCloseDelay The delay (in seconds) after that a screen closes.		 */		public function ScreenManager(screenParent:DisplayObjectContainer,										  screenCloseDelay:Number = 0.2)		{			super();			_screenParent = screenParent;			_screenCloseDelay = screenCloseDelay;		}				/**		 * Opens the screen of the specified class. Any currently opened screen is closed		 * before the new screen is opened. The class needs to implement IScreen.		 * 		 * @param screenClass The screen class.		 * @param autoStart Determines if the screen should automatically be started once it		 *            has been finished opening. If this is true the screen manager		 *            automatically calls the start() method on the screen after it has been		 *            opened.		 */		public function openScreen(screenClass:Class, autoStart:Boolean = false):void		{			_isAutoStart = false;						/* If the specified screen is already open, only update it! */			if (_openScreenClass == screenClass)			{				updateScreen();				return;			}						var screen:DisplayObject = new screenClass();			if (screen is IScreen)			{				_isLoading = true;				_isAutoStart = autoStart;				_openScreenClass = screenClass;				_nextScreen = screen;				_nextScreen.alpha = 0;				_screenParent.addChild(_nextScreen);				closeLastScreen();			}			else			{				Log.fatal(toString() + " Tried to open a screen that is not of type IScreen ("					+ screenClass + ")!");			}		}						/**		 * Updates the currently opened screen.		 */		public function updateScreen():void		{			if (_screen && !_isLoading) _screen.update();		}						/**		 * Closes the currently opened screen. This is normally not necessary unless		 * you need a situation where no screens should be on the stage.		 */		public function closeScreen():void		{			if (!_screen) return;			_nextScreen = null;			closeLastScreen();		}						/**		 * Returns a String Representation of ScreenManager.		 * 		 * @return A String Representation of ScreenManager.		 */		override public function toString():String		{			return "[ScreenManager]";		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Returns the currently opened screen.		 */		public function get currentScreen():IScreen		{			return _screen;		}						/**		 * The delay (in seconds) after that a screen closes.		 */		public function get screenCloseDelay():Number		{			return _screenCloseDelay;		}		public function set screenCloseDelay(v:Number):void		{			_screenCloseDelay = v;		}						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @private		 */		protected function onScreenCreated(e:ScreenEvent):void		{			_screen.removeEventListener(ScreenEvent.CREATED, onScreenCreated);						/* Disable screen display objects while fading in. */			_screen.enabled = false;						/* Screen is loaded and child objects are created, time to lay out			 * children and update the screen text */			_screen.update();						_isLoading = false;						var tween:HTween = new HTween(_screen, TWEEN_DURATION, TWEEN_IN_PROPERTIES);			tween.addEventListener(Event.COMPLETE, onTweenInComplete, false, 0, true);			tween.play();		}						/**		 * @private		 */		protected function onTweenInComplete(e:Event):void		{			Log.debug(toString() + " Opened " + _screen.toString());						dispatchEvent(new ScreenEvent(ScreenEvent.OPENED, _screen));						/* Everythings' done, screen is faded in! Let's grant user interaction. */			_screen.enabled = true;						/* If autoStart, now is the time to call start on the screen. */			if (_isAutoStart)			{				_isAutoStart = false;				_screen.start();			}		}						/**		 * @private		 */		protected function onTweenOutComplete(e:Event):void		{			Log.debug(toString() + " Closed " + _screen.toString());						var oldScreen:IScreen = _screen;			_screenParent.removeChild(DisplayObject(_screen));			_screen.dispose();			_screen = null;			dispatchEvent(new ScreenEvent(ScreenEvent.CLOSED, oldScreen));			loadNextScreen();		}						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * closeLastScreen		 * @private		 */		protected function closeLastScreen():void		{			if (_screen)			{				_screen.enabled = false;				var tween:HTween = new HTween(_screen, TWEEN_DURATION, TWEEN_OUT_PROPERTIES);				tween.delay = _screenCloseDelay;				tween.addEventListener(Event.COMPLETE, onTweenOutComplete, false, 0, true);				tween.play();			}			else			{				loadNextScreen();			}		}						/**		 * loadNextScreen		 * @private		 */		protected function loadNextScreen():void		{			if (_nextScreen)			{				_screen = IScreen(_nextScreen);				_screen.addEventListener(ScreenEvent.CREATED, onScreenCreated);				_screen.load();			}		}	}}