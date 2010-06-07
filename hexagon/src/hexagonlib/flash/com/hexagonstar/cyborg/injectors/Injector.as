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
	import com.hexagonstar.cyborg.injectors.points.ConstructorInjectionPoint;
	import com.hexagonstar.cyborg.injectors.points.InjectionPoint;
	import com.hexagonstar.cyborg.injectors.points.MethodInjectionPoint;
	import com.hexagonstar.cyborg.injectors.points.NoParamsConstructorInjectionPoint;
	import com.hexagonstar.cyborg.injectors.points.PostConstructInjectionPoint;
	import com.hexagonstar.cyborg.injectors.points.PropertyInjectionPoint;
	import com.hexagonstar.cyborg.injectors.results.InjectClassResult;
	import com.hexagonstar.cyborg.injectors.results.InjectOtherRuleResult;
	import com.hexagonstar.cyborg.injectors.results.InjectSingletonResult;
	import com.hexagonstar.cyborg.injectors.results.InjectValueResult;

	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	
	/**
	 * Injector
	 */
	public class Injector
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/** @private */
		private var _parentInjector:Injector;
		/** @private */
		private var _applicationDomain:ApplicationDomain;
		/** @private */
		private var _mappings:Dictionary;
		/** @private */
		private var _injectionPointLists:Dictionary;
		/** @private */
		private var _constructorInjectionPoints:Dictionary;
		/** @private */
		private var _attendedToInjectees:Dictionary;
		/** @private */
		private var _xmlMetaData:XML;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Constructor
		 */
		public function Injector(xmlConfig:XML = null)
		{
			_mappings = new Dictionary();
			_injectionPointLists = new Dictionary();
			_constructorInjectionPoints = new Dictionary();
			_attendedToInjectees = new Dictionary(true);
			_xmlMetaData = xmlConfig;
		}
		
		
		public function mapValue(whenAskedFor:Class, useValue:Object, named:String = ""):*
		{
			var config:InjectionConfig = getMapping(whenAskedFor, named);
			config.setResult(new InjectValueResult(useValue));
			return config;
		}
		
		
		public function mapClass(whenAskedFor:Class, instantiateClass:Class,
			named:String = ""):*
		{
			var config:InjectionConfig = getMapping(whenAskedFor, named);
			config.setResult(new InjectClassResult(instantiateClass));
			return config;
		}
		
		
		public function mapSingleton(whenAskedFor:Class, named:String = ""):*
		{
			return mapSingletonOf(whenAskedFor, whenAskedFor, named);
		}
		
		
		public function mapSingletonOf(whenAskedFor:Class, useSingletonOf:Class,
			named:String = ""):*
		{
			var config:InjectionConfig = getMapping(whenAskedFor, named);
			config.setResult(new InjectSingletonResult(useSingletonOf));
			return config;
		}
		
		
		public function mapRule(whenAskedFor:Class, useRule:*, named:String = ""):*
		{
			var config:InjectionConfig = getMapping(whenAskedFor, named);
			config.setResult(new InjectOtherRuleResult(useRule));
			return useRule;
		}
		
		
		public function getMapping(whenAskedFor:Class, named:String = ""):InjectionConfig
		{
			var requestName:String = getQualifiedClassName(whenAskedFor);
			var config:InjectionConfig = _mappings[requestName + "#" + named];
			if (!config)
			{
				config = _mappings[requestName + "#" + named]
					= new InjectionConfig(whenAskedFor, named);
			}
			return config;
		}
		
		
		public function injectInto(target:Object):void
		{
			if (_attendedToInjectees[target]) return;
			_attendedToInjectees[target] = true;
			
			/* get injection points or cache them if this target's
			 * class wasn't encountered before. */
			var injectionPoints:Array;
			var ctor:Class = getConstructor(target);
			injectionPoints = _injectionPointLists[ctor] || getInjectionPoints(ctor);
			var length:int = injectionPoints.length;
			
			for (var i:int = 0;i < length; i++)
			{
				var injectionPoint:InjectionPoint = injectionPoints[i];
				injectionPoint.applyInjection(target, this);
			}
		}
		
		
		public function instantiate(clazz:Class):*
		{
			var injectionPoint:InjectionPoint = _constructorInjectionPoints[clazz];
			if (!injectionPoint)
			{
				getInjectionPoints(clazz);
				injectionPoint = _constructorInjectionPoints[clazz];
			}
			var instance:* = injectionPoint.applyInjection(clazz, this);
			injectInto(instance);
			return instance;
		}
		
		
		public function unmap(clazz:Class, named:String = ""):void
		{
			var mapping:InjectionConfig = getConfigurationForRequest(clazz, named);
			if (!mapping)
			{
				throw new InjectorError("Error while removing an injector mapping: "
					+ "No mapping defined for class " + getQualifiedClassName(clazz)
					+ ", named '" + named + "'.");
			}
			mapping.setResult(null);
		}
		
		
		public function hasMapping(clazz:Class, named:String = ""):Boolean
		{
			var mapping:InjectionConfig = getConfigurationForRequest(clazz, named);
			if (!mapping) return false;
			return mapping.hasResponse(this);
		}
		
		
		public function getInstance(clazz:Class, named:String = ""):*
		{
			var mapping:InjectionConfig = getConfigurationForRequest(clazz, named);
			if (!mapping || !mapping.hasResponse(this))
			{
				throw new InjectorError("Error while getting mapping response: "
					+ "No mapping defined for class " + getQualifiedClassName(clazz)
					+ ", named '" + named + "'.");
			}
			return mapping.getResponse(this);
		}
		
		
		public function createChildInjector(applicationDomain:ApplicationDomain
			= null):Injector
		{
			var injector:Injector = new Injector();
			injector.setApplicationDomain(applicationDomain);
			injector.setParentInjector(this);
			return injector;
		}
		
		
		public function setApplicationDomain(applicationDomain:ApplicationDomain):void
		{
			_applicationDomain = applicationDomain;
		}
		
		
		public function getApplicationDomain():ApplicationDomain
		{
			return _applicationDomain ? _applicationDomain : ApplicationDomain.currentDomain;
		}
		
		
		public function setParentInjector(parentInjector:Injector):void
		{
			/* restore own map of worked injectees if parent injector is removed */
			if (_parentInjector && !parentInjector)
			{
				_attendedToInjectees = new Dictionary(true);
			}
			_parentInjector = parentInjector;
			
			/* use parent's map of worked injectees */
			if (parentInjector)
			{
				_attendedToInjectees = parentInjector.attendedToInjectees;
			}
		}
		
		
		public function getParentInjector():Injector
		{
			return _parentInjector;
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Internal                                                                           //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		internal function getAncestorMapping(whenAskedFor:Class,
			named:String = null):InjectionConfig
		{
			var parent:Injector = _parentInjector;
			while (parent)
			{
				var parentConfig:InjectionConfig
					= parent.getConfigurationForRequest(whenAskedFor, named, false);
				if (parentConfig && parentConfig.hasOwnResponse()) return parentConfig;
				parent = parent.getParentInjector();
			}
			return null;
		}
		
		
		/**
		 * @private
		 */
		internal function get attendedToInjectees():Dictionary
		{
			return _attendedToInjectees;
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		private function getInjectionPoints(clazz:Class):Array
		{
			var description:XML = describeType(clazz);
			var injectionPoints:Array = [];
			_injectionPointLists[clazz] = injectionPoints;
			_injectionPointLists[String(description.@name)] = injectionPoints;
			var node:XML;
			
			/* This is where we have to wire in the XML ... */
			if(_xmlMetaData)
			{
				createInjectionPointsFromConfigXML(description);
				addParentInjectionPoints(description, injectionPoints);
			}
			
			var injectionPoint:InjectionPoint;
			
			/* Get constructor injections */
			node = description.factory.constructor[0];
			if (node)
			{
				_constructorInjectionPoints[clazz]
					= new ConstructorInjectionPoint(node, clazz, this);
			}
			else
			{
				_constructorInjectionPoints[clazz] = new NoParamsConstructorInjectionPoint();
			}
			
			/* Get injection points for variables */
			for each (node in description.factory.*.(name() == "variable"
				|| name() == "accessor").metadata.(@name == "Inject"))
			{
				injectionPoint = new PropertyInjectionPoint(node, this);
				injectionPoints.push(injectionPoint);
			}
			
			/* Get injection points for methods */
			for each (node in description.factory.method.metadata.(@name == "Inject"))
			{
				injectionPoint = new MethodInjectionPoint(node, this);
				injectionPoints.push(injectionPoint);
			}
			
			/* Get post construct methods */
			var postConstructMethodPoints:Array = [];
			for each (node in description.factory.method.metadata.(@name == "PostConstruct"))
			{
				injectionPoint = new PostConstructInjectionPoint(node, this);
				postConstructMethodPoints.push(injectionPoint);
			}
			if (postConstructMethodPoints.length > 0)
			{
				postConstructMethodPoints.sortOn("order", Array.NUMERIC);
				injectionPoints.push.apply(injectionPoints, postConstructMethodPoints);
			}
			
			return injectionPoints;
		}
		
		
		/**
		 * @private
		 */
		private function getConfigurationForRequest(clazz:Class, named:String,
			traverseAncestors:Boolean = true):InjectionConfig
		{
			var requestName:String = getQualifiedClassName(clazz);
			var config:InjectionConfig = _mappings[requestName + "#" + named];
			if (!config && traverseAncestors && _parentInjector
				&& _parentInjector.hasMapping(clazz, named))
			{
				config = getAncestorMapping(clazz, named);
			}
			return config;
		}
		
		
		/**
		 * @private
		 */
		private function createInjectionPointsFromConfigXML(description:XML):void
		{
			var node:XML;
			
			/* first, clear out all "Inject" metadata, we want a clean slate to have the result 
			 * work the same in the Flash IDE and MXMLC */
			for each (node in description..metadata.(@name == "Inject"
				|| @name == "PostConstruct"))
			{
				delete node.parent()["metadata"].(@name == "Inject" || @name == "PostConstruct")[0];
			}
			
			/* now, we create the new injection points based on the given xml file */
			var className:String = description.factory.@type;
			for each (node in _xmlMetaData.type.(@name == className).children())
			{
				var metaNode:XML = <metadata/>;
				if (node.name() == "postconstruct")
				{
					metaNode.@name = "PostConstruct";
					if (XML(node.@order).length())
					{
						metaNode.appendChild(<arg key="order" value={node.@order}/>);
					}
				}
				else
				{
					metaNode.@name = "Inject";
					if (XML(node.@injectionname).length())
					{
						metaNode.appendChild(<arg key="name" value={node.@injectionname}/>);
					}
					for each (var arg:XML in node.arg)
					{
						metaNode.appendChild(<arg key="name" value={arg.@injectionname}/>);
					}
				}
				
				var typeNode:XML;
				if (node.name() == "constructor")
				{
					typeNode = description.factory[0];
				}
				else
				{
					typeNode = description.factory.*.(attribute("name") == node.@name)[0];
					if (!typeNode)
					{
						throw new InjectorError("Error in XML configuration: Class '"
							+ className + "' doesn't contain the instance member '" + node.@name
							+ "'.");
					}
				}
				typeNode.appendChild(metaNode);
			}
		}
		
		
		/**
		 * @private
		 */
		private function addParentInjectionPoints(description:XML,
			injectionPoints:Array):void
		{
			var parentClassName:String = description.factory.extendsClass.@type[0];
			if (!parentClassName) return;
			var parentInjectionPoints:Array = _injectionPointLists[parentClassName]
				|| getInjectionPoints(Class(getDefinitionByName(parentClassName)));
			injectionPoints.push.apply(injectionPoints, parentInjectionPoints);
		}
	}
}
