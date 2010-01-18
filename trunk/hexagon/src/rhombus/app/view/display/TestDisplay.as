/*
 * rhombus - Application framework for web/desktop-based Flash & Flex projects.
 * 
 *  /\ RHOMBUS
 *  \/ FRAMEWORK
 * 
 * Licensed under the MIT License
 * Copyright (c) 2008 Sascha Balkau / Hexagon Star Softworks
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
package view.display
{
	import com.hexagonstar.display.ui.controls.TextArea;
	import com.hexagonstar.event.BulkProgressEvent;
	import com.hexagonstar.event.FileIOEvent;
	import com.hexagonstar.framework.view.display.AbstractDisplay;
	import com.hexagonstar.framework.view.display.IDisplay;
	import com.hexagonstar.io.file.BulkLoader;
	import com.hexagonstar.io.file.types.IFile;
	import com.hexagonstar.io.file.types.ImageFile;
	import com.hexagonstar.io.file.types.XMLFile;
	import com.hexagonstar.io.resource.types.ImageResource;
	import com.hexagonstar.util.debug.Debug;

	
	/**
	 * Simple test class to demonstrate how to set up display classes.
	 * 
	 * @author Sascha Balkau
	 */
	public class TestDisplay extends AbstractDisplay implements IDisplay
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		protected var _testTextArea:TextArea;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new TestDisplay instance.
		 */
		public function TestDisplay()
		{
			super();
			setup();
		}
		
		
		/**
		 * @inheritDoc
		 */
		override public function start():void
		{
			super.start();
			
			//ResourceManager.instance.load("../../../bin/icons/icon_128x128.png", ImageResource,
			//	onResourceLoaded, onResourceFailed);
			
			var file1:IFile = new ImageFile("icons/icon_16x16.png");
			var file2:IFile = new ImageFile("icons/icon_32x32.png");
			var file3:IFile = new ImageFile("icons/icon_48x48.png");
			var file4:IFile = new ImageFile("icons/icon_128x128.png");
			
			var file5:IFile = new XMLFile("data/datafiles.xml");
			var file6:IFile = new XMLFile("data/data1.xml");
			var file7:IFile = new XMLFile("data/data2.xml");
			var file8:IFile = new XMLFile("data/data3.xml");
			//var file9:IFile = new XMLFile("data/dummy.xml");
			
			var bl:BulkLoader = new BulkLoader();
			bl.addEventListener(FileIOEvent.PROGRESS, onLoadProgress);
			
			bl.addFile(file1);
			bl.addFile(file2);
			bl.addFile(file6);
			bl.addFile(file7);
			
			bl.load();
			Debug.trace(bl.fileCount);
			//bl.addFile(file9);
			//Debug.trace(bl.fileCount);
			
//			setTimeout(function():void
//			{
//				bl.maxConnections = 1;
//				bl.addFile(file3);
//				bl.addFile(file4);
//				bl.addFile(file5);
//				bl.addFile(file8);
//				Debug.trace(bl.fileCount);
//				bl.load();
//			}, 16);
		}
		
		
		private function onLoadProgress(e:BulkProgressEvent):void
		{
			Debug.trace("bytesLoaded: " + e.bytesLoaded + " / " + e.bytesTotal);
			Debug.trace("percentLoaded: " + e.percentLoaded + " / 100");
		}

		
		/**
		 * @inheritDoc
		 */
		override public function stop():void
		{
			super.stop();
		}
		
		
		/**
		 * @inheritDoc
		 */
		override public function reset():void
		{
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Event Handlers                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * onResourceLoaded
		 */
		public function onResourceLoaded(resource:ImageResource):void
		{
			addChild(resource.bitmap);
		}
		
		
		/**
		 * onResourceFailed
		 */
		public function onResourceFailed(resource:ImageResource):void
		{
			
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			_testTextArea = new TextArea(0, 0, 300, 200);
			addChild(_testTextArea);
		}
		
		
		/**
		 * @inheritDoc
		 */
		override protected function enableChildren():void
		{
			_testTextArea.enabled = true;
		}
		
		
		/**
		 * @inheritDoc
		 */
		override protected function disableChildren():void
		{
			_testTextArea.enabled = false;
		}
		
		
		/**
		 * @inheritDoc
		 */
		override protected function pauseChildren():void
		{
		}
		
		
		/**
		 * @inheritDoc
		 */
		override protected function unpauseChildren():void
		{
		}
		
		
		/**
		 * @inheritDoc
		 */
		override protected function addEventListeners():void
		{
		}
		
		
		/**
		 * @inheritDoc
		 */
		override protected function removeEventListeners():void
		{
		}
		
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayText():void
		{
			_testTextArea.text = "A test text area!";
		}
		
		
		/**
		 * @inheritDoc
		 */
		override protected function layoutChildren():void
		{
			/* The UI component wouldn't redraw it's size until the next frame and
			 * our positioning of it would not be correct so let's validate it now
			 * so that it has the correct size before we position the test display. */
			_testTextArea.validateNow();
		}
	}
}
