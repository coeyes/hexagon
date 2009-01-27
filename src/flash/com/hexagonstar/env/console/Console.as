/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.env.console{	import com.hexagonstar.display.StageReference;	import com.hexagonstar.io.key.Key;	import com.hexagonstar.ui.containers.Pane;	import com.hexagonstar.ui.controls.TextArea;	import com.hexagonstar.ui.controls.TextInput;	import com.hexagonstar.ui.core.InvalidationType;		import flash.display.Stage;	import flash.events.Event;	import flash.events.KeyboardEvent;	import flash.text.StyleSheet;	import flash.ui.Keyboard;			/**	 * A Singleton class that represents a Debugging and Command output console similar	 * to that found in many later games. By default the console - once instantiated and	 * added to the stage - is hidden and can be toggled visible with the toggle() method.	 * 	 * StageReference.stage must be assigned before the console can be used.	 * 	 * TODO Add input back-buffer to recall already entered commands when	 * pressing cursor-up key.	 * 	 * @author Sascha Balkau	 */	public class Console extends Pane	{		////////////////////////////////////////////////////////////////////////////////////////		// Constants                                                                          //		////////////////////////////////////////////////////////////////////////////////////////				public static const LEVEL_DEBUG:int	= 0;		public static const LEVEL_INFO:int	= 1;		public static const LEVEL_WARN:int	= 2;		public static const LEVEL_ERROR:int	= 3;		public static const LEVEL_FATAL:int	= 4;				protected static const PADDING:int = 4;						////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				protected static var _instance:Console;				protected var _stage:Stage;		protected var _key:Key;		protected var _ta:TextArea;		protected var _ti:TextInput;		protected var _style:StyleSheet;		protected var _cli:CLI;				protected var _font:String = "mono";		protected var _fontSize:int = 12;		protected var _color:uint = 0xEEEEEE;		protected var _transparency:Number = 1.0;				protected var _heightDivider:int = 2;				protected var _useHTMLText:Boolean = true;		protected var _clearInput:Boolean = false;		//protected var _enabled:Boolean = true;		protected var _allowInput:Boolean;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new instance of the class.		 */		public function Console()		{			super();						if (_instance)			{				throw new Error("Tried to instantiate Console through"					+ " it's constructor. Use Console.instance instead!");			}						visible = false;						_stage = StageReference.stage;			_width = _stage.stageWidth;			_height = _stage.stageHeight / _heightDivider;						_cli = new CLI();						_stage.addEventListener(Event.RESIZE, onStageResize);						_key = Key.instance;			_key.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);			_key.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);		}						/**		 * Adds a new trace message to the console output area.		 * 		 * @param message the message to output.		 * @param level the output level (0-4).		 */		public function trace(message:String, level:int = 1):void		{			if (_enabled) add(message, level);		}						/**		 * Clears the console.		 */		public function clear():void		{			clearInput();			_ta.text = "";		}						/**		 * Clears the Text Input Line of the Console.		 */		public function clearInput():void		{			_ti.text = "";		}						/**		 * Toggles the console visibility.		 */		public function toggle():void		{			visible = !visible;		}						/**		 * Toggles the console height.		 */		public function toggleSize():void		{			if (_heightDivider == 2) _heightDivider = 1;			else _heightDivider = 2;			onStageResize();		}						/**		 * Sets the font face and font size that the console should use.		 * 		 * @param fontFace The font face for the console text.		 * @param fontSize The font size for the console text.		 */		public function setFont(fontFace:String, fontSize:int):void		{			//_ta.font = _ti.font = _font = fontFace;			//_ta.fontSize = _ti.fontSize = _fontSize = fontSize;			//createStyleSheet();			//invalidate();		}						/**		 * addCLICommand		 */		public function addCLICommand(command:CLICommand):void		{			_cli.addCommand(command);		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @return the Singleton instance of Console.		 */		public static function get instance():Console		{			if (!_instance) _instance = new Console();			return _instance;		}						/**		 * Gets / Sets whether the console uses HTML text or simple text.		 */		public function get useHTMLText():Boolean		{			return _useHTMLText;		}				public function set useHTMLText(v:Boolean):void		{			_useHTMLText = v;			invalidate();		}						/**		 * Toggles visibility of the console. If the console is made invisible		 * it's visible property is not only set to false but the console is also		 * moved off-screen.		 */		override public function set visible(v:Boolean):void		{			/* Only make visible if the console isn't disabled */			if (_enabled && v)			{				_allowInput = true;				super.visible = true;				y = 0;				_ti.focus();			}			else			{				_allowInput = false;				super.visible = false;				y = 0 - height;			}		}						/**		 * Determines if the console is completely disabled or not. If this		 * is set to false, console input and logging is disabled and the		 * console cannot be made visible.		 *///		public function get enabled():Boolean//		{//			return _enabled;//		}//		//		public function set enabled(v:Boolean):void//		{//			_enabled = v;//			if (!v) clear();//		}						/**		 * Gets/sets the alpha transparency of the console's background.		 */		public function get transparency():Number		{			return _transparency;		}				public function set transparency(v:Number):void		{			if (v > 1) v = 1;			else if (v < 0) v = 0;						_transparency = v;			invalidate();		}						/**		 * Gets/sets the command handler class used for the Console's CLI.		 */		public function get cliCommandHandler():ICLICommandHandler		{			return _cli.commandHandler;		}				public function set cliCommandHandler(v:ICLICommandHandler):void		{			_cli.commandHandler = v;		}						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @private		 */		protected function onTextInputChange(e:Event):void		{			if (_allowInput)			{				if (_clearInput)				{					_clearInput = false;					clearInput();				}			}		}						/**		 * @private		 */		protected function onKeyDown(e:KeyboardEvent):void		{			if (_allowInput)			{				if (e.keyCode == Keyboard.ENTER)				{					if (_ti.text.length > 0)					{						_cli.processInput(_ti.text);						_clearInput = true;					}				}			}		}						/**		 * @private		 */		protected function onKeyUp(e:KeyboardEvent):void		{		}						/**		 * @private		 */		protected function onStageResize(e:Event = null):void		{			width = _stage.stageWidth;			height = _stage.stageHeight / _heightDivider;			invalidate(InvalidationType.SIZE);		}				////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @private		 */		override protected function configUI():void		{			super.configUI();						createStyleSheet();						_ti = new TextInput();			_ti.focusEnabled = false;			_ti.addEventListener(Event.CHANGE, onTextInputChange);						_ta = new TextArea();			_ta.editable = false;			_ta.focusEnabled = false;						addChild(_ta);			addChild(_ti);		}						/**		 * Draws the visual UI of the component. This method is always invoked		 * one frame after an invalidate() call.		 * @private		 */		override protected function drawLayout():void		{			super.drawLayout();						//_bg.draw(_width, _height, 0x222222, _transparency);						_ti.width = _width - (PADDING * 2);			_ti.height = 22;			_ti.x = PADDING;			_ti.y = _height - _ti.height - PADDING;			//_ti.font = _font;			//_ti.fontSize = _fontSize;			//_ti.color = _color;			//_ti.transparency = _transparency;			_ti.drawNow();						_ta.width = _ti.width;			_ta.x = _ti.x;			_ta.y = PADDING;			_ta.height = _height - _ti.height - (PADDING * 3);			_ta.drawNow();						if (_useHTMLText)			{				//_ta.styleSheet = _style;				//_ta.isHTML = true;			}			else			{				//_ta.styleSheet = null;				//_ta.isHTML = false;			}						//filters = (_hasShadow) ? [createShadow(2)] : [];		}						/**		 * createStyleSheet		 * @private		 */		protected function createStyleSheet():void		{			_style = new StyleSheet();			with (_style)			{				setStyle("body", {fontFamily: _font, fontSize: _fontSize, color: "#EEEEEE"});				setStyle("l0", {fontFamily: _font, fontSize: _fontSize, color: "#A0A0FF"});				setStyle("l1", {fontFamily: _font, fontSize: _fontSize, color: "#EEEEEE"});				setStyle("l2", {fontFamily: _font, fontSize: _fontSize, color: "#FFD400"});				setStyle("l3", {fontFamily: _font, fontSize: _fontSize, color: "#FF7F00"});				setStyle("l4", {fontFamily: _font, fontSize: _fontSize, color: "#FF0000"});			}		}						/**		 * Internal add method.		 * @private		 */		protected function add(message:String, level:int = 1):void		{			message = "> " + message;						if (_useHTMLText)			{				_ta.text += "<l" + level + ">" + convertTags(message) + "</l" + level + ">";			}			else			{				_ta.text += message + "\n";			}						_ta.updateScrolling();		}						/**		 * Converts all occurances of HTML special characters and braces.		 * @private		 * 		 * @param s String to convert Tags in.		 * @param stripCRs true if CR's should be stripped from String.		 */		protected function convertTags(s:String, stripCRs:Boolean = false):String		{			if (stripCRs) s = s.replace(/\\r/g, "");			return s.replace(/&amp;/gi, "&amp;amp;")				.replace(/&quot;/gi, "&amp;quot;")				.replace(/&lt;/gi, "&amp;lt;")				.replace(/&gt;/gi, "&amp;gt;")				.replace(/</gi, "&lt;")				.replace(/>/gi, "&gt;");		}	}}