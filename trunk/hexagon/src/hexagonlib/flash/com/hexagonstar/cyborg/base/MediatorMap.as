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
	import com.hexagonstar.cyborg.core.IMediator;
	import com.hexagonstar.cyborg.core.IMediatorMap;
	import com.hexagonstar.cyborg.core.IReflector;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	
	/**
	 * An abstract <code>IMediatorMap</code> implementation
	 */
	public class MediatorMap extends ViewMapBase implements IMediatorMap
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/** @private */
		protected static const _enterFrameDispatcher:Sprite = new Sprite();
		/** @private */
		protected var _mediatorByView:Dictionary;
		/** @private */
		protected var _mappingConfigByView:Dictionary;
		/** @private */
		protected var _mappingConfigByViewClassName:Dictionary;
		/** @private */
		protected var _mediatorsMarkedForRemoval:Dictionary;
		/** @private */
		protected var _hasMediatorsMarkedForRemoval:Boolean;
		/** @private */
		protected var _reflector:IReflector;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new <code>MediatorMap</code> object
		 *
		 * @param contextView The root view node of the context. The map will listen
		 *         for ADDED_TO_STAGE events on this node
		 * @param injector An <code>IInjector</code> to use for this context
		 * @param reflector An <code>IReflector</code> to use for this context
		 */
		public function MediatorMap(contextView:DisplayObjectContainer, injector:IInjector,
			reflector:IReflector)
		{
			super(contextView, injector);
			
			_reflector = reflector;
			
			// mappings - if you can do it with fewer dictionaries you get a prize
			_mediatorByView = new Dictionary(true);
			_mappingConfigByView = new Dictionary(true);
			_mappingConfigByViewClassName = new Dictionary(false);
			_mediatorsMarkedForRemoval = new Dictionary(false);
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function mapView(viewClassOrName:*, mediatorClass:Class,
			injectViewAs:Class = null, autoCreate:Boolean = true,
			autoRemove:Boolean = true):void
		{
			var viewClassName:String = _reflector.getFQCN(viewClassOrName);
			
			if (_mappingConfigByViewClassName[viewClassName] != null)
			{
				throw new ContextError(ContextError.E_MEDIATORMAP_OVR + " - " + mediatorClass);
			}
			if (_reflector.classExtendsOrImplements(mediatorClass, IMediator) == false)
			{
				throw new ContextError(ContextError.E_MEDIATORMAP_NOIMPL + " - " + mediatorClass);
			}
			
			var config:MappingConfig = new MappingConfig(mediatorClass, null, autoCreate,
				autoRemove);
			
			if (injectViewAs)
			{
				config.typedViewClass = injectViewAs;
			}
			else if (viewClassOrName is Class)
			{
				config.typedViewClass = viewClassOrName;
			}
			
			_mappingConfigByViewClassName[viewClassName] = config;
			if (autoCreate && contextView
				&& (viewClassName == getQualifiedClassName(contextView)))
			{
				createMediator(contextView);
			}
			activate();
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function unmapView(viewClassOrName:*):void
		{
			var viewClassName:String = _reflector.getFQCN(viewClassOrName);
			delete _mappingConfigByViewClassName[viewClassName];
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function createMediator(viewComponent:Object):IMediator
		{
			var mediator:IMediator = _mediatorByView[viewComponent];
			
			if (mediator == null)
			{
				var viewClassName:String = getQualifiedClassName(viewComponent);
				var config:MappingConfig = _mappingConfigByViewClassName[viewClassName];
				
				if (config)
				{
					_injector.mapValue(config.typedViewClass, viewComponent);
					mediator = _injector.instantiate(config.mediatorClass);
					_injector.unmap(config.typedViewClass);
					registerMediator(viewComponent, mediator);
				}
			}
			return mediator;
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function registerMediator(viewComponent:Object, mediator:IMediator):void
		{
			_injector.mapValue(_reflector.getClass(mediator), mediator);
			_mediatorByView[viewComponent] = mediator;
			_mappingConfigByView[viewComponent]
				= _mappingConfigByViewClassName[getQualifiedClassName(viewComponent)];
			mediator.setViewComponent(viewComponent);
			mediator.preRegister();
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function removeMediator(mediator:IMediator):IMediator
		{
			if (mediator)
			{
				var viewComponent:Object = mediator.getViewComponent();
				delete _mediatorByView[viewComponent];
				delete _mappingConfigByView[viewComponent];
				mediator.preRemove();
				mediator.setViewComponent(null);
				_injector.unmap(_reflector.getClass(mediator));
			}
			return mediator;
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function removeMediatorByView(viewComponent:Object):IMediator
		{
			return removeMediator(retrieveMediator(viewComponent));
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function retrieveMediator(viewComponent:Object):IMediator
		{
			return _mediatorByView[viewComponent];
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function hasMediatorForView(viewComponent:Object):Boolean
		{
			return _mediatorByView[viewComponent] != null;
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function hasMediator(mediator:IMediator):Boolean
		{
			for each (var med:IMediator in _mediatorByView)
			{
				if (med == mediator) return true;
			}
			return false;
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
				contextView.addEventListener(Event.REMOVED_FROM_STAGE, onViewRemoved,
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
				contextView.removeEventListener(Event.REMOVED_FROM_STAGE, onViewRemoved,
					_useCapture);
			}
		}
		
		
		/**
		 * @private
		 */		
		protected override function onViewAdded(e:Event):void
		{
			if (_mediatorsMarkedForRemoval[e.target])
			{
				delete _mediatorsMarkedForRemoval[e.target];
				return;
			}
			
			var config:MappingConfig
				= _mappingConfigByViewClassName[getQualifiedClassName(e.target)];
			
			if (config && config.autoCreate)
			{
				createMediator(e.target);
			}
		}
		
		
		/**
		 * Flex framework work-around part #5
		 * @private
		 */
		protected function onViewRemoved(e:Event):void
		{
			var config:MappingConfig = _mappingConfigByView[e.target];
			
			if (config && config.autoRemove)
			{
				_mediatorsMarkedForRemoval[e.target] = e.target;
				
				if (!_hasMediatorsMarkedForRemoval)
				{
					_hasMediatorsMarkedForRemoval = true;
					_enterFrameDispatcher.addEventListener(Event.ENTER_FRAME,
						removeMediatorLater);
				}
			}
		}
		
		
		/**
		 * Flex framework work-around part #6
		 * @private
		 */
		protected function removeMediatorLater(e:Event):void
		{
			_enterFrameDispatcher.removeEventListener(Event.ENTER_FRAME, removeMediatorLater);
			
			for each (var view:DisplayObject in _mediatorsMarkedForRemoval)
			{
				if (!view.stage)
				{
					removeMediatorByView(view);
				}
				delete _mediatorsMarkedForRemoval[view];
			}
			_hasMediatorsMarkedForRemoval = false;
		}
	}
}


class MappingConfig
{
	public var mediatorClass:Class;
	public var typedViewClass:Class;
	public var autoCreate:Boolean;
	public var autoRemove:Boolean;
	
	public function MappingConfig(m:Class = null, t:Class = null, ac:Boolean = false,
		ar:Boolean = false)
	{
		mediatorClass = m;
		typedViewClass = t;
		autoCreate = ac;
		autoRemove = ar;
	}
}
