/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.io.resource{	import com.hexagonstar.core.BasicClass;	import com.hexagonstar.debug.HLog;	import com.hexagonstar.io.resource.provider.EmbeddedResourceProvider;	import com.hexagonstar.io.resource.types.Resource;	import flash.utils.describeType;	import flash.utils.getDefinitionByName;		/**	 * The resource bundle handles automatic loading and registering of embedded	 * resources. To use, create a descendant class and embed resources as public	 * variables, then instantiate your new class. ResourceBundle will handle loading	 * all of those resources into the ResourceManager.	 * 	 * @author Sascha Balkau	 */	public class ResourceBundle extends BasicClass	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * ExtensionTypes associates filename extensions with the resource type that they		 * are to be loaded as. Each entry should be in the form of		 * 'xml:"com.hexagonstar.io.resource.types.XMLResource"' Where xml is the		 * filename extension that should be associated with this type, and where		 * "com.hexagonstar.io.resource.types.XMLResource" is the fully qualified		 * resource class name string, and png is the (lower-case) extension. This array can		 * be extended at runtime, such as: ResourceBundle.ExtensionTypes.mycustomext =		 * "com.mydomain.customresource"		 */		public static var extensionTypes:Object =		{			png: "com.hexagonstar.io.resource.types.ImageResource",			jpg: "com.hexagonstar.io.resource.types.ImageResource",			gif: "com.hexagonstar.io.resource.types.ImageResource",			bmp: "com.hexagonstar.io.resource.types.ImageResource",			xml: "com.hexagonstar.io.resource.types.XMLResource",			swf: "com.hexagonstar.io.resource.types.SWFResource",			mp3: "com.hexagonstar.io.resource.types.MP3Resource"		};						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new ResourceBundle instance.		 */		public function ResourceBundle()		{			process();		}						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * This is where all of the magic happens. This is where the ResourceBundle loops		 * through all of its public properties and registers any embedded resources with		 * the ResourceManager.		 * 		 * @private		 */		protected function process():void		{			/* Get information about our members (which will be embedded resources) */			var dsc:XML = describeType(this);			var res:Class;			var src:String;			var mimeType:String;			var typeName:String;			var isEmbedded:Boolean;						/* Force linkage. */			//new DataResource();			//new ImageResource();			//new XMLResource();			//new MP3Resource();						/* Loop through each public variable in this class */			for each (var v:XML in dsc.variable)			{				/* Store a reference to the object */				res = this[v.@name];								/* Assume that it is not properly embedded,				 * so that we can throw an error if needed. */				src = "";				mimeType = "";				typeName = "";				isEmbedded = false;								/* Loop through each metadata tag in the child variable */				for each (var meta:XML in v.children())				{					/* If we've got an embedded metadata */					if (meta.@name == "Embed") 					{						/* If we've got a valid embed tag, then the resource embedded correctly. */						isEmbedded = true;												/* Extract the source and MIME information from the embed tag. */						for each (var arg:XML in meta.children())						{							if (arg.@key == "source")							{								src = arg.@value;							} 							else if (arg.@key == "mimeType")							{								mimeType = arg.@value;							}						}					}					else if (meta.@name == "ResourceType")					{						for each (arg in meta.children())						{							if (arg.@key == "className")							{								typeName = arg.@value;							}						}					}				}								/* Now that we've processed all of the metadata, it's time to see if				 * it embedded properly. */								/* Sanity check */				if (!isEmbedded || src == "" || res == null)				{					HLog.error(toString() + " A resource in the resource bundle with the name <"						+ v.@name + "> has failed to embed properly. Please ensure that you have"						+ " the compiler option '--keep-as3-metadata+=TypeHint,EditorData,Embed'"						+ " set properly. Additionally, please check that the [Embed] metadata"						+ " syntax is correct.");					continue;				}								/* If a metadata tag isn't specified with the resource type name explicitly, */				if (typeName == "")				{					/* Then look up the class name by extension (this is the default behavior). */					/* Get the extension of the source filename */					var a:Array = src.split(".");					var ext:String = (a[a.length - 1] as String).toLowerCase();										/* If the extension type is recognized or not... */					if (!extensionTypes.hasOwnProperty(ext))					{						HLog.warn(toString() + " No resource type specified for extension <."							+ ext + ">. In the extensionTypes parameter, expected to see"							+ " something like: ResourceBundle.extensionTypes.mycustomext"							+ " = \"com.mydomain.customresource\" where mycustomext is the"							+ " (lower-case) extension, and \"com.mydomain.customresource\""							+ " is a string of the fully qualified resource class name."							+ " Defaulting to generic DataResource.");												/* Default to a DataResource if no other name is specified. */						// TODO Maybe we should change the default resource to something else.						typeName = "com.hexagonstar.framework.io.resource.DataResource";					}					else					{						/* And if the assigned value is a valid resource type, then take						 * it from the array. */						typeName = extensionTypes[ext] as String;					}				}								/* Now that we (hopefully) have our resource type name,				 * we can try to instantiate it. */				var type:Class;								try				{					/* Look up the class! */					type = getDefinitionByName(typeName) as Class;				}				catch (err:Error)				{					/* Failed, so make sure it's null. */					type = null;				}								if (!type)				{					HLog.error(toString() + " The resource type <" + typeName						+ "> specified for the embedded asset <" + src						+ "> could not be found. Please ensure that the path name is correct,"						+ " and that the class is explicity referenced somewhere in the project,"						+ " so that it is available at runtime. Did you properly reference this"						+ " class in your References.as/References.mxml?");					continue;				}								/* The resource type is a class -- let's make sure it's a Resource */				var testResource:* = new type();				if (!(testResource is Resource))				{					HLog.error(toString() + " The resource type <" + typeName						+ "> specified for the embedded asset <" + src						+ "> is not a descendant of Resource. Please ensure that the resource"						+ " class extends properly from 'Resource', and is defined correctly.");					continue;				}								/* Everything so far is hunky-dory -- go ahead and register the embedded				 * resource with the embedded resource provider! */				EmbeddedResourceProvider.instance.registerResource(src, type, new res());			}		}	}}