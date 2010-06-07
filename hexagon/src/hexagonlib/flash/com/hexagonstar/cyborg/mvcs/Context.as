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
package com.hexagonstar.cyborg.mvcs
{
	import com.hexagonstar.cyborg.base.CommandMap;
	import com.hexagonstar.cyborg.base.ContextBase;
	import com.hexagonstar.cyborg.base.ContextEvent;
	import com.hexagonstar.cyborg.base.EventMap;
	import com.hexagonstar.cyborg.base.MediatorMap;
	import com.hexagonstar.cyborg.base.ViewMap;
	import com.hexagonstar.cyborg.core.ICommandMap;
	import com.hexagonstar.cyborg.core.IContext;
	import com.hexagonstar.cyborg.core.IEventMap;
	import com.hexagonstar.cyborg.core.IInjector;
	import com.hexagonstar.cyborg.core.IMediatorMap;
	import com.hexagonstar.cyborg.core.IReflector;
	import com.hexagonstar.cyborg.core.IViewMap;
	import com.hexagonstar.cyborg.injectors.SwiftInjector;
	import com.hexagonstar.cyborg.injectors.SwiftReflector;

	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.IEventDispatcher;

	
	/**
	 * Abstract MVCS <code>IContext</code> implementation
	 */
	public class Context extends ContextBase implements IContext
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/** @private **/
		protected var _contextView:DisplayObjectContainer;
		/** @private **/
		protected var _autoStartup:Boolean;
		/** @private **/
		protected var _injector:IInjector;
		/** @private **/
		protected var _reflector:IReflector;
		/** @private **/
		protected var _commandMap:ICommandMap;
		/** @private **/
		protected var _mediatorMap:IMediatorMap;
		/** @private **/
		protected var _viewMap:IViewMap;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Abstract Context Implementation.
		 * <p>
		 * Extend this class to create a Framework or Application context.
		 * </p>
		 * 
		 * @param contextView The root view node of the context. The context will listen for
		 *            ADDED_TO_STAGE events on this node.
		 * @param autoStartup Should this context automatically invoke it's
		 *            <code>startup</code> method when it's <code>contextView</code> arrives
		 *            on Stage?
		 */
		public function Context(contextView:DisplayObjectContainer = null,
			autoStartup:Boolean = true)
		{
			super();
			
			_contextView = contextView;
			_autoStartup = autoStartup;
			
			mapInjections();
			checkAutoStartup();
		}
		
		
		/**
		 * The Startup Hook.
		 *
		 * <p>Override this in your Application context.</p>
		 */
		public function startup():void
		{
			dispatchEvent(new ContextEvent(ContextEvent.STARTUP_COMPLETE));
		}
		
		
		/**
		 * The Shutdown Hook.
		 *
		 * <p>Override this in your Application context.</p>
		 */
		public function shutdown():void
		{
			dispatchEvent(new ContextEvent(ContextEvent.SHUTDOWN_COMPLETE));
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * The <code>DisplayObjectContainer</code> that scopes this <code>IContext</code>.
		 */
		public function get contextView():DisplayObjectContainer
		{
			return _contextView;
		}
		
		/**
		 * @private
		 */
		public function set contextView(v:DisplayObjectContainer):void
		{
			if (_contextView != v)
			{
				_contextView = v;
				mediatorMap.contextView = v;
				viewMap.contextView = v;
				mapInjections();
				checkAutoStartup();
			}
		}
		
		
		/**
		 * The <code>IInjector</code> for this <code>IContext</code>.
		 */
		protected function get injector():IInjector
		{
			return _injector || (_injector = new SwiftInjector());
		}
		
		/**
		 * @private
		 */
		protected function set injector(v:IInjector):void
		{
			_injector = v;
		}
		
		
		/**
		 * The <code>IReflector</code> for this <code>IContext</code>.
		 */
		protected function get reflector():IReflector
		{
			return _reflector || (_reflector = new SwiftReflector());
		}
		
		/**
		 * @private
		 */
		protected function set reflector(v:IReflector):void
		{
			_reflector = v;
		}
		
		
		/**
		 * The <code>ICommandMap</code> for this <code>IContext</code>.
		 */
		protected function get commandMap():ICommandMap
		{
			return _commandMap || (_commandMap = new CommandMap(eventDispatcher,
				injector.createChild(), reflector));
		}
		
		/**
		 * @private
		 */
		protected function set commandMap(v:ICommandMap):void
		{
			_commandMap = v;
		}
		
		
		/**
		 * The <code>IMediatorMap</code> for this <code>IContext</code>.
		 */
		protected function get mediatorMap():IMediatorMap
		{
			return _mediatorMap || (_mediatorMap = new MediatorMap(contextView,
				injector.createChild(), reflector));
		}
		
		/**
		 * @private
		 */
		protected function set mediatorMap(v:IMediatorMap):void
		{
			_mediatorMap = v;
		}
		
		
		/**
		 * The <code>IViewMap</code> for this <code>IContext</code>.
		 */
		protected function get viewMap():IViewMap
		{
			return _viewMap || (_viewMap = new ViewMap(contextView, injector));
		}
		
		/**
		 * @private
		 */
		protected function set viewMap(v:IViewMap):void
		{
			_viewMap = v;
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Injection Mapping Hook.
		 * <p>Override this in your Framework context to change the default configuration.</p>
		 * <p>Beware of collisions in your container.</p>
		 */
		protected function mapInjections():void
		{
			injector.mapValue(IReflector, reflector);
			injector.mapValue(IInjector, injector);
			injector.mapValue(IEventDispatcher, eventDispatcher);
			injector.mapValue(DisplayObjectContainer, contextView);
			injector.mapValue(ICommandMap, commandMap);
			injector.mapValue(IMediatorMap, mediatorMap);
			injector.mapValue(IViewMap, viewMap);
			injector.mapClass(IEventMap, EventMap);
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Internal                                                                           //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		protected function checkAutoStartup():void
		{
			if (_autoStartup && contextView)
			{
				contextView.stage
					? startup()
					: contextView.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage,
					  false, 0, true);
			}
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Event Handlers                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		protected function onAddedToStage(e:Event):void
		{
			contextView.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			startup();
		}
	}
}
