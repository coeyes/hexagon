package view{	import mx.containers.Canvas;		/**	 * The Application's main UI wrapper. Can extend Sprite/BaseSprite for Flash	 * applications or any Flex framework container class for Flex applications.	 * 	 * @author Sascha Balkau	 */	public class ApplicationUI extends Canvas	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new ApplicationUI instance.		 */		public function ApplicationUI()		{			super();		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * createChildren		 * @private		 */		override protected function createChildren():void		{			super.createChildren();						/* Just for testing Flash-based Component */			//var c:TestComponent = new TestComponent();			//addChild(c);		}	}}