package com.hexagonstar.core
{
	import flash.display.MovieClip;
	
	
	/**
	 * This class only exists to provide a type-conform class with mx.core.Application
	 * so that both Flex- and non-Flex projects can be set up the same way and without
	 * the need to change the type of the _app property in Main.
	 * 
	 * In a non-Flex project the App class should extend this class while in a Flex
	 * project the App class (App.mxml) automatically extends mx.core.Application.
	 * 
	 * @author Sascha Balkau
	 */
	public class Application extends MovieClip
	{
		/**
		 * Creates a new Application instance.
		 */
		public function Application()
		{
			super();
		}
	}
}
