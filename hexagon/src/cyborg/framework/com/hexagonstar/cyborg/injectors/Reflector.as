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
	import flash.system.ApplicationDomain;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	
	/**
	 * Reflector
	 */
	public class Reflector
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Constructor
		 */
		public function Reflector()
		{
		}
		
		
		public function classExtendsOrImplements(classOrClassName:Object,
			superclass:Class, application:ApplicationDomain = null):Boolean
		{
			var actualClass:Class;
			if (classOrClassName is Class)
			{
				actualClass = Class(classOrClassName);
			}
            else if (classOrClassName is String)
			{
				try
				{
					actualClass = Class(getDefinitionByName(classOrClassName as String));
				}
                catch (err:Error)
				{
					throw new Error("The class name " + classOrClassName
						+ " is not valid because of " + err + "\n" + err.getStackTrace());
				}
			}
			
			if (!actualClass)
			{
				throw new Error("The parameter classOrClassName must be a valid Class "
					+ "instance or fully qualified class name.");
			}
			
			if (actualClass == superclass) return true;
			
			var factoryDescription:XML = describeType(actualClass).factory[0];
			
			return (factoryDescription.children().(name() == "implementsInterface"
				|| name() == "extendsClass").(attribute("type")
				== getQualifiedClassName(superclass)).length() > 0);
		}
		
		
		public function getClass(value:*, applicationDomain:ApplicationDomain = null):Class
		{
			if (value is Class) return value;
			return getConstructor(value);
		}
		
		
		public function getFQCN(value:*, replaceColons:Boolean = false):String
		{
			var fqcn:String;
			if (value is String)
			{
				fqcn = value;
				
				/* Add colons if missing and desired. */
				if (!replaceColons && fqcn.indexOf("::") == -1)
				{
					var lastDotIndex:int = fqcn.lastIndexOf(".");
					if (lastDotIndex == -1) return fqcn;
					return fqcn.substring(0, lastDotIndex) + "::"
						+ fqcn.substring(lastDotIndex + 1);
				}
			}
			else
			{
				fqcn = getQualifiedClassName(value);
			}
			
			return replaceColons ? fqcn.replace("::", ".") : fqcn;
		}
	}
}
