/* * hexagon framework - Multi-Purpose ActionScript 3 Framework. * Copyright (C) 2007 Hexagon Star Softworks *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/ FRAMEWORK_/ *            \__/  \__/ * * ``The contents of this file are subject to the Mozilla Public License * Version 1.1 (the "License"); you may not use this file except in * compliance with the License. You may obtain a copy of the License at * http://www.mozilla.org/MPL/ * * Software distributed under the License is distributed on an "AS IS" * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the * License for the specific language governing rights and limitations * under the License. */package com.hexagonstar.io.file{	import com.hexagonstar.io.file.types.IFile;		import flash.net.URLLoaderDataFormat;			/**	 * TextFileLoader is an implementation of FileLoader for text-based resources.	 */	public class TextFileLoader extends BinaryFileLoader implements IFileLoader	{		////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new TextFileLoader instance.		 */		public function TextFileLoader(file:IFile)		{			super(file);			_dataFormat = URLLoaderDataFormat.TEXT;		}	}}