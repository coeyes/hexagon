/*
 * tetragon - Application framework for Flash, Flash/AIR, Flex & Flex/AIR.
 * 
 * Licensed under the MIT License
 * Copyright (c) 2008-2009 Sascha Balkau / Hexagon Star Softworks
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
package 
{
	import com.hexagonstar.env.preload.IPreloadable;
	import com.hexagonstar.env.preload.Preloader;
	import com.hexagonstar.framework.Main;

	/**
	 * The 'front door' of the application.
	 * 
	 * This class is only used for web-based Flash applications that require a preloader.
	 * It makes itself the delegated class for the AppPreloader which in turn
	 * becomes the root container for all other display objects. This means that
	 * the AppPreloader resides on frame 1 while this class is placed on frame 2.
	 * 
	 * @author Sascha Balkau
	 */
	[Frame(factoryClass="AppPreloader")]
	public class App implements IPreloadable
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/** @private */
		//private var _embeddedAssets:EmbeddedAssets;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new App instance.
		 */
		public function App()
		{
			//_embeddedAssets = new EmbeddedAssets();
		}

		
		/**
		 * Invoked by the preloader after the application has been fully preloaded.
		 * 
		 * @param preloader a reference to the preloader.
		 */
		public function onApplicationPreloaded(preloader:Preloader):void
		{
			Main.instance.onApplicationLoaded(preloader, new AppInfo());
		}
	}
}
