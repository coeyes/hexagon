package com.hexagonstar.framework.event
{
	import com.hexagonstar.framework.view.screen.IScreen;

	import flash.events.Event;

	
	/**
	 * @author Sascha Balkau <sascha@hexagonstar.com>
	 */
	public class ScreenEvent extends Event
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		
		public static const CREATED:String	= "screenCreated";
		public static const OPENED:String	= "screenOpened";
		public static const CLOSED:String	= "screenClosed";
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		protected var _screen:IScreen;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new instance.
		 */
		public function ScreenEvent(type:String,
										screen:IScreen = null,
										bubbles:Boolean = false,
										cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			_screen = screen;
		}
		
		
		/**
		 * Clones the event.
		 */
		override public function clone():Event
		{
			return new ScreenEvent(type, _screen, bubbles, cancelable);
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Gets or sets the screen which fires this event.
		 */
		public function get screen():IScreen
		{
			return _screen;
		}
		public function set screen(v:IScreen):void
		{
			_screen = v;
		}
	}
}
