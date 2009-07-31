package managers
{
	import event.ScreenEvent;

	import util.Log;

	import view.screens.IScreen;

	import com.hexagonstar.tween.HTween;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	
	/**
	 * Manages opening and closing as well as updating of screens.
	 * @author Sascha Balkau <sascha@hexagonstar.com>
	 */
	public class ScreenManager extends EventDispatcher
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		
		protected static const TWEEN_DURATION:Number = 0.3;
		protected static const TWEEN_IN_PROPERTIES:Object = {alpha: 1.0};
		protected static const TWEEN_OUT_PROPERTIES:Object = {alpha: 0.0};
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		protected var _screenParent:DisplayObjectContainer;
		protected var _screen:DisplayObject;
		protected var _nextScreen:DisplayObject;
		protected var _openScreenClass:Class;
		
		protected var _screenCloseDelay:Number;
		
		protected var _isTweening:Boolean = false;
		protected var _isDeferredUpdate:Boolean = false;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new ScreenManager instance.
		 * 
		 * @param screenParent the parent container for all screens.
		 * @param screenCloseDelay The delay (in ms) after that a screen closes.
		 */
		public function ScreenManager(screenParent:DisplayObjectContainer,
										  screenCloseDelay:Number = 0.2)
		{
			super();
			_screenParent = screenParent;
			_screenCloseDelay = screenCloseDelay;
		}

		
		/**
		 * Opens the screen of the specified class. Any currently opened
		 * screen is closed before the new screen is opened.
		 * 
		 * @param screenClass The screen class.
		 */
		public function openScreen(screenClass:Class):void
		{
			if (_openScreenClass == screenClass) return;
			
			var screen:DisplayObject = new screenClass();
			if (screen is IScreen)
			{
				_openScreenClass = screenClass;
				_nextScreen = screen;
				_nextScreen.alpha = 0;
				_screenParent.addChild(_nextScreen);
				closeLastScreen();
			}
			else
			{
				Log.fatal(toString() + " Tried to open a screen that is not of type IScreen ("
					+ screenClass + ")!");
			}
		}
		
		
		/**
		 * Updates the currently opened screen or the screen that is being opened.
		 */
		public function updateScreen():void
		{
			/* If we call updateScreen right after openScreen we need to delay
			 * the update or the old screen will be updated instead of the newly
			 * opened one. */
			if (_isTweening)
			{
				_isDeferredUpdate = true;
			}
			else
			{
				if (_screen) IScreen(_screen).update();
			}
		}
		
		
		/**
		 * Closes the currently opened screen. This is normally not necessary unless
		 * you need a situation where no screens are on the stage.
		 */
		public function closeScreen():void
		{
			if (!_screen) return;
			_nextScreen = null;
			closeLastScreen();
		}
		
		
		/**
		 * Returns a String Representation of ScreenManager.
		 * @return A String Representation of ScreenManager.
		 */
		override public function toString():String
		{
			return "[ScreenManager]";
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Returns the currently opened screen.
		 */
		public function get currentScreen():IScreen
		{
			return IScreen(_screen);
		}
		
		
		/**
		 * The delay (in ms) after that a screen closes.
		 */
		public function get screenCloseDelay():Number
		{
			return _screenCloseDelay;
		}
		public function set screenCloseDelay(v:Number):void
		{
			_screenCloseDelay = v;
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Event Handlers                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		protected function onTweenInComplete(e:Event):void
		{
			Log.trace(toString() + " opened screen " + _screen);
			
			_isTweening = false;
			dispatchEvent(new ScreenEvent(ScreenEvent.SCREEN_OPEN, IScreen(_screen)));
			IScreen(_screen).activate();
			
			if (_isDeferredUpdate)
			{
				_isDeferredUpdate = false;
				IScreen(_screen).update();
			}
		}
		
		
		/**
		 * @private
		 */
		protected function onTweenOutComplete(e:Event):void
		{
			Log.trace(toString() + " closed screen " + _screen);
			
			_isTweening = false;
			var oldScreen:DisplayObject = _screen;
			_screenParent.removeChild(_screen);
			IScreen(_screen).dispose();
			_screen = null;
			dispatchEvent(new ScreenEvent(ScreenEvent.SCREEN_CLOSE, IScreen(oldScreen)));
			openNextScreen();
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * closeLastScreen
		 * @private
		 */
		protected function closeLastScreen():void
		{
			if (_screen)
			{
				IScreen(_screen).deactivate();
				_isTweening = true;
				var tween:HTween = new HTween(_screen, TWEEN_DURATION, TWEEN_OUT_PROPERTIES);
				tween.delay = _screenCloseDelay;
				tween.addEventListener(Event.COMPLETE, onTweenOutComplete, false, 0, true);
				tween.play();
			}
			else
			{
				openNextScreen();
			}
		}
		
		
		/**
		 * openNextScreen
		 * @private
		 */
		protected function openNextScreen():void
		{
			if (_nextScreen)
			{
				_screen = _nextScreen;
				IScreen(_screen).init();
				_isTweening = true;
				var tween:HTween = new HTween(_screen, TWEEN_DURATION, TWEEN_IN_PROPERTIES);
				tween.addEventListener(Event.COMPLETE, onTweenInComplete, false, 0, true);
				tween.play();
			}
		}
	}
}
