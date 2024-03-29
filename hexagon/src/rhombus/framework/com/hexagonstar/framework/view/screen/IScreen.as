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
package com.hexagonstar.framework.view.screen 
{
	import com.hexagonstar.framework.view.display.IDisplay;

	
	/**
	 * Interface for screen classes. Screens are like displays with the difference that
	 * they are automatically handled by the screen manager. Screens always occupy a
	 * whole screen for themselves and typically contain several displays as child
	 * objects.
	 * 
	 * @author Sascha Balkau
	 * @version 0.9.0
	 * 
	 * @see com.hexagonstar.framework.view.display.IDisplay
	 */
	public interface IScreen extends IDisplay
	{
	}
}
