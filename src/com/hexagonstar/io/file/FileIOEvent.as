/* * hexagon framework - Multi-Purpose ActionScript 3 Framework. * Copyright (C) 2007 Hexagon Star Softworks *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/ FRAMEWORK_/ *            \__/  \__/ * * ``The contents of this file are subject to the Mozilla Public License * Version 1.1 (the "License"); you may not use this file except in * compliance with the License. You may obtain a copy of the License at * http://www.mozilla.org/MPL/ * * Software distributed under the License is distributed on an "AS IS" * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the * License for the specific language governing rights and limitations * under the License. */package com.hexagonstar.io.file{	import com.hexagonstar.io.file.types.IFile;		import flash.events.Event;			/**	 * FileIOEvent defines constant event identifiers for file IO events.	 * It also stores the HTTP Status value for HTTPStatus Events so that they	 * can be traced back after the original event has already been removed.	 */	public class FileIOEvent extends Event	{		////////////////////////////////////////////////////////////////////////////////////////		// Constants                                                                          //		////////////////////////////////////////////////////////////////////////////////////////				public static const OPEN:String					= "ioOpen";		public static const PROGRESS:String				= "ioProgress";		public static const COMPLETE:String				= "ioKomplete";		public static const ALL_COMPLETE:String			= "ioAllKomplete";		public static const ABORT:String					= "ioAbort";				public static const HTTP_STATUS:String			= "ioHTTPStatus";		public static const IO_ERROR:String				= "ioIOError";		public static const SECURITY_ERROR:String		= "ioSecurityError";				public static const FILE_EXISTS:String			= "ioFileExists";		public static const SAVE_COMPLETE:String			= "ioSaveComplete";		public static const COMPRESSION_COMPLETE:String	= "ioCompressionComplete";						////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				private var _file:IFile;		private var _text:String;		private var _httpStatus:int;				////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new FileIOEvent instance.		 */		public function FileIOEvent(type:String,									   currentFile:IFile = null,									   text:String = "",									   httpStatus:int = 0,									   bubbles:Boolean = false,									   cancelable:Boolean = false)		{			super(type, bubbles, cancelable);			_file = currentFile;			_text = text;			_httpStatus = httpStatus;		}						/**		 * clone		 */		override public function clone():Event		{			return new FileIOEvent(type,									_file,									_text,									_httpStatus,									bubbles,									cancelable);		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Returns a reference to the last loaded file.		 */		public function get file():IFile		{			return _file;		}						/**		 * Returns the text of the FileIOEvent.		 */		public function get text():String		{			return _text;		}						/**		 * Returns the HTTPStatus for HTTPStatus Events.		 */		public function get httpStatus():int		{			return _httpStatus;		}	}}