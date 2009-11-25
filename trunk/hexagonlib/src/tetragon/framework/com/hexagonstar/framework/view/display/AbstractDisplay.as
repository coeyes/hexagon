package com.hexagonstar.framework.view.display{	import flash.display.Sprite;	import flash.utils.getQualifiedClassName;		/**	 * AbstractDisplay Class	 * @author Sascha Balkau <sascha@hexagonstar.com>	 */	public class AbstractDisplay extends Sprite implements IDisplay	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new AbstractDisplay instance.		 */		public function AbstractDisplay()		{			super();		}						/**		 * Activates the display's functionality.		 */		public function activate():void		{			/* Abstract method! */		}						/**		 * Deactivates the display's functionality.		 */		public function deactivate():void		{			/* Abstract method! */		}						/**		 * Updates the view. This method should be called only if children		 * of the view need to be updated, e.g. after localization has been		 * changed or if the children need to be re-layouted.		 */		public function update():void		{			updateDisplayText();			layoutChildren();		}						/**		 * Disposes the view to clean up resources that are no longer in use.		 */		public function dispose():void		{			removeEventListeners();		}						/**		 * Returns a string representation of the display.		 * @return A string representation of the display.		 */		override public function toString():String		{			return "[" + getQualifiedClassName(this).match("[^:]*$")[0] + "]";		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Sets up the display. This method should only be called once after		 * object instantiation. It initiates the display by creating child		 * objects and adding event listeners.		 * 		 * @private		 */		protected function setup():void		{			createChildren();			deactivate();			addEventListeners();		}						/**		 * createChildren		 * @private		 */		protected function createChildren():void		{			/* Abstract method! */		}						/**		 * Adds event listeners.		 * @private		 */		protected function addEventListeners():void		{			/* Abstract method! */		}						/**		 * updateDisplayText		 * @private		 */		protected function updateDisplayText():void		{			/* Abstract method! */		}						/**		 * layoutChildren		 * @private		 */		protected function layoutChildren():void		{			/* Abstract method! */		}						/**		 * Removes event listeners.		 * @private		 */		protected function removeEventListeners():void		{			/* Abstract method! */		}	}}