package view.screens 
{
	import view.IView;

	
	/**
	 * Interface for Screens.
	 * @author Sascha Balkau <sascha@hexagonstar.com>
	 */
	public interface IScreen extends IView 
	{
		/**
		 * Activates the screen's functionality. This method is called by ScreenManager
		 * after the screen has been made visible (e.g. after it finished fading in).
		 */
		function activate():void;
		
		
		/**
		 * Deactivates the screen's functionality. This method is called by ScreenManager
		 * right before it is about to disappear (e.g. before being faded out).
		 */
		function deactivate():void;
	}
}
