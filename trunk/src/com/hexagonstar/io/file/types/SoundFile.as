/* * hexagon framework - Multi-Purpose ActionScript 3 Framework. * Copyright (C) 2007 Hexagon Star Softworks *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/ FRAMEWORK_/ *            \__/  \__/ * * ``The contents of this file are subject to the Mozilla Public License * Version 1.1 (the "License"); you may not use this file except in * compliance with the License. You may obtain a copy of the License at * http://www.mozilla.org/MPL/ * * Software distributed under the License is distributed on an "AS IS" * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the * License for the specific language governing rights and limitations * under the License. */package com.hexagonstar.io.file.types{	import flash.media.Sound;	import flash.utils.ByteArray;			/**	 * SoundFile class	 */	public class SoundFile extends AbstractFile implements IFile	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				private var _container:Sound;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new SoundFile instance.		 */		public function SoundFile()		{			// TODO (Reserved for Sound File)		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				override public function get content():*		{			return null;		}						public function set content(v:*):void		{		}						public function get contentAsBinary():ByteArray		{			return null;		}						public function set contentAsBinary(v:ByteArray):void		{		}						public function get fileTypeID():int		{			return FileTypeIndex.SOUND_FILE_ID;		}	}}