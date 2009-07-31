package view.displays
{
	import com.hexagonstar.display.BaseSprite;

	
	/**
	 * @author Sascha Balkau <sascha@hexagonstar.com>
	 */
	public class AbstractDisplay extends BaseSprite
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new instance.
		 */
		public function AbstractDisplay()
		{
			super();
			setup();
		}
		
		
		/**
		 * init
		 */
		public function init():void
		{
		}
		
		
		/**
		 * update
		 */
		public function update():void
		{
		}
		
		
		/**
		 * Removes event listeners from the screen and it's child objects. This method
		 * should not be called manually. Instead it is called by BaseSprite.dispose()!
		 */
		override public function removeEventListeners():void
		{
			/* Remove all listeners added to children of this screen
			 * here before the call to super.removeEventListeners()! */
			super.removeEventListeners();
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Event Handlers                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * setup
		 * @private
		 */
		protected function setup():void
		{
			createChildren();
			addEventListeners();
		}
		
		
		/**
		 * createChildren
		 * @private
		 */
		protected function createChildren():void
		{
		}
		
		
		/**
		 * addEventListeners
		 * @private
		 */
		protected function addEventListeners():void
		{
		}
	}
}
