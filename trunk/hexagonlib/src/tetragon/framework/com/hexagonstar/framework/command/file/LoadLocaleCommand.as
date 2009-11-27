package com.hexagonstar.framework.command.file
{
	import com.hexagonstar.framework.io.loaders.LocaleLoader;
	import com.hexagonstar.framework.model.Locale;

	
	/**
	 * LoadLocaleCommand Class
	 * @author Sascha Balkau
	 */
	public class LoadLocaleCommand extends AbstractLoadCommand
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new LoadConfigCommand instance.
		 */
		public function LoadLocaleCommand()
		{
			super();
		}
		
		
		/**
		 * Execute the command.
		 */ 
		override public function execute():void
		{
			/* Initialize the locale model before we load any locale data */
			Locale.init();
			
			var path:String = Main.config.localePath + "/" + Main.config.currentLocale + ".locale";
			_loader = new LocaleLoader(path, "localeFile");
			
			super.execute();
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		
		override public function get name():String
		{
			return "loadLocale";
		}
	}
}
