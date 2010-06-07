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
package com.hexagonstar.cyborg.injectors.points
{
	import com.hexagonstar.cyborg.injectors.InjectionConfig;
	import com.hexagonstar.cyborg.injectors.Injector;
	import com.hexagonstar.cyborg.injectors.InjectorError;

	import flash.utils.getQualifiedClassName;

	
	/**
	 * MethodInjectionPoint
	 */
	public class MethodInjectionPoint extends InjectionPoint
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/** @private */
		protected var _methodName:String;
		/** @private */
		protected var _injectionConfigs:Vector.<InjectionConfig>;
		/** @private */
		protected var _requiredParameters:int = 0;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Constructor
		 */
		public function MethodInjectionPoint(node:XML, injector:Injector)
		{
			super(node, injector);
		}
		
		
		override public function applyInjection(target:Object, injector:Injector):Object
		{
			var parameters:Array = gatherParameterValues(target, injector);
			var method:Function = target[_methodName];
			method.apply(target, parameters);
			return target;
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		override protected function initializeInjection(node:XML, injector:Injector):void
		{
			var nameArgs:XMLList = node.arg.(@key == "name");
			var methodNode:XML = node.parent();
			_methodName = XML(methodNode.@name).toString();
			gatherParameters(methodNode, nameArgs, injector);
		}
		
		
		/**
		 * @private
		 */
		protected function gatherParameters(methodNode:XML, nameArgs:XMLList,
			injector:Injector):void
		{
			_injectionConfigs = new Vector.<InjectionConfig>();
			var i:int = 0;
			
			for each (var parameter:XML in methodNode.parameter)
			{
				var injectionName:String = "";
				
				if (nameArgs[i])
				{
					injectionName = XML(nameArgs[i].@value).toString();
				}
				
				var parameterTypeName:String = XML(parameter.@type).toString();
				var parameterType:Class;
				
				if (parameterTypeName == "*")
				{
					if (XML(parameter.@optional).toString() == "false")
					{
						// TODO Find a way to trace name of affected class here!
						throw new Error("Error in method definition of injectee. Required "
							+ "parameters can't have type '*'.");
					}
					else
					{
						parameterTypeName = null;
					}
				}
				else
				{
					parameterType =
						Class(injector.getApplicationDomain().getDefinition(parameterTypeName));
				}
				
				_injectionConfigs.push(injector.getMapping(parameterType, injectionName));
				
				if (XML(parameter.@optional).toString() == "false")
				{
					_requiredParameters++;
				}
				i++;
			}
		}
		
		
		/**
		 * @private
		 */
		protected function gatherParameterValues(target:Object, injector:Injector):Array
		{
			var parameters:Array = [];
			var length:int = _injectionConfigs.length;
			
			for (var i:int = 0; i < length; i++)
			{
				var config:InjectionConfig = _injectionConfigs[i];
				var injection:Object = config.getResponse(injector);
				
				if (injection == null)
				{
					if (i >= _requiredParameters) break;
					
					throw(new InjectorError(
						"Injector is missing a rule to handle injection into target " + target
						+ ". Target dependency: " + getQualifiedClassName(config.request)
						+ ", method: " + _methodName + ", parameter: " + (i + 1)));
				}
				
				parameters[i] = injection;
			}
			return parameters;
		}
	}
}
