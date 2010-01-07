/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.io.file{	import com.hexagonstar.data.structures.queues.Queue;	import com.hexagonstar.data.types.Byte;	import com.hexagonstar.event.FileIOEvent;	import com.hexagonstar.exception.DataStructureException;	import com.hexagonstar.exception.EmptyDataStructureException;	import com.hexagonstar.io.file.loaders.FileTypeLoaderFactory;	import com.hexagonstar.io.file.loaders.IFileTypeLoader;	import com.hexagonstar.io.file.loaders.ZIPFileLoader;	import com.hexagonstar.io.file.types.IFile;	import flash.events.EventDispatcher;		/**	 * The QueueFileLoader allows you to load a queue of files sequencially in one	 * sweep. You can either add files manually with the addFile() method or add a whole	 * queue of files at once by specifying the queue in the constructor or by using the	 * fileQueue property.<br>	 * When all files have been added, the load progress can be started by calling	 * load(). All files are loaded in the order they where added to the QueueFileLoader	 * or to the used queue.<br>	 * The load progress can be paused, unpaused or aborted.	 * 	 * @author Sascha Balkau	 * @version 1.0.0	 * @see com.hexagonstar.io.file.types.IFile	 */	public class QueueFileLoader extends EventDispatcher implements IFileLoader	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				/** @private */		protected var _file:IFile;		/** @private */		protected var _fileLoaderFactory:FileTypeLoaderFactory;		/** @private */		protected var _fileLoader:IFileTypeLoader;				/** @private */		protected var _fileQueue:Queue;		/** @private */		protected var _tempQueue:Queue;				/** @private */		protected var _currentFilePath:String;		/** @private */		protected var _currentEvent:FileIOEvent;		/** @private */		protected var _currentIndex:int;		/** @private */		protected var _fileCount:int;				/** @private */		protected var _filePercentage:Number;		/** @private */		protected var _bytesLoaded:int;		/** @private */		protected var _totalPercentage:Number;		/** @private */		protected var _totalBytesLoaded:Byte;				/** @private */		protected var _aborted:Boolean;		/** @private */		protected var _paused:Boolean;		/** @private */		protected var _finished:Boolean;		/** @private */		protected var _preventCaching:Boolean;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new QueueFileLoader instance. You can specify an existing file queue to		 * be used for loading files or add a file queue or single files later. Additionally		 * you can prevent the re-use of cached files by setting the preventCaching		 * parameter to true. This option is useful for use in a web-based application where		 * loaded files are cached by the browser or a proxy.		 * 		 * @param fileQueue A queue of files that should be loaded.		 * @param preventCaching If true the loader adds a timestamp to the file path to		 *            prevent file caching by server caches or proxies.		 */		public function QueueFileLoader(fileQueue:Queue = null,											preventCaching:Boolean = false)		{			super();			reset();						this.fileQueue = fileQueue;			_preventCaching = preventCaching;		}						/**		 * Resets the QueueFileLoader into it's default state. It is normally not necessary		 * to call this method. If a QueueFileLoader that has been used and has finished		 * loading all files is being used a second time, it is reset automatically if new		 * files are added or a new file queue is set.		 */		public function reset():void		{			_fileLoaderFactory = new FileTypeLoaderFactory();						_fileQueue = new Queue();			_tempQueue = new Queue();						_currentFilePath = null;			_currentEvent = null;			_currentIndex = -1;			_fileCount = 0;						_filePercentage = 0;			_bytesLoaded = 0;			_totalPercentage = 0;			_totalBytesLoaded = new Byte(0);						_aborted = false;			_paused = false;			_finished = false;		}				/**		 * Adds a new file to the loader's file queue.		 * 		 * @param file a File that is to be loaded.		 * @see com.hexagonstar.io.file.types.IFile		 */		public function addFile(file:IFile):void		{			if (!_fileQueue || _finished) reset();			_fileQueue.enqueue(file);			_fileCount = _fileQueue.size;		}						/**		 * Starts loading the queue of files that were added before. If the QueueFileLoader		 * has been paused it will be unpaused by calling this method.		 * 		 * @throws com.hexagonstar.env.exception.EmptyDataStructureException if no files		 *             have been added or the set file queue is empty.		 * @throws com.hexagonstar.env.exception.DataStructureException if the file queue		 *             contains objects that are not of type IFile.		 */		public function load():void		{			if (_fileQueue.isEmpty)			{				throw new EmptyDataStructureException(toString()					+ " Tried to load files from an empty file queue.");				return;			}						if (_paused)			{				unpause();				return;			}						_file = _fileQueue.dequeue();						if (_file is IFile)			{				_currentFilePath = _file.path					+ (!_preventCaching ? "" : "?nocaching=" + new Date().time);				_currentIndex++;				_fileLoader = _fileLoaderFactory.create(_file);				addLoaderEventListeners();								/* Catch security exception here in case the application tries				 * to locally load a resource from a non-trusted location */				try				{					_fileLoader.load(_currentFilePath);				}				catch (e:Error)				{					onSecurityError(new FileIOEvent(FileIOEvent.SECURITY_ERROR,					_file, e.message					+ " (Probably tried to load a local resource from a non-trusted location)."));				}			}			else			{				throw new DataStructureException(toString()					+ " Tried to use a queue that contains objects which are not of type IFile.");			}		}						/**		 * Puts the QueueFileLoader into paused mode. If a file is currently being loaded		 * the load progress does not pause immediately but only between files. So any file		 * that is currently in load progress is being loaded completely (if no load error		 * occurs) and then the QueueFileLoader is being put into paused mode.		 */		public function pause():void		{			_paused = true;		}						/**		 * Unpauses the QueueFileLoader if it has been paused before.		 */		public function unpause():void		{			if (!_paused) return;						_paused = false;			dispatchEvent(new FileIOEvent(FileIOEvent.UNPAUSE, _currentEvent.file,				_currentEvent.text, _currentEvent.httpStatus, _currentEvent.bubbles,				_currentEvent.cancelable));			next(_currentEvent);		}						/**		 * Aborts all file loading and broadcasts the complete event after it.		 */		public function abort():void		{			_aborted = true;			if (loading) _fileLoader.abort();			onAbort(new FileIOEvent(FileIOEvent.ABORT, _file));						/* If we abort while being paused, make sure that the complete			 * event gets fired or we'd stay paused and stuck forever. */			if (_paused)			{				next(_currentEvent);			}		}						/**		 * Disposes the QueueFileReader. The QueueFileReader instance should not be used		 * anymore after a call to this method.		 */		public function dispose():void		{			_fileLoader.dispose();			_currentEvent = null;			_fileLoader = null;			_fileLoaderFactory = null;			_fileQueue = null;			_tempQueue = null;		}						/**		 * A shortcut method that can be used to add all event listeners to the specified		 * listener class. The listener class must implement the IFileIOEventListener		 * interface to be a valid FileIO listener.		 * 		 * @param listener The class for which events listeners should be added.		 */		public function addEventListenersFor(listener:IFileIOEventListener):void		{			addEventListener(FileIOEvent.OPEN, listener.onOpen);			addEventListener(FileIOEvent.PROGRESS, listener.onProgress);			addEventListener(FileIOEvent.FILE_COMPLETE, listener.onFileComplete);			addEventListener(FileIOEvent.COMPLETE, listener.onComplete);			addEventListener(FileIOEvent.ABORT, listener.onAbort);			addEventListener(FileIOEvent.PAUSE, listener.onPause);			addEventListener(FileIOEvent.UNPAUSE, listener.onUnpause);			addEventListener(FileIOEvent.HTTP_STATUS, listener.onHTTPStatus);			addEventListener(FileIOEvent.IO_ERROR, listener.onIOError);			addEventListener(FileIOEvent.SECURITY_ERROR, listener.onSecurityError);		}						/**		 * Removes all event listeners that where added previously to the specified listener		 * class.		 * 		 * @param listener The class from which events listeners should be removed.		 */		public function removeEventListenersFor(listener:IFileIOEventListener):void		{			removeEventListener(FileIOEvent.OPEN, listener.onOpen);			removeEventListener(FileIOEvent.PROGRESS, listener.onProgress);			removeEventListener(FileIOEvent.FILE_COMPLETE, listener.onFileComplete);			removeEventListener(FileIOEvent.COMPLETE, listener.onComplete);			removeEventListener(FileIOEvent.ABORT, listener.onAbort);			removeEventListener(FileIOEvent.PAUSE, listener.onPause);			removeEventListener(FileIOEvent.UNPAUSE, listener.onUnpause);			removeEventListener(FileIOEvent.HTTP_STATUS, listener.onHTTPStatus);			removeEventListener(FileIOEvent.IO_ERROR, listener.onIOError);			removeEventListener(FileIOEvent.SECURITY_ERROR, listener.onSecurityError);		}						/**		 * Returns a string representation of QueueFileLoader.		 * 		 * @return A string representation of QueueFileLoader.		 */		override public function toString():String		{			return "[QueueFileLoader]";		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * The queue that contains files that are to be loaded by the QueueFileLoader.		 * 		 * @see com.hexagonstar.data.structures.queues.Queue		 * @see com.hexagonstar.io.file.types.IFile		 */		public function get fileQueue():Queue		{			return _fileQueue;		}		public function set fileQueue(v:Queue):void		{			if (!v) return;			/* If the loader was used before we reset it to prepare for another use. */			if (_finished) reset();			_fileQueue.addAll(v);			_fileCount = _fileQueue.size;		}				/**		 * The bytes that have so far been loaded by the loader.		 * 		 * @see com.hexagonstar.data.types.Byte.		 */		public function get bytesLoaded():Byte		{			return new Byte(_bytesLoaded);		}				/**		 * The percentage that has so far been loaded by the loader, thus value from 0 to		 * 100.		 */		public function get percentage():int		{			return Math.floor(_totalPercentage);		}				/**		 * The path of the file that is currently being loaded or if the loader is finished		 * loading, the path of the last file that was loaded.		 */		public function get currentFilePath():String		{			return _currentFilePath;		}				/**		 * The index of the currently loaded file.		 */		public function get currentIndex():int		{			return _currentIndex;		}				/**		 * @inheritDoc		 */		public function get loading():Boolean		{			if (_fileLoader) return _fileLoader.loading;			return false;		}				/**		 * @inheritDoc		 */		public function get aborted():Boolean		{			if (_fileLoader) return _fileLoader.aborted;			return false;		}				/**		 * @inheritDoc		 */		public function get paused():Boolean		{			return _paused;		}				/**		 * Gets/sets whether the loader is preventing file caching (true) or not (false).		 */		public function get preventCaching():Boolean		{			return _preventCaching;		}		public function set preventCaching(v:Boolean):void		{			_preventCaching = v;		}						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @private		 */		protected function onOpen(e:FileIOEvent):void		{			updateTotalProgress();			relayEvent(e);		}						/**		 * @private		 */		protected function onProgress(e:FileIOEvent):void		{			updateTotalProgress();			relayEvent(e);		}						/**		 * @private		 */		protected function onFileComplete(e:FileIOEvent):void		{			_bytesLoaded += _totalBytesLoaded.byte;			_filePercentage += (100 / _fileCount);			_tempQueue.enqueue(e.file);						relayEvent(e);			next(e);		}						/**		 * @private		 */		protected function onAbort(e:FileIOEvent):void		{			disposeFileLoader();			relayEvent(e);		}						/**		 * @private		 */		protected function onHTTPStatus(e:FileIOEvent):void		{			relayEvent(e);		}						/**		 * @private		 */		protected function onIOError(e:FileIOEvent):void		{			relayEvent(e);			next(e);		}						/**		 * @private		 */		protected function onSecurityError(e:FileIOEvent):void		{			relayEvent(e);						/* Catch any occuring exceptions here! We already relay the event			 * so any overlaying application can care about the error handling! */			try			{				next(e);			}			catch (err:Error)			{			}		}						/**		 * @private		 */		protected function onZippedFileLoaded(e:FileIOEvent):void		{			relayEvent(e);		}				/**		 * @private		 */		protected function onZipParseError(e:FileIOEvent):void		{			relayEvent(e);		}						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @private		 */		protected function addLoaderEventListeners():void		{			_fileLoader.addEventListener(FileIOEvent.OPEN, onOpen);			_fileLoader.addEventListener(FileIOEvent.PROGRESS, onProgress);			_fileLoader.addEventListener(FileIOEvent.FILE_COMPLETE, onFileComplete);			_fileLoader.addEventListener(FileIOEvent.ABORT, onAbort);			_fileLoader.addEventListener(FileIOEvent.HTTP_STATUS, onHTTPStatus);			_fileLoader.addEventListener(FileIOEvent.IO_ERROR, onIOError);			_fileLoader.addEventListener(FileIOEvent.SECURITY_ERROR, onSecurityError);						if (_fileLoader is ZIPFileLoader)			{				_fileLoader.addEventListener(FileIOEvent.ZIPPED_FILE_LOADED, onZippedFileLoaded);				_fileLoader.addEventListener(FileIOEvent.ZIP_PARSE_ERROR, onZipParseError);			}		}						/**		 * @private		 */		protected function disposeFileLoader():void		{			_fileLoader.removeEventListener(FileIOEvent.OPEN, onOpen);			_fileLoader.removeEventListener(FileIOEvent.PROGRESS, onProgress);			_fileLoader.removeEventListener(FileIOEvent.FILE_COMPLETE, onFileComplete);			_fileLoader.removeEventListener(FileIOEvent.ABORT, onAbort);			_fileLoader.removeEventListener(FileIOEvent.HTTP_STATUS, onHTTPStatus);			_fileLoader.removeEventListener(FileIOEvent.IO_ERROR, onIOError);			_fileLoader.removeEventListener(FileIOEvent.SECURITY_ERROR, onSecurityError);						if (_fileLoader is ZIPFileLoader)			{				_fileLoader.removeEventListener(FileIOEvent.ZIPPED_FILE_LOADED, onZippedFileLoaded);				_fileLoader.removeEventListener(FileIOEvent.ZIP_PARSE_ERROR, onZipParseError);			}						_fileLoader.dispose();		}						/**		 * @private		 */		protected function updateTotalProgress():void		{			_totalBytesLoaded = _fileLoader.bytesLoaded;			_totalPercentage = _filePercentage + (_fileLoader.percentage / _fileCount);		}						/**		 * @private		 */		protected function relayEvent(e:FileIOEvent):void		{			dispatchEvent(e);		}						/**		 * @private		 */		protected function next(e:FileIOEvent):void		{			_currentEvent = e;						if (_paused)			{				dispatchEvent(new FileIOEvent(FileIOEvent.PAUSE, e.file, e.text,					e.httpStatus, e.bubbles, e.cancelable));				return;			}						if (!_fileQueue.isEmpty && !_aborted)			{				load();			}			else			{				/* If we abort loading we add all empty left-over files from the				 * file queue to the temp queue and then make the temp queue the file				 * queue so that the order of files is correct again. */				if (_aborted)				{					_tempQueue.addAll(_fileQueue);					_fileQueue = _tempQueue;				}				else				{					_fileQueue.addAll(_tempQueue);				}								disposeFileLoader();				_finished = true;				dispatchEvent(new FileIOEvent(FileIOEvent.COMPLETE, e.file, e.text,					e.httpStatus, e.bubbles, e.cancelable));			}		}	}}