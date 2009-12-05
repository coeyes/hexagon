/* * rhombus - Application framework for web/desktop-based Flash & Flex projects. *  *  /\ RHOMBUS *  \/ FRAMEWORK *  * Licensed under the MIT License * Copyright (c) 2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.framework.view.console{	import com.hexagonstar.display.StageReference;	import com.hexagonstar.display.ui.containers.Pane;	import com.hexagonstar.display.ui.controls.TextArea;	import com.hexagonstar.display.ui.controls.TextInput;	import com.hexagonstar.display.ui.core.InvalidationType;	import com.hexagonstar.display.ui.event.UIComponentEvent;	import com.hexagonstar.framework.env.cli.CLI;	import com.hexagonstar.framework.env.cli.CLICommand;	import com.hexagonstar.framework.env.cli.CLICommandInvoker;	import com.hexagonstar.util.FontUtil;	import flash.display.Stage;	import flash.events.Event;	import flash.text.StyleSheet;	import flash.text.TextFormat;		/**	 * A Singleton class that represents a Debugging and Command output console similar	 * to that found in many later games. By default the console - once instantiated and	 * added to the stage - is hidden and can be toggled visible with the toggle() method.	 * 	 * StageReference.stage must be assigned before the console can be used.	 * 	 * @author Sascha Balkau	 * @version 0.9.8	 */	public class Console extends Pane	{		////////////////////////////////////////////////////////////////////////////////////////		// Constants                                                                          //		////////////////////////////////////////////////////////////////////////////////////////				public static const LEVEL_TRACE:int	= 0;		public static const LEVEL_DEBUG:int	= 1;		public static const LEVEL_INFO:int	= 2;		public static const LEVEL_WARN:int	= 3;		public static const LEVEL_ERROR:int	= 4;		public static const LEVEL_FATAL:int	= 5;				public static const CONSOLE_FONTS:Array = ["Consolas", "Andale Mono", "Courier New"];				/** @private */		protected static const PADDING:int = 4;						////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				/** @private */		protected static var _instance:Console;		/** @private */		protected static var _singletonLock:Boolean = false;				/** @private */		protected var _stage:Stage;		/** @private */		protected var _ta:TextArea;		/** @private */		protected var _ti:TextInput;		/** @private */		protected var _style:StyleSheet;		/** @private */		protected var _cli:CLI;		/** @private */		protected var _backBuffer:BackBuffer;				/** @private */		protected var _font:String;		/** @private */		protected var _fontSize:int = 12;		/** @private */		protected var _color:uint = 0xEEEEEE;				/** @private */		protected var _heightDivider:int = 2;		/** @private */		protected var _maxBufferSize:int = 40000;				/** @private */		protected var _useHTMLText:Boolean = true;		/** @private */		protected var _consoleEnabled:Boolean = true;		/** @private */		protected var _allowInput:Boolean;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new instance of the class.		 */		public function Console()		{			super();						if (!_singletonLock)			{				throw new Error("Tried to instantiate Console through"					+ " it's constructor. Use Console.instance instead!");			}						visible = false;						_stage = StageReference.stage;			_width = _stage.stageWidth;			_height = _stage.stageHeight / _heightDivider;						_cli = new CLI();			_backBuffer = new BackBuffer();						_stage.addEventListener(Event.RESIZE, onStageResize);		}						/**		 * Adds a new log message to the console output area.		 * 		 * @param message the message to output.		 * @param level the output level (0-5).		 */		public function log(message:String, level:int = 2):void		{			if (_consoleEnabled) add(message, level);		}						/**		 * Clears the console.		 */		public function clear():void		{			clearInput();			_ta.clear();						/* humm, for now let's not clear the backbuffer if we clear the console! */			//_backBuffer.clear();		}				/**		 * Clears the Text Input Line of the Console.		 */		public function clearInput():void		{			_ti.clear();		}						/**		 * Toggles the console visibility.		 */		public function toggle():void		{			visible = !visible;		}						/**		 * Toggles the console height.		 */		public function toggleSize():void		{			// TODO There's still a bug that the scrollbar doesn't			// update correctly when toggling console size!						if (_heightDivider == 2) _heightDivider = 1;			else _heightDivider = 2;			onStageResize();		}						/**		 * Sets the font face and font size that the console should use. If the font		 * is not available on the system, it falls back to a ist of preferred fonts.		 * These are "Consolas", "Andale Mono", "Courier New" and "mono".		 * 		 * @param fontFace The font face for the console text.		 * @param fontSize The font size for the console text.		 */		public function setFont(fontFace:String = null, fontSize:int = 0):void		{			/* Check if font name was specified and if it's available on the system. */			if (fontFace && FontUtil.isFontAvailable(fontFace, true))			{				_font = fontFace;			}			else			{				/* Font face not found, try to choose preferred font faces fisrt. */				for each (var s:String in CONSOLE_FONTS)				{					if (FontUtil.isFontAvailable(s, true))					{						_font = s;						break;					}				}								/* If none of the preferred font faces are available, fall back to mono. */				if (!_font)				{					_font = "mono";				}			}						if (fontSize > 0)			{				_fontSize = fontSize;			}						_ti.setStyle("embedFonts", false);			_ta.setStyle("embedFonts", false);						var f:TextFormat = new TextFormat(_font, _fontSize, _color);			_ti.setStyle("textFormat", f);			_ti.setStyle("textDisabledFormat", f);			_ti.setStyle("textDefaultFormat", f);			_ti.setStyle("textDefaultDisabledFormat", f);						if (_useHTMLText)			{				createStyleSheet();				_ta.styleSheet = _style;			}			else			{				_ta.styleSheet = null;				_ta.setStyle("textFormat", f);				_ta.setStyle("textDisabledFormat", f);				_ta.setStyle("textDefaultFormat", f);				_ta.setStyle("textDefaultDisabledFormat", f);			}						_ti.drawNow();			_ta.drawNow();		}						/**		 * addCLICommand		 */		public function addCLICommand(command:CLICommand):void		{			_cli.addCommand(command);		}		
		
		////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @return the Singleton instance of Console.		 */		public static function get instance():Console		{			if (_instance == null)			{				_singletonLock = true;				_instance = new Console();				_singletonLock = false;			}			return _instance;		}						/**		 * Returns the command line interpreter that is used by the console to		 * execute commands.		 */		public static function get cli():CLI		{			return _instance._cli;		}						/**		 * Gets / Sets whether the console uses HTML text or simple text.		 */		public function get useHTMLText():Boolean		{			return _useHTMLText;		}		public function set useHTMLText(v:Boolean):void		{			_useHTMLText = v;			//invalidate();		}						/**		 * Toggles visibility of the console. If the console is made invisible		 * it's visible property is not only set to false but the console is also		 * moved off-screen.		 */		override public function set visible(v:Boolean):void		{			/* Only make visible if the console isn't disabled */			if (_consoleEnabled && v)			{				_allowInput = true;				super.visible = true;				y = 0;				_ti.focus();			}			else			{				_allowInput = false;				super.visible = false;				y = 0 - height;			}		}						/**		 * Determines if the console is completely disabled or not. If this		 * is set to false, console input and logging is disabled and the		 * console cannot be made visible.		 */		public function get consoleEnabled():Boolean		{			return _consoleEnabled;		}		public function set consoleEnabled(v:Boolean):void		{			_consoleEnabled = v;			if (!v) clear();		}						/**		 * Gets/sets the command invoker class used for the Console's CLI.		 */		public function get cliCommandInvoker():CLICommandInvoker		{			return _cli.commandInvoker;		}		public function set cliCommandInvoker(v:CLICommandInvoker):void		{			v.console = this;			_cli.commandInvoker = v;		}						/**		 * The max. text buffer size used for the console. If this value is		 * exceeded the console will clear it's buffer to prevent lag.		 */		public function get maxBufferSize():int		{			return _maxBufferSize;		}		public function set maxBufferSize(v:int):void		{			_maxBufferSize = v;		}						/**		 * Returns the console's currently occupied buffer size.		 */		public function get bufferSize():int		{			return _ta.length;		}						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @private		 */		protected function onTextInputChange(e:Event):void		{			if (_allowInput)			{			}		}						/**		 * @private		 */		protected function onTextInputEnter(e:UIComponentEvent):void		{			if (_allowInput)			{				if (_ti.text.length > 0)				{					_backBuffer.push(_ti.text);					_cli.processInput(_ti.text);					clearInput();				}			}		}						/**		 * @private		 */		protected function onTextInputCursorUp(e:UIComponentEvent):void		{			if (_backBuffer.hasPrevious)			{				_ti.text = _backBuffer.previous;			}		}						/**		 * @private		 */		protected function onTextInputCursorDown(e:UIComponentEvent):void		{			if (_backBuffer.hasNext)			{				_ti.text = _backBuffer.next;			}		}						/**		 * @private		 */		protected function onStageResize(e:Event = null):void		{			_width = _stage.stageWidth;			_height = _stage.stageHeight / _heightDivider;			invalidate(InvalidationType.SIZE);		}						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @private		 */		override protected function configUI():void		{			super.configUI();						_ti = new TextInput();			_ti.textSharpness = 50;			_ti.textThickness = 50;			_ti.useSkin = false;			_ti.addEventListener(Event.CHANGE, onTextInputChange);			_ti.addEventListener(UIComponentEvent.ENTER, onTextInputEnter);			_ti.addEventListener(UIComponentEvent.CURSOR_UP, onTextInputCursorUp);			_ti.addEventListener(UIComponentEvent.CURSOR_DOWN, onTextInputCursorDown);						_ta = new TextArea();			_ta.textSharpness = 50;			_ta.textThickness = 50;			_ta.editable = false;			_ta.useSkin = false;						addChild(_ta);			addChild(_ti);						setFont();		}						/**		 * Draws the visual UI of the component. This method is always invoked		 * one frame after an invalidate() call.		 * @private		 */		override protected function drawLayout():void		{			super.drawLayout();						_ti.width = _width - (PADDING * 2);			_ti.height = 20;			_ti.x = PADDING;			_ti.y = _height - _ti.height - PADDING;			_ti.drawNow();						_ta.width = _ti.width;			_ta.x = _ti.x;			_ta.y = PADDING;			_ta.height = _height - _ti.height - (PADDING * 3);			_ta.drawNow();		}						/**		 * createStyleSheet		 * @private		 */		protected function createStyleSheet():void		{			_style = new StyleSheet();			with (_style)			{				setStyle("body", {fontFamily: _font, fontSize: _fontSize, color: "#FFFFFF"});				setStyle("l0", {fontFamily: _font, fontSize: _fontSize, color: "#BBBBBB"});				setStyle("l1", {fontFamily: _font, fontSize: _fontSize, color: "#CCCCCC"});				setStyle("l2", {fontFamily: _font, fontSize: _fontSize, color: "#FFFFFF"});				setStyle("l3", {fontFamily: _font, fontSize: _fontSize, color: "#FFD400"});				setStyle("l4", {fontFamily: _font, fontSize: _fontSize, color: "#FF7F00"});				setStyle("l5", {fontFamily: _font, fontSize: _fontSize, color: "#FF0000"});			}		}						/**		 * Internal add method.		 * @private		 */		protected function add(message:String, level:int = 1):void		{			if (_ta.length >= _maxBufferSize)			{				_ta.clear();			}						message = "> " + message;						if (_useHTMLText)			{				_ta.htmlText += "<l" + level + ">" + convertTags(message) + "</l" + level + ">";			}			else			{				_ta.appendText(message + "\n");			}						_ta.updateScrolling();		}						/**		 * Converts all occurances of HTML special characters and braces.		 * @private		 * 		 * @param s String to convert Tags in.		 * @param stripCRs true if CR's should be stripped from String.		 */		protected function convertTags(s:String, stripCRs:Boolean = false):String		{			if (stripCRs) s = s.replace(/\\r/g, "");			return s.replace(/&amp;/gi, "&amp;amp;")				.replace(/&quot;/gi, "&amp;quot;")				.replace(/&lt;/gi, "&amp;lt;")				.replace(/&gt;/gi, "&amp;gt;")				.replace(/</gi, "&lt;")				.replace(/>/gi, "&gt;");		}	}}/** * @private */class BackBuffer{	////////////////////////////////////////////////////////////////////////////////////////	// Properties                                                                         //	////////////////////////////////////////////////////////////////////////////////////////		private var _buffer:Vector.<String>;	private var _bufferSize:int = 100;	private var _currentIndex:int;			////////////////////////////////////////////////////////////////////////////////////////	// Public Methods                                                                     //	////////////////////////////////////////////////////////////////////////////////////////		public function BackBuffer()	{		clear();	}			/**	 * push	 */	public function push(string:String):void	{		/* check if buffer is full */		if (_buffer.length > 0 && _buffer.length == _bufferSize)		{			_buffer.shift();		}				/* trim (obsolete, we go with a simple backbuffer!) */		//if (current && string == current)		//{		//	_buffer.splice(_currentIndex, _buffer.length - _currentIndex);		//}				/* add new one */		_buffer.push(string);		_currentIndex = _buffer.length;	}		/**	 * clear	 */	public function clear():void	{		_buffer = new Vector.<String>();		_currentIndex = 0;	}			////////////////////////////////////////////////////////////////////////////////////////	// Getters & Setters                                                                  //	////////////////////////////////////////////////////////////////////////////////////////		public function get hasPrevious():Boolean	{		return _currentIndex > 0;	}			public function get previous():String	{		if (!hasPrevious) return null;		_currentIndex--;		return _buffer[_currentIndex];	}			public function get hasNext():Boolean	{		return _currentIndex < _buffer.length - 1;	}			public function get next():String	{		if (!hasNext) return null;		_currentIndex++;		return _buffer[_currentIndex];	}			public function get current():String	{		if (_buffer.length == 0) return null;		var ci:int = (_currentIndex - 1 < 0) ? 0 : _currentIndex - 1;		return _buffer[ci];	}}