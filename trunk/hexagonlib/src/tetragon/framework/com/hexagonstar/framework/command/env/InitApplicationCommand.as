package com.hexagonstar.framework.command.env
{
	import com.hexagonstar.framework.command.file.LoadConfigCommand;
	import com.hexagonstar.framework.command.file.LoadLocaleCommand;
	import com.hexagonstar.pattern.cmd.CompositeCommand;

	
	/**
	 * This composite command is used to manage initialization of the application.
	 * 
	 * The following tasks are taken care of by this command in order:
	 * 1. Load App Config
	 * 2. Load Locale
	 * 3. Init KeyManager
	 * 
	 * @author Sascha Balkau
	 */
	public class InitApplicationCommand extends CompositeCommand
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new InitApplicationCommand instance.
		 */
		public function InitApplicationCommand()
		{
			super();
		}
		
		
		/**
		 * Execute the application initialization command.
		 */ 
		override public function execute():void
		{
			/* Ignore whitespace on all XML data files */
			XML.ignoreWhitespace = true;
			
			/* Initlialize main data model before anything is loaded */
			Main.data.init();
			
			super.execute();
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		
		override public function get name():String
		{
			return "appInit";
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		override protected function enqueueCommands():void
		{
			enqueue(new LoadConfigCommand(), "Config file loading complete.");
			enqueue(new LoadLocaleCommand(), "Locale loading complete.");
			enqueue(new InitKeyManagerCommand(), "KeyManager initialization complete.");
		}
	}
}
