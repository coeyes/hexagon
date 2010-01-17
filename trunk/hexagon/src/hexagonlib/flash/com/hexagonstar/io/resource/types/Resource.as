/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.io.resource.types{	import com.hexagonstar.debug.HLog;	import com.hexagonstar.event.ResourceEvent;	import com.hexagonstar.io.file.loaders.IFileTypeLoader;	import com.hexagonstar.io.file.types.IFile;	import flash.events.Event;	import flash.events.EventDispatcher;	import flash.utils.ByteArray;	/**	 * @eventType com.hexagonstar.framework.event.ResourceEvent.LOADED	 */	[Event(name="LOADED", type="com.hexagonstar.framework.event.ResourceEvent")]		/**	 * @eventType com.hexagonstar.framework.event.ResourceEvent.FAILED	 */	[Event(name="FAILED", type="com.hexagonstar.framework.event.ResourceEvent")]			/**	 * A resource contains data for a specific type of asset. This base class does not	 * define what that type is, so subclasses should be created and used for each	 * different type of asset.	 * <p>	 * The Resource class and any subclasses should never be instantiated directly.	 * Instead, use the ResourceManager class.	 * </p>	 * <p>	 * Usually, resources are created by loading data from a file, but this is not	 * necessarily a requirement.	 * </p>	 * 	 * @see ResourceManager	 * @author Sascha Balkau	 */	public class Resource extends EventDispatcher	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				/** @private */		protected var _path:String;		/** @private */		protected var _loader:IFileTypeLoader;		/** @private */		protected var _file:IFile;		/** @private */		protected var _referenceCount:int = 0;		/** @private */		protected var _loaded:Boolean = false;		/** @private */		protected var _failed:Boolean = false;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * initializes the resource with data from a byte array. This implementation loads		 * the data with a content loader. If that behavior is not needed (XML doesn't need		 * this, for example), this method can be overridden. Subclasses that do override		 * this method must call onLoadComplete when they have finished loading and		 * conditioning the byte array.		 * 		 * @param data The data to initialize the resource with.		 */		public function initialize(data:*):void		{			if (!(data is ByteArray))			{				throw new Error(toString() + " Default Resource can only process ByteArrays!");			}						// TODO			//var loader:Loader = new Loader();			//loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);			//loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onDownloadError);			//loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onDownloadSecurityError);			//loader.loadBytes(data);						// Keep reference so the Loader isn't GC'ed.			//_loader = loader;		}		        		/**		 * Increments the number of references to the resource. This should only ever be		 * called by the ResourceManager.		 */		public function incrementReferenceCount():void		{			_referenceCount++;		}						/**		 * Decrements the number of references to the resource. This should only ever be		 * called by the ResourceManager.		 */		public function decrementReferenceCount():void		{			_referenceCount--;		}						/**		 * Disposes Resource.		 */		public function dispose():void		{		}						/**		 * Returns a String Representation of Resource.		 * 		 * @return A String Representation of Resource.		 */		override public function toString():String		{			return "[Resource]";		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * The file path of the resource.		 */		public function get path():String		{			return _path;		}		public function set path(v:String):void		{			if (_path != null)			{				HLog.warn(toString()					+ " Can't change the path of a resource once it has been set.");				return;			}			_path = v;			_file.path = _path;		}				public function get file():IFile		{			return _file;		}						/**		 * Whether or not the resource has been loaded. This only marks whether loading has		 * been completed, not whether it succeeded. If this is true, <code>failed</code>		 * can be checked to see if loading was successful.		 * 		 * @see #failed		 */		public function get loaded():Boolean		{			return _loaded;		}						/**		 * Whether or not the resource failed to load. This is only valid after the resource		 * has loaded, so being false only verifies a successful load if <code>loaded</code>		 * is true.		 * 		 * @see #loaded		 */		public function get failed():Boolean		{			return _failed;		}						/**		 * The number of places this resource is currently referenced from. When this		 * reaches zero, the resource will be unloaded.		 */		public function get referenceCount():int		{			return _referenceCount;		}						/**		 * The IFileTypeLoader object that was used to load this resource. This is set to		 * null after onContentReady returns true.		 */		protected function get loader():IFileTypeLoader		{			return _loader;		}						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Called when loading and conditioning of the resource data is complete. This must		 * be called by, and only by, subclasses that override the initialize method.		 * 		 * @private		 * @param event This can be ignored by subclasses.		 */		protected function onLoadComplete(e:Event = null):void		{			try			{				if (onContentReady(e ? e.target.content : null))				{					_loaded = true;					//_urlLoader = null;					_loader = null;					dispatchEvent(new ResourceEvent(ResourceEvent.LOADED, this));					return;				}				else				{					onFailed("Got false from onContentReady - the data wasn't accepted.");					return;				}			}			catch (err:Error)			{				HLog.error(toString() + " Failed to load (" + err.message + ").");			}						onFailed("The resource type does not match the loaded content.");			return;		}						/**		 * This is called when the resource data has been fully loaded and conditioned.		 * Returning true from this method means the load was successful. False indicates		 * failure. Subclasses must implement this method.		 * 		 * @private		 * @param content The fully conditioned data for this resource.		 * @return True if content contains valid data, false otherwise.		 */        protected function onContentReady(content:*):Boolean        {        	/* Abstract method. */            return false;        }						/**		 * @private		 *///		private function onDownloadComplete(e:Event):void//		{//			var data:ByteArray = ((e.target) as URLLoader).data as ByteArray;//			initialize(data);//		}						/**		 * @private		 *///		private function onDownloadError(e:IOErrorEvent):void//		{//			onFailed(e.text);//		}						/**		 * @private		 *///		private function onDownloadSecurityError(e:SecurityErrorEvent):void//		{//			onFailed(e.text);//		}						/**		 * @private		 */		protected function onFailed(message:String):void		{			_loaded = true;			_failed = true;			HLog.error(toString() + " Resource <" + _path + "> failed to load with error: "				+ message);			dispatchEvent(new ResourceEvent(ResourceEvent.FAILED, this));			//_urlLoader = null;			_loader = null;		}						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////			}}