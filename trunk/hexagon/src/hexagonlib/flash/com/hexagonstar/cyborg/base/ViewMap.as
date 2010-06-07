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
package com.hexagonstar.cyborg.base
{
	import com.hexagonstar.cyborg.core.IInjector;
	import com.hexagonstar.cyborg.core.IViewMap;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	
	/**
	 * An abstract <code>IViewMap</code> implementation
	 */
	public class ViewMap extends ViewMapBase implements IViewMap
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/** @private */
		protected var _mappedPackages:Vector.<String>;
		/** @private */
		protected var _mappedTypes:Dictionary;
		/** @private */
		protected var _injectedViews:Dictionary;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new <code>ViewMap</code> object
		 *
		 * @param contextView The root view node of the context. The map will listen for
		 *         ADDED_TO_STAGE events on this node
		 * @param injector An <code>IInjector</code> to use for this context
		 */
		public function ViewMap(contextView:DisplayObjectContainer, injector:IInjector)
		{
			super(contextView, injector);
			
			// mappings - if you can do it with fewer dictionaries you get a prize
			_mappedPackages = new Vector.<String>();
			_mappedTypes = new Dictionary(false);
			_injectedViews = new Dictionary(true);
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function mapPackage(packageName:String):void
		{
			if (_mappedPackages.indexOf(packageName) == -1)
			{
				_mappedPackages.push(packageName);
				activate();
			}
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function unmapPackage(packageName:String):void
		{
			var index:int = _mappedPackages.indexOf(packageName);
			if (index > -1)
			{
				_mappedPackages.splice(index, 1);
			}
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function mapType(type:Class):void
		{
			if (_mappedTypes[type]) return;
			
			_mappedTypes[type] = type;
			if (contextView && (contextView is type))
			{
				injectInto(contextView);
			}
			
			activate();
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function unmapType(type:Class):void
		{
			delete _mappedTypes[type];
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function hasType(type:Class):Boolean
		{
			return (_mappedTypes[type] != null);
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function hasPackage(packageName:String):Boolean
		{
			return _mappedPackages.indexOf(packageName) > -1;
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Internal                                                                           //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		protected override function addListeners():void
		{
			if (contextView && enabled && _active)
			{
				contextView.addEventListener(Event.ADDED_TO_STAGE, onViewAdded,
					_useCapture, 0, true);
			}
		}
		
		
		/**
		 * @private
		 */
		protected override function removeListeners():void
		{
			if (contextView && enabled && _active)
			{
				contextView.removeEventListener(Event.ADDED_TO_STAGE, onViewAdded,
					_useCapture);
			}
		}
		
		
		/**
		 * @private
		 */
		protected override function onViewAdded(e:Event):void
		{
			var target:DisplayObject = DisplayObject(e.target);
			if (_injectedViews[target]) return;
			
			for each (var type:Class in _mappedTypes)
			{
				if (target is type)
				{
					injectInto(target);
					return;
				}
			}
			
			var len:int = _mappedPackages.length;
			if (len > 0)
			{
				var className:String = getQualifiedClassName(target);
				for (var i:int = 0;i < len;i++)
				{
					if (className.indexOf(_mappedPackages[i]) == 0)
					{
						injectInto(target);
						return;
					}
				}
			}
		}
		
		
		/**
		 * @private
		 */
		protected function injectInto(target:DisplayObject):void
		{
			_injector.injectInto(target);
			_injectedViews[target] = true;
		}
	}
}
