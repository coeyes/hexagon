/* * rhombus - Application framework for web/desktop-based Flash & Flex projects. *  *  /\ RHOMBUS *  \/ FRAMEWORK *  * Licensed under the MIT License * Copyright (c) 2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.framework.view.screen{		/**	 * @author Sascha Balkau	 */	public class TestScreen extends AbstractScreen implements IScreen	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new instance.		 */		public function TestScreen()		{			super();		}						/**		 * load		 */		override public function load():void		{		}						/**		 * Activates the display's functionality.		 */		override public function activate():void		{		}						/**		 * Deactivates the display's functionality.		 */		override public function deactivate():void		{		}						/**		 * update		 */		override public function update():void		{			super.update();		}				/**		 * dispose		 */		override public function dispose():void		{			super.dispose();		}				////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * createChildren		 * @private		 */		override protected function createChildren():void		{		}						/**		 * Adds event listeners.		 * @private		 */		override protected function addEventListeners():void		{		}						/**		 * updateDisplayText		 * @private		 */		override protected function updateDisplayText():void		{		}						/**		 * layoutChildren		 * @private		 */		override protected function layoutChildren():void		{		}						/**		 * Removes event listeners.		 * @private		 */		override protected function removeEventListeners():void		{		}						/**		 * unload		 * @private		 */		override protected function unload():void		{		}	}}