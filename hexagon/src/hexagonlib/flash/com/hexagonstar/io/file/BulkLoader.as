/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.io.file{	import com.hexagonstar.data.structures.queues.IQueue;	import com.hexagonstar.debug.HLog;	import com.hexagonstar.event.BulkProgressEvent;	import com.hexagonstar.event.FileIOEvent;	import com.hexagonstar.io.file.types.IFile;	import flash.events.EventDispatcher;	import flash.utils.Dictionary;	/**	 * Dispatched after all added files haven been processed, i.e. they either	 * have been loaded successfully, aborted or have been skipped due to an error.	 * 	 * @eventType com.hexagonstar.event.FileIOEvent	 */    [Event(name="fileIOComplete", type="com.hexagonstar.event.FileIOEvent")];    	/**	 * Dispatched after a file failed to load due to an IO error. This event is	 * only dispatched once all load retries for the file have been used up.	 * 	 * @eventType com.hexagonstar.event.FileIOEvent	 */    [Event(name="fileIOIOError", type="com.hexagonstar.event.FileIOEvent")];    	/**	 * Dispatched after a file failed to load due to a security error. This event is	 * only dispatched once all load retries for the file have been used up.	 * 	 * @eventType com.hexagonstar.event.FileIOEvent	 */    [Event(name="fileIOSecurityError", type="com.hexagonstar.event.FileIOEvent")];        	/**	 * BulkLoader Class	 * @author Sascha Balkau	 */	public class BulkLoader extends EventDispatcher implements IFileLoader	{		////////////////////////////////////////////////////////////////////////////////////////		// Constants                                                                          //		////////////////////////////////////////////////////////////////////////////////////////						////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Stores all files that are being loaded.		 * @private		 */		protected var _files:Dictionary;				/**		 * The maximum number of concurrent load connections.		 * @private		 */		protected var _maxConnections:int;				/**		 * @private		 */		protected var _loadRetries:int;				/**		 * The load connections that are currently in use.		 * @private		 */		protected var _usedConnections:Object;				/**		 * @private		 */		protected var _loading:Boolean;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new BulkLoader instance.		 * 		 * @param maxConnections The maximum allowed concurrent load connections.		 * @param loadRetries How many times a failed load should be retried.		 */		public function BulkLoader(maxConnections:int = 2, loadRetries:int = 0)		{			this.maxConnections = maxConnections;			this.loadRetries = loadRetries;			reset();		}						/**		 * reset		 */		public function reset():void		{			_files = new Dictionary(true);			_usedConnections = {};			_loading = false;		}						/**		 * Adds a file that should be loaded to the bulk loader.		 * 		 * @param file a File that should be loaded.		 * @param priority The load priority for the file. A file with a higher priority is		 *            being loaded before a file with a lower priority. Both negative and		 *            positive values are allowed; A file with a priority of 1 is loaded		 *            before a file with a priority of 0. Likewise a file with a priority of		 *            0 is loaded before a file with a priority of -1.		 * @param weight The weight of the file. Used for weighted load percentage stats.		 * @see com.hexagonstar.io.file.types.IFile		 * @see #fileQueue		 */		public function addFile(file:IFile, priority:int = 0, weight:int = 1):void		{			// TODO Add priority loading!						var identifier:String = getFileIdentifier(file);						if (_files[identifier] != null)			{				HLog.warn(toString() + " A file with the identifier <" + identifier					+ "> has already been added.");			}			else			{				var bf:BulkFile = new BulkFile(file, priority, weight);				addEventListenersTo(bf);				_files[identifier] = bf;			}		}						/**		 * Starts to load all files that were added to the bulk loader.		 * 		 * @see #addFile		 */		public function load():void		{			if (_loading) return;			if (fileCount < 1) return;			_loading = true;						loadNext();		}						/**		 * Aborts all loading process of the bulk loader.		 */		public function abort():void		{			// TODO		}						/**		 * Disposes BulkLoader.		 */		public function dispose():void		{		}						/**		 * Returns a String Representation of BulkLoader.		 * 		 * @return A String Representation of BulkLoader.		 */		override public function toString():String		{			return "[BulkLoader]";		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * A queue of files that should be loaded by the bulk loader. You can use this		 * property to set a queue or priority queue which contains files for the bulk		 * loader to load. If a priority queue is provided the bulk loader will		 * automatically use the priorities of the files in the queue as load priorities.		 * 		 * @see com.hexagonstar.data.structures.queues.Queue		 * @see com.hexagonstar.data.structures.queues.PriorityQueue		 * @see com.hexagonstar.io.file.types.IFile		 */		public function get fileQueue():IQueue		{			// TODO			return null;		}		public function set fileQueue(v:IQueue):void		{		}						/**		 * The maximum concurrent load connections that can be opened for loading files.		 * This property determines how many files can be loaded at the same time by the		 * BulkLoader.<br>		 * The lowest possible value for this is 1. Any lower value will automatically be		 * set to 1. The highest possible value is <code>int.MAX_VALUE</code>.		 */		public function get maxConnections():int		{			return _maxConnections;		}		public function set maxConnections(v:int):void		{			if (v < 1) v = 1;			else if (v > int.MAX_VALUE) v = int.MAX_VALUE;			_maxConnections = v;		}						/**		 * The number of retries that a file which failed to load due to an error will be		 * tried to load again. The default is 0 which means that any file is only tried to		 * load once and is not tried to be loaded again if it could not be loaded due to an		 * IO or security error.		 */		public function get loadRetries():int		{			return _loadRetries;		}		public function set loadRetries(v:int):void		{			if (v < 0) v = 0;			else if (v > int.MAX_VALUE) v = int.MAX_VALUE;			_loadRetries = v;		}						/**		 * @inheritDoc		 */		public function get loading():Boolean		{			return _loading;		}						/**		 * Returns the amount of files that were added to the BulkLoader.		 */		public function get fileCount():int		{			var v:int = 0;			for each (var bf:BulkFile in _files)			{				v++;				continue;				bf = bf; /* Never executed! Only here to prevent unused var editor warnings! */			}			return v;		}						/**		 * Returns how many connections are currently in use.		 * @private		 */		protected function get currentlyUsedConnections():int		{			var v:int = 0;			for (var c:String in _usedConnections)			{				v++;				continue;				c = c; /* Never executed! Only here to prevent unused var editor warnings! */			}			return v;		}						/**		 * Checks if there are any bulkfiles left that need to be loaded (false) or if all		 * bulkfiles have been processed (true). Being processed does not necessarily mean		 * that a file has been loaded sucessfully. It could also indicate that a file was		 * tried to be loaded but failed due to an error or that it has been aborted.		 * 		 * @return true if all bulkfiles have been processed or false if there are any		 *         bulkfiles left that need to be loaded.		 */		protected function get allFilesProcessed():Boolean		{			for each (var bf:BulkFile in _files)			{				if (bf.status == BulkFile.STATUS_INITIALIZED					|| bf.status == BulkFile.STATUS_PROGRESSING)				{					return false;				}			}			return true;		}						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @private		 */		protected function onFileOpen(e:FileIOEvent):void		{		}						/**		 * @private		 */		protected function onFileProgress(e:FileIOEvent):void		{			dispatchEvent(createBulkProgressEvent());		}						/**		 * @private		 */		protected function onFileAbort(e:FileIOEvent):void		{			var bf:BulkFile = e.bulkFile;			removeConnectionFrom(bf);			removeEventListenersFrom(bf);						HLog.warn(toString() + " aborted: " + bf.toString());						next();			e.stopPropagation();		}						/**		 * @private		 */		protected function onFileError(e:FileIOEvent):void		{			var bf:BulkFile = e.bulkFile;						removeConnectionFrom(bf);						/* We dispatch an error event here only after all load retries are used up! */			if (bf.retryCount >= _loadRetries)			{				removeEventListenersFrom(bf);				dispatchEvent(e);			}						HLog.warn(toString() + " error loading: " + bf.toString()				+ " (" + (_loadRetries - bf.retryCount) + " retries left). Error was: "				+ e.text);						next();			e.stopPropagation();		}						/**		 * @private		 */		protected function onFileComplete(e:FileIOEvent):void		{			var bf:BulkFile = e.bulkFile;			removeConnectionFrom(bf);			removeEventListenersFrom(bf);			dispatchEvent(e);						HLog.debug(toString() + " completed: " + bf.toString());			HLog.debug(toString() + " connections in use: " + currentlyUsedConnections);						next();			e.stopPropagation();		}						/**		 * @private		 */		protected function onAllFilesComplete():void		{			HLog.debug(toString() + " All files completed!");			_loading = false;			dispatchEvent(new FileIOEvent(FileIOEvent.COMPLETE));		}						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Returns an identifier string for the specified file.		 * @private		 */		protected function getFileIdentifier(file:IFile):String		{			return file.path;		}						/**		 * createBulkProgressEvent		 * @private		 */		protected function createBulkProgressEvent():BulkProgressEvent		{			// TODO totalbytesloaded doesn't seem to be working yet!						var weightPercent:Number = 0;			var weightLoaded:Number = 0;			var weightTotal:int = 0;			var filesStarted:int = 0;			var filesLoaded:int = 0;			var filesTotal:int = 0;			var bytesLoaded:int = 0;			var bytesTotal:int = Number.POSITIVE_INFINITY;			var bytesTotalCurrent:int = 0;						for each (var f:BulkFile in _files)			{				filesTotal++;				weightTotal += f.weight;								if (f.status == BulkFile.STATUS_PROGRESSING					|| f.status == BulkFile.STATUS_LOADED					|| f.status == BulkFile.STATUS_ABORTED)				{					bytesLoaded += f.bytesLoaded;					bytesTotalCurrent += f.bytesTotal;										if (f.bytesTotal > 0)					{						weightLoaded += (f.bytesLoaded / f.bytesTotal) * f.weight;					}										if (f.status == BulkFile.STATUS_LOADED)					{						filesLoaded++;					}										filesStarted++;				}			}						/* only set bytes total if all items have begun loading */			if (filesStarted == filesTotal)			{				bytesTotal = bytesTotalCurrent;			}						weightPercent = weightLoaded / weightTotal;			if (weightTotal == 0) weightPercent = 0;						return new BulkProgressEvent(FileIOEvent.PROGRESS, bytesLoaded, bytesTotal,				bytesTotalCurrent, filesLoaded, filesTotal, weightPercent);		}				/**		 * Continues progress after a file has been completed, aborted or failed.		 * @private		 */		protected function next():void		{			loadNext();			if (allFilesProcessed)			{				onAllFilesComplete();			}		}						/**		 * Tries to load the next available bulkfile, if there is any left.		 * 		 * @private		 * @return true if there is a next bulkfile to load, otherwise false.		 */		protected function loadNext():Boolean		{			var hasNext:Boolean = false;			var next:BulkFile = getNextBulkFile();						if (next)			{				HLog.debug(toString() + " loading " + next.toString() + " ...");				hasNext = true;				_usedConnections[getFileIdentifier(next.file)] = true;				next.load();								/* If we got any more connections available, go on and load the next item. */				if (getNextBulkFile())				{					loadNext();				}			}						return hasNext;		}						/**		 * Returns the bulkfile that is ready to be loaded next.		 * @private		 */		protected function getNextBulkFile():BulkFile		{			for each (var bf:BulkFile in _files)			{				if (!bf.loading					&& bf.status != BulkFile.STATUS_LOADED					&& bf.status != BulkFile.STATUS_ABORTED					&& isConnectionAvailable())				{					/* No error status so just load the file. */					if (bf.status != BulkFile.STATUS_ERROR)					{						return bf;					}					else					{						/* There was an error before so check if we still have retries left. */						if (bf.retryCount < _loadRetries)						{							bf.retryCount++;							return bf;						}					}				}			}			return null;		}						/**		 * Checks if a connection is available within the limit of maxConnections.		 * @private		 */		protected function isConnectionAvailable():Boolean		{			return currentlyUsedConnections < _maxConnections;		}						/**		 * Adds necessary event listeners to the specified bulkfile.		 * @private		 */		protected function addEventListenersTo(bf:BulkFile):void		{			bf.addEventListener(FileIOEvent.OPEN, onFileOpen);			bf.addEventListener(FileIOEvent.PROGRESS, onFileProgress);			bf.addEventListener(FileIOEvent.ABORT, onFileAbort);			bf.addEventListener(FileIOEvent.IO_ERROR, onFileError);			bf.addEventListener(FileIOEvent.SECURITY_ERROR, onFileError);			bf.addEventListener(FileIOEvent.FILE_COMPLETE, onFileComplete);		}						/**		 * Removes any event listeners that were added to the specified bulkfile.		 * @private		 */		protected function removeEventListenersFrom(bf:BulkFile):void		{			bf.removeEventListener(FileIOEvent.OPEN, onFileOpen);			bf.removeEventListener(FileIOEvent.PROGRESS, onFileProgress);			bf.removeEventListener(FileIOEvent.ABORT, onFileAbort);			bf.removeEventListener(FileIOEvent.IO_ERROR, onFileError);			bf.removeEventListener(FileIOEvent.SECURITY_ERROR, onFileError);			bf.removeEventListener(FileIOEvent.FILE_COMPLETE, onFileComplete);		}						/**		 * Removes the open connection that was used to load the specified bulkfile		 * and by that makes it free for any other files to load.		 * @private		 */		protected function removeConnectionFrom(bf:BulkFile):void		{			var id:String = getFileIdentifier(bf.file);			for (var i:String in _usedConnections)			{				if (i == id)				{					_usedConnections[i] = false;					delete _usedConnections[i];					return;				}			}		}	}}