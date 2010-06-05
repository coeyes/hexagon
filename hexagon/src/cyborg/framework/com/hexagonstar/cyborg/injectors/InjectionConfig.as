/*
 * cyborg - ActionScript3 application framework based on robotlegs.
 * 
 *  ___   |_  __    __
 * |___\_||_|(__)|/|__|
 *      _|           _|
 *  
 * Licensed under the MIT License
 * 
 * Copyright (c) 2010 Hexagon Star Softworks
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
package com.hexagonstar.cyborg.injectors
{
	import com.hexagonstar.cyborg.injectors.results.InjectionResult;

	
	/**
	 * InjectionConfig class
	 */
	public class InjectionConfig
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		public var request:Class;
		public var injectionName:String;
		
		/** @private */
		private var _injector:Injector;
		/** @private */
		private var _result:InjectionResult;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		public function InjectionConfig(request:Class, injectionName:String)
		{
			this.request = request;
			this.injectionName = injectionName;
		}
		
		
		public function getResponse(injector:Injector):Object
		{
			if (_result) return _result.getResponse(_injector || injector);
			var parentConfig:InjectionConfig =
				(_injector || injector).getAncestorMapping(request, injectionName);
			if (parentConfig) return parentConfig.getResponse(injector);
			return null;
		}
		
		
		public function hasResponse(injector:Injector):Boolean
		{
			if (_result) return true;
			var parentConfig:InjectionConfig =
				(_injector || injector).getAncestorMapping(request, injectionName);
			return parentConfig != null;
		}
		
		
		public function hasOwnResponse():Boolean
		{
			return _result != null;
		}
		
		
		public function setResult(result:InjectionResult):void
		{
			_result = result;
		}
		
		
		public function setInjector(injector:Injector):void
		{
			_injector = injector;
		}
	}
}
