package com.hexagonstar.framework.command.env{	import com.hexagonstar.env.*;	import com.hexagonstar.framework.Main;	import com.hexagonstar.framework.util.Log;	import com.hexagonstar.pattern.cmd.Command;	import flash.desktop.*;	import flash.utils.setTimeout;		/**	 * This command is responsible for closing the application.	 * It first makes sure that the window won't automatically close the application.	 * 	 * @author Sascha Balkau <sascha@hexagonstar.com>	 */	public class CloseApplicationCommand extends Command	{		////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new CloseApplicationCommand instance.		 */		public function CloseApplicationCommand()		{			super();		}						/**		 * Execute the command.		 */ 		override public function execute():void		{			super.execute();						/*FDT_IGNORE*/			CONFIG::IS_AIR			/*FDT_IGNORE*/			{				WindowBoundsManager.instance.storeWindowBounds();			}						Log.debug("Exiting ...");			setTimeout(delayedExecute, 200);		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				override public function get name():String		{			return "appClose";		}						/**		 * delayedExecute		 * @private		 */		private function delayedExecute():void		{			/*FDT_IGNORE*/			CONFIG::IS_AIR			/*FDT_IGNORE*/			{				Main.app.stage.nativeWindow.visible = false;				NativeApplication.nativeApplication.exit();			}		}	}}