/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.io.file.types{	import com.hexagonstar.data.constants.CharEncoding;	import com.hexagonstar.data.types.Byte;	import com.hexagonstar.io.file.FileErrorStatus;	import com.hexagonstar.util.ChecksumUtil;	import flash.utils.ByteArray;	import flash.utils.Dictionary;	import flash.utils.Endian;	import flash.utils.IDataInput;	import flash.utils.IDataOutput;	import flash.utils.describeType;		/**	 * Represents a file contained in a ZIP archive. You don't use this class	 * directly, instead it's used by the ZIPFile class.	 */	public class ZippedFile extends AbstractFile implements IFile	{		////////////////////////////////////////////////////////////////////////////////////////		// Constants                                                                          //		////////////////////////////////////////////////////////////////////////////////////////				public static const COMPRESSION_NONE:int				= 0;		public static const COMPRESSION_SHRUNK:int			= 1;		public static const COMPRESSION_REDUCED_1:int			= 2;		public static const COMPRESSION_REDUCED_2:int			= 3;		public static const COMPRESSION_REDUCED_3:int			= 4;		public static const COMPRESSION_REDUCED_4:int			= 5;		public static const COMPRESSION_IMPLODED:int			= 6;		public static const COMPRESSION_TOKENIZED:int			= 7;		public static const COMPRESSION_DEFLATED:int			= 8;		public static const COMPRESSION_DEFLATED_EXT:int		= 9;		public static const COMPRESSION_IMPLODED_PKWARE:int	= 10;				protected static var HAS_INFLATE:Boolean =			describeType(ByteArray).factory.method.(@name == "uncompress").hasComplexContent();						////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				protected var _versionHost:int = 0;		protected var _versionNumber:String = "2.0";		protected var _compressionMethod:int = 8;		protected var _implodeDictSize:int = -1;		protected var _implodeShannonFanoTrees:int = -1;		protected var _deflateSpeedOption:int = -1;		protected var _date:Date;				protected var _crc32:uint;		protected var _adler32:uint;				protected var _sizeCompressed:uint = 0;		protected var _sizeUncompressed:uint = 0;		protected var _sizeFilename:uint = 0;		protected var _sizeExtra:uint = 0;				protected var _filenameEncoding:String;		protected var _comment:String = "";				protected var _extraFields:Dictionary;		protected var _content:ByteArray;				protected var _parseFunc:Function = parseFileHeader;				protected var _hasDataDescriptor:Boolean = false;		protected var _hasCompressedPatchedData:Boolean = false;		protected var _hasAdler32:Boolean = false;		protected var _isEncrypted:Boolean = false;		protected var _isCompressed:Boolean = false;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new ZippedFile instance.		 */		public function ZippedFile(filenameEncoding:String = CharEncoding.UTF8)		{			_filenameEncoding = filenameEncoding;			_extraFields = new Dictionary();			_content = new ByteArray();			_content.endian = Endian.BIG_ENDIAN;		}						/**		 * Gets the files content as string.		 * 		 * @param recompress If <code>true</code>, the raw file content		 *         is recompressed after decoding the string.		 * @param charset The character set used for decoding.		 * @return The file as string.		 */		public function getContentAsString(recompress:Boolean = true,												charset:String = CharEncoding.UTF8):String		{			if (_isCompressed) uncompress();						_content.position = 0;			var str:String;						/* Is readMultiByte completely trustworthy with utf-8?			 * For now, readUTFBytes will take over. */			if (charset == "utf-8") 			{				str = _content.readUTFBytes(_content.bytesAvailable);			} 			else 			{				str = _content.readMultiByte(_content.bytesAvailable, charset);			}						_content.position = 0;			if (recompress) compress();			return str;		}				/**		 * Sets a string as the file's content.		 * 		 * @param value The string.		 * @param charset The character set used for decoding.		 */		public function setContentAsString(value:String,												charset:String = CharEncoding.UTF8):void		{			_content.length = 0;			_content.position = 0;			_isCompressed = false;						if (value != null && value.length > 0)			{				if (charset == "utf-8")				{					_content.writeUTFBytes(value);				} 				else 				{					_content.writeMultiByte(value, charset);				}								_crc32 = ChecksumUtil.generateCRC32(_content);				_hasAdler32 = false;			}						compress();		}						/**		 * Serializes this zip archive into an IDataOutput stream (such as 		 * ByteArray or FileStream) according to PKZIP APPNOTE.TXT		 * 		 * @param stream The stream to serialize the zip archive into.		 * @param includeAdler32 If set to true, include Adler32 checksum.		 * @param centralDir If set to true, serialize a central directory entry		 * @param centralDirOffset Relative offset of local header (for central directory only).		 * @return The serialized zip file.		 */		public function serialize(stream:IDataOutput,									 includeAdler32:Boolean,									 centralDir:Boolean = false,									 centralDirOffset:uint = 0):uint		{			if (stream == null) return 0;						if (centralDir)			{				/* Write central directory file header signature*/				stream.writeUnsignedInt(0x02014B50);				/* Write "version made by" host (usually 0) and number (always 2.0) */				stream.writeShort((_versionHost << 8) | 0x14);			}			else			{				/* Write local file header signature */				stream.writeUnsignedInt(0x04034B50);			}						/* Write "version needed to extract" host (usually 0) and number (always 2.0) */			stream.writeShort((_versionHost << 8) | 0x14);						/* Write the general purpose flag			 * - no encryption			 * - normal deflate			 * - no data descriptors			 * - no compressed patched data			 * - unicode as specified in _filenameEncoding */			stream.writeShort((_filenameEncoding == "utf-8") ? 0x0800 : 0);						/* Write compression method (always deflate) */			stream.writeShort(COMPRESSION_DEFLATED);						/* Write date */			var d:Date = (_date != null) ? _date : new Date();			var msdosTime:uint = uint(d.getSeconds()) | (uint(d.getMinutes()) << 5) | (uint(d.getHours()) << 11);			var msdosDate:uint = uint(d.getDate()) | (uint(d.getMonth() + 1) << 5) | (uint(d.getFullYear() - 1980) << 9);			stream.writeShort(msdosTime);			stream.writeShort(msdosDate);						/* Write CRC32 */			stream.writeUnsignedInt(_crc32);						/* Write compressed size */			stream.writeUnsignedInt(_sizeCompressed);						/* Write uncompressed size */			stream.writeUnsignedInt(_sizeUncompressed);						/* Prep filename */			var ba:ByteArray = new ByteArray();			ba.endian = Endian.LITTLE_ENDIAN;			if (_filenameEncoding == "utf-8") ba.writeUTFBytes(_path);			else ba.writeMultiByte(_path, _filenameEncoding);						var filenameSize:uint = ba.position;						/* Prep extra fields */			for(var headerID:Object in _extraFields)			{				var extraBytes:ByteArray = ByteArray(_extraFields[headerID]);				if (extraBytes != null)				{					ba.writeShort(uint(headerID));					ba.writeShort(uint(extraBytes.length));					ba.writeBytes(extraBytes);				}			}						if (includeAdler32)			{				if (!_hasAdler32)				{					var isCompressed:Boolean = _isCompressed;					if (isCompressed) uncompress();					_adler32 = ChecksumUtil.generateAdler32(_content, 0, _content.length);					_hasAdler32 = true;					if (isCompressed) compress();				}								ba.writeShort(0xDADA);				ba.writeShort(4);				ba.writeUnsignedInt(_adler32);			}						var extrafieldsSize:uint = ba.position - filenameSize;						/* Prep comment (currently unused) */			if (centralDir && _comment.length > 0)			{				if (_filenameEncoding == "utf-8") ba.writeUTFBytes(_comment);				else ba.writeMultiByte(_comment, _filenameEncoding);			}						var commentSize:uint = ba.position - filenameSize - extrafieldsSize;						/* Write filename and extra field sizes */			stream.writeShort(filenameSize);			stream.writeShort(extrafieldsSize);						if (centralDir)			{				/* Write comment size */				stream.writeShort(commentSize);				/* Write disk number start (always 0) */				stream.writeShort(0);				/* Write file attributes (always 0) */				stream.writeShort(0);				stream.writeUnsignedInt(0);				/* Write relative offset of local header */				stream.writeUnsignedInt(centralDirOffset);			}						/* Write filename, extra field and comment */			if (filenameSize + extrafieldsSize + commentSize > 0)			{				stream.writeBytes(ba);			}						/* Write file */			var fileSize:uint = 0;			if (!centralDir && _sizeCompressed > 0)			{				if (HAS_INFLATE)				{					fileSize = _content.length;					stream.writeBytes(_content, 0, fileSize);				}				else				{					fileSize = _content.length - 6;					stream.writeBytes(_content, 2, fileSize);				}			}						var size:uint = 30 + filenameSize + extrafieldsSize + commentSize + fileSize;			if (centralDir) size += 16;			return size;		}						/**		 * @private		 */		public function parse(stream:IDataInput):Boolean		{			while (stream.bytesAvailable && _parseFunc(stream));			return (_parseFunc === parseFileIdle);		}						/**		 * Returns a string representation of the FZipFile object.		 */		public function dump():String		{			return "\n" + super.toString()				+ "\n["				+ "\n\tpath=" + _path				+ "\n\tdate=" + _date				+ "\n\tsizeCompressed=" + _sizeCompressed				+ "\n\tsizeUncompressed=" + _sizeUncompressed				+ "\n\tversionHost=" + _versionHost				+ "\n\tversionNumber=" + _versionNumber				+ "\n\tcompressionMethod=" + _compressionMethod				+ "\n\tisEncrypted=" + _isEncrypted				+ "\n\thasDataDescriptor=" + _hasDataDescriptor				+ "\n\thasCompressedPatchedData=" + _hasCompressedPatchedData				+ "\n\tfilenameEncoding=" + _filenameEncoding				+ "\n\tcrc32=" + _crc32.toString(16)				+ "\n\tadler32=" + _adler32.toString(16)				+ "\n]";		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * The Date and time the file was created.		 */		public function get date():Date		{			return _date;		}		public function set date(v:Date):void		{			_date = (v != null) ? v : new Date();		}						/**		 * The raw, uncompressed file. 		 */		override public function get content():*		{			if (_isCompressed) uncompress();			return _content;		}		public function set content(v:*):void		{			if (v != null && v.length > 0)			{				v.position = 0;				v.readBytes(_content, 0, v.length);				_crc32 = ChecksumUtil.generateCRC32(_content);				_hasAdler32 = false;			}			else			{				_content.length = 0;				_content.position = 0;				_isCompressed = false;			}			compress();		}						public function get contentAsBytes():ByteArray		{			if (_isCompressed) uncompress();			_content.position = 0;			return _content;		}		public function set contentAsBytes(v:ByteArray):void		{			try			{				_content = new ByteArray();				_content.writeBytes(v);				_content.position = 0;				_isValid = true;				_errorStatus = FileErrorStatus.OK;			}			catch (e:Error)			{				_isValid = false;				_errorStatus = e.toString();			}						if (_isValid) _size = new Byte(_content.length);		}						public function get fileTypeID():int		{			return FileTypeIndex.ZIPPED_FILE_ID;		}						/**		 * The ZIP specification version supported by the software 		 * used to encode the file.		 */		public function get versionNumber():String		{			return _versionNumber;		}						/**		 * The size of the compressed file (in bytes).		 */		public function get sizeCompressed():uint		{			return _sizeCompressed;		}						/**		 * The size of the uncompressed file (in bytes).		 */		public function get sizeUncompressed():uint		{			return _sizeUncompressed;		}						/**		 * get contentSize		 * For Debugging only!		 */		public function get contentSize():uint		{			return _content.length;		}						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @private		 */		protected function parseFileIdle(stream:IDataInput):Boolean		{			return false;		}						/**		 * @private		 */		protected function parseFileHeader(stream:IDataInput):Boolean		{			if (stream.bytesAvailable >= 30)			{				parseHeader(stream);				if(_sizeFilename + _sizeExtra > 0)				{					_parseFunc = parseFileHeaderExt;				}				else				{					_parseFunc = parseFileContent;				}				return true;			}			return false;		}						/**		 * @private		 */		protected function parseFileHeaderExt(stream:IDataInput):Boolean		{			if (stream.bytesAvailable >= _sizeFilename + _sizeExtra)			{				parseHeaderExt(stream);				_parseFunc = parseFileContent;				return true;			}			return false;		}						/**		 * @private		 */		protected function parseFileContent(stream:IDataInput):Boolean		{			if (_hasDataDescriptor)			{				/* Data descriptors are not supported */				_parseFunc = parseFileIdle;				throw new Error("Data descriptors are not supported.");			}			else if(_sizeCompressed == 0)			{				/* This entry has no file attached */				_parseFunc = parseFileIdle;			}			else if (stream.bytesAvailable >= _sizeCompressed)			{				parseContent(stream);				_parseFunc = parseFileIdle;			}			else			{				return false;			}			return true;		}						/**		 * @private		 */		protected function parseHeader(data:IDataInput):void		{			var vSrc:uint = data.readUnsignedShort();			_versionHost = vSrc >> 8;			_versionNumber = Math.floor((vSrc & 0xff) / 10) + "." + ((vSrc & 0xff) % 10);						var flag:uint = data.readUnsignedShort();						_compressionMethod = data.readUnsignedShort();			_isEncrypted = (flag & 0x01) !== 0;			_hasDataDescriptor = (flag & 0x08) !== 0;			_hasCompressedPatchedData = (flag & 0x20) !== 0;						if ((flag & 800) !== 0)			{				_filenameEncoding = CharEncoding.UTF8;			}						if (_compressionMethod === COMPRESSION_IMPLODED)			{				_implodeDictSize = (flag & 0x02) !== 0 ? 8192 : 4096;				_implodeShannonFanoTrees = (flag & 0x04) !== 0 ? 3 : 2;			}			else if (_compressionMethod === COMPRESSION_DEFLATED)			{				_deflateSpeedOption = (flag & 0x06) >> 1;			}						var msdosTime:uint = data.readUnsignedShort();			var msdosDate:uint = data.readUnsignedShort();			var sec:int = (msdosTime & 0x001f);			var min:int = (msdosTime & 0x07e0) >> 5;			var hour:int = (msdosTime & 0xf800) >> 11;			var day:int = (msdosDate & 0x001f);			var month:int = (msdosDate & 0x01e0) >> 5;			var year:int = ((msdosDate & 0xfe00) >> 9) + 1980;						_date = new Date(year, month - 1, day, hour, min, sec, 0);			_crc32 = data.readUnsignedInt();			_sizeCompressed = data.readUnsignedInt();			_sizeUncompressed = data.readUnsignedInt();			_size = new Byte(_sizeUncompressed);			_sizeFilename = data.readUnsignedShort();			_sizeExtra = data.readUnsignedShort();		}						/**		 * @private		 */		protected function parseHeaderExt(data:IDataInput):void		{			if (_filenameEncoding == CharEncoding.UTF8)			{				/* Fixes a bug in some players */				_path = data.readUTFBytes(_sizeFilename);			}			else			{				_path = data.readMultiByte(_sizeFilename, _filenameEncoding);			}						var bytesLeft:uint = _sizeExtra;						while (bytesLeft > 4)			{				var headerID:uint = data.readUnsignedShort();				var dataSize:uint = data.readUnsignedShort();								if (dataSize > bytesLeft)				{					throw new Error("Parse error in file " + _path						+ ": Extra field data size too big.");				}								if (headerID === 0xDADA && dataSize === 4)				{					_adler32 = data.readUnsignedInt();					_hasAdler32 = true;				}				else if (dataSize > 0)				{					var extraBytes:ByteArray = new ByteArray();					data.readBytes(extraBytes, 0, dataSize);					_extraFields[headerID] = extraBytes;				}				bytesLeft -= dataSize + 4;			}						if (bytesLeft > 0)			{				data.readBytes(new ByteArray(), 0, bytesLeft);			}		}						/**		 * @private		 */		protected function parseContent(data:IDataInput):void		{			if (_compressionMethod === COMPRESSION_DEFLATED && !_isEncrypted)			{				if (HAS_INFLATE)				{					// Adobe Air supports inflate decompression.					// If we got here, this is an Air application					// and we can decompress without using the Adler32 hack					// so we just write out the raw deflate compressed file					data.readBytes(_content, 0, _sizeCompressed);				}				else if (_hasAdler32)				{					// Add zlib header					// CMF (compression method and info)					_content.writeByte(0x78);										// FLG (compression level, preset dict, checkbits)					var flg:uint = (~_deflateSpeedOption << 6) & 0xC0;					flg += 31 - (((0x78 << 8) | flg) % 31);					_content.writeByte(flg);										// Add raw deflate-compressed file					data.readBytes(_content, 2, _sizeCompressed);										// Add adler32 checksum					_content.position = _content.length;					_content.writeUnsignedInt(_adler32);				}				else 				{					throw new Error("Adler32 checksum not found.");				}								_isCompressed = true;			}			else if (_compressionMethod == COMPRESSION_NONE)			{				data.readBytes(_content, 0, _sizeCompressed);				_isCompressed = false;			}			else			{				throw new Error("Compression method " + _compressionMethod + " is not supported.");			}			_content.position = 0;		}						/**		 * @private		 */		protected function compress():void		{			if (!_isCompressed)			{				if (_content.length > 0)				{					_content.position = 0;					_sizeUncompressed = _content.length;					_size = new Byte(_sizeUncompressed);										if (HAS_INFLATE)					{						_content.compress.apply(_content, ["deflate"]);						_sizeCompressed = _content.length;					}					else					{						_content.compress();						_sizeCompressed = _content.length - 6;					}					_content.position = 0;					_isCompressed = true;				}				else				{					_sizeCompressed = 0;					_sizeUncompressed = 0;					_size = new Byte(_sizeUncompressed);				}			}		}						/**		 * @private		 */		protected function uncompress():void		{			if (_isCompressed && _content.length > 0)			{				_content.position = 0;								if (HAS_INFLATE)				{					_content.uncompress.apply(_content, ["deflate"]);				}				else 				{					_content.uncompress();				}								_content.position = 0;				_isCompressed = false;			}		}	}}