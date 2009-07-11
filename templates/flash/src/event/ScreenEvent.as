package event
{
	import view.screens.IScreen;

	import flash.events.Event;

	
	/**
	 * @author Sascha Balkau <sascha@hexagonstar.com>
	 */
	public class ScreenEvent extends Event
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		
		public static const SCREEN_OPEN:String	= "screenOpen";
		public static const SCREEN_CLOSE:String	= "screenClose";
		
		
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
			_screen = screen;
			super(type, bubbles, cancelable);
		}
		
		
		/**
		 * clone
		 */
		override public function clone():Event
		{
			return new ScreenEvent(type, _screen, bubbles, cancelable);
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		
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
