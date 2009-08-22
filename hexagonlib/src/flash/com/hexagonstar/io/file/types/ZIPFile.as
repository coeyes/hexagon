/*
 * hexagonlib - Multi-Purpose ActionScript 3 Library.
 *       __    __
 *    __/  \__/  \__    __
 *   /  \__/HEXAGON \__/  \
 *   \__/  \__/  LIBRARY _/
 *            \__/  \__/
 *
 * Licensed under the MIT License
 * 
 * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks
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
package com.hexagonstar.io.file.types
{
	import com.hexagonstar.data.types.Byte;
	import com.hexagonstar.io.file.FileErrorStatus;

	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	import flash.utils.IDataOutput;

	
	/**
	 * ZIPFile class
	 */
	public class ZIPFile extends AbstractFile implements IFile
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		protected var _content:ByteArray;
		
		protected var _filesList:Vector.<ZippedFile>;
		protected var _filesDict:Dictionary;
		protected var _charEncoding:String;
		protected var _parseFunc:Function;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new ZIPFile instance.
		 * 
		 * @param path The path of the ZIPFile.
		 */
		public function ZIPFile(path:String = "", id:String = null)
		{
			super(path, id);
			
			_content = new ByteArray();
			_filesList = new Vector.<ZippedFile>();
			_filesDict = new Dictionary();
		}
		
		
		/**
		 * Retrieves a file contained in the ZIP archive, by index.
		 * 
		 * @param index The index of the file to retrieve
		 * @return A reference to a FZipFile object
		 */
		public function getFileAt(index:int):ZippedFile
		{
			return _filesList ? _filesList[index] : null;
		}
		
		
		/**
		 * Retrieves a file contained in the ZIP archive, by filename.
		 * 
		 * @param path The filename of the file to retrieve
		 * @return A reference to a FZipFile object
		 */
		public function getFileByPath(path:String):ZippedFile 
		{
			return _filesDict[path] ? ZippedFile(_filesDict[path]) : null;
		}
		
		
		/**
		 * Adds a file to the ZIP archive.
		 * 
		 * @param path The filename
		 * @param content The ByteArray containing the uncompressed data
		 *         (pass <code>null</code> to add a folder)
		 * @return A reference to the newly created ZippedFile object
		 */
		public function addFile(path:String, content:ByteArray = null):ZippedFile
		{
			return addFileAt((_filesList ? _filesList.length : 0), path, content);
		}
		
		
		/**
		 * Adds a file from a String to the ZIP archive.
		 * 
		 * @param path The filename
		 * @param content The String
		 * @param charset The character set
		 * @return A reference to the newly created ZippedFile object
		 */
		public function addFileFromString(path:String,
											  content:String,
											  charset:String = "utf-8"):ZippedFile
		{
			return addFileFromStringAt((_filesList ? _filesList.length : 0),
				path, content, charset);
		}
		
		
		/**
		 * Adds a file to the ZIP archive, at a specified index.
		 * 
		 * @param index The index
		 * @param path The filename
		 * @param content The ByteArray containing the uncompressed data
		 *         (pass <code>null</code> to add a folder)
		 * @return A reference to the newly created ZippedFile object
		 */
		public function addFileAt(index:int,
									 path:String,
									 content:ByteArray = null):ZippedFile
		{
			if (_filesDict[path])
			{
				throw(new Error("File already exists: " + path + ". Please remove first."));
			}
			
			var file:ZippedFile = new ZippedFile();
			file.path = path;
			file.content = content;
			
			if (index >= _filesList.length)
			{
				_filesList.push(file);
			}
			else
			{
				_filesList.splice(index, 0, file);
			}
			
			_filesDict[path] = file;
			return file;
		}
		
		
		/**
		 * Adds a file from a String to the ZIP archive, at a specified index.
		 * 
		 * @param index The index
		 * @param path The filename
		 * @param content The String
		 * @param charset The character set
		 * @return A reference to the newly created ZippedFile object
		 */
		public function addFileFromStringAt(index:int,
												 path:String,
												 content:String,
												 charset:String = "utf-8"):ZippedFile
		{
			if (_filesDict[path])
			{
				throw(new Error("File already exists: " + path + ". Please remove first."));
			}
			
			var file:ZippedFile = new ZippedFile();
			file.path = path;
			file.setContentAsString(content, charset);
			
			if (index >= _filesList.length)
			{
				_filesList.push(file);
			}
			else
			{
				_filesList.splice(index, 0, file);
			}
			
			_filesDict[path] = file;
			return file;
		}
		
		
		/**
		 * Used by ZIPFileLoader
		 */
		public function addZippedFile(zippedFile:ZippedFile):void
		{
			_filesList.push(zippedFile);
			if (zippedFile.path)
			{
				_filesDict[zippedFile.path] = zippedFile;
			}
		}
		
		
		/**
		 * Removes a file at a specified index from the ZIP archive.
		 * 
		 * @param index The index
		 * @return A reference to the removed ZippedFile object
		 */
		public function removeFileAt(index:int):ZippedFile 
		{
			if (_filesList != null && _filesDict != null && index < _filesList.length)
			{
				var file:ZippedFile = _filesList[index];
				if (file != null)
				{
					_filesList.splice(index, 1);
					delete _filesDict[file.path];
					return file;
				}
			}
			return null;
		}
		
		
		/**
		 * Serializes this zip archive into an IDataOutput stream (such as
		 * ByteArray or FileStream) according to PKZIP APPNOTE.TXT
		 * 
		 * @param stream The stream to serialize the zip file into.
		 * @param includeAdler32 To decompress compressed files, FZip needs Adler32
		 *         checksums to be injected into the zipped files. FZip will do that 
		 *         automatically if includeAdler32 is set to true. Note that if the
		 *         ZIP contains a lot of files, or big files, the calculation of the
		 *         checksums may take a while.
		 */
		public function serialize(stream:IDataOutput, includeAdler32:Boolean = false):void
		{
			if (stream != null && _filesList.length > 0)
			{
				var endian:String = stream.endian;
				var ba:ByteArray = new ByteArray();
				var offset:uint = 0;
				var files:uint = 0;
				
				stream.endian = ba.endian = Endian.LITTLE_ENDIAN;
				
				for (var i:int = 0; i < _filesList.length; i++)
				{
					var file:ZippedFile = _filesList[i];
					if (file != null)
					{
						/* first serialize the central directory item into our temporary ByteArray */
						file.serialize(ba, includeAdler32, true, offset);
						/* then serialize the file itself into the stream and update the offset */
						offset += file.serialize(stream, includeAdler32);
						/* keep track of how many files we have written */
						files++;
					}
				}
				
				if (ba.length > 0)
				{
					/* Write the central diectory items */
					stream.writeBytes(ba);
				}
				
				/* Write end of central directory: */
				/* Write signature */
				stream.writeUnsignedInt(0x06054B50);
				
				/* Write number of this disk (always 0) */
				stream.writeShort(0);
				
				/* Write number of this disk with the start of the central directory (always 0) */
				stream.writeShort(0);
				
				/* Write total number of entries on this disk */
				stream.writeShort(files);
				
				/* Write total number of entries */
				stream.writeShort(files);
				
				/* Write size */
				stream.writeUnsignedInt(ba.length);
				
				/* Write offset of start of central directory with respect to the
				 * starting disk number */
				stream.writeUnsignedInt(offset);
				
				/* Write zip file comment length (always 0) */
				stream.writeShort(0);
				
				/* Reset endian of stream */
				stream.endian = endian;
			}
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		
		override public function get content():*
		{
			return contentAsBinary;
		}
		
		
		public function set content(v:*):void
		{
			contentAsBinary = (v as ByteArray);
		}
		
		
		public function get contentAsBinary():ByteArray
		{
			_content.position = 0;
			return _content;
		}
		
		
		public function set contentAsBinary(v:ByteArray):void
		{
			try
			{
				_content = new ByteArray();
				_content.writeBytes(v);
				_content.position = 0;
				_isValid = true;
				_errorStatus = FileErrorStatus.OK;
			}
			catch (e:Error)
			{
				_isValid = false;
				_errorStatus = e.toString();
			}
			
			if (_isValid) _size = new Byte(_content.length);
		}
		
		
		public function get fileTypeID():int
		{
			return FileTypeIndex.ZIP_FILE_ID;
		}
		
		
		/**
		 * Gets the number of accessible files in the ZIP archive.
		 * @return The number of files
		 */
		public function get fileCount():int
		{
			return _filesList ? _filesList.length : 0;
		}
	}
}
