package view 
{
	/**
	 * The base interface for all view types.
	 * @author Sascha Balkau <sascha@hexagonstar.com>
	 */
	public interface IView 
	{
		/**
		 * Initializes the view.
		 */
		function init():void;
		
		
		/**
		 * Updates the view. Call this method whenever child objects of the view
		 * need to be updated, e.g. after localization was changed.
		 */
		function update():void;
		
		
		/**
		 * Disposes the view to clean up used resources.
		 */
		function dispose():void;
		
		
		/**
		 * Returns a String Representation of the view.
		 * @return A String Representation of the view.
		 */
		function toString():String;
	}
}
