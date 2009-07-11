package util{	import com.hexagonstar.display.StageReference;	import flash.display.Sprite;	import flash.events.Event;	import flash.events.TimerEvent;	import flash.filters.GlowFilter;	import flash.system.System;	import flash.text.AntiAliasType;	import flash.text.TextField;	import flash.text.TextFormat;	import flash.text.TextFormatAlign;	import flash.utils.Timer;	import flash.utils.getTimer;		/**	 * @author Sascha Balkau	 */	public class FPSMonitor extends Sprite	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				protected static var _instance:FPSMonitor;		protected static var _singletonLock:Boolean = false;				protected var _fpsTextField:TextField;		protected var _memTextField:TextField;				protected var _timer:Timer;		protected var _fps:int;		protected var _defaultFPS:int;				protected var _delay:int;		protected var _delayMax:int = 10;		protected var _prev:int;				protected var _pollInterval:Number = 1.0;		protected var _isRunning:Boolean;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new instance of the class.		 */		public function FPSMonitor()		{			if (!_singletonLock)			{				throw new Error("Tried to instantiate FPSMonitor through it's constructor."					+ " Use FPSMonitor.instance instead!");			}						setup();		}						/**		 * Starts the FPS Monitor.		 */		public function start():void		{			if (!_isRunning)			{				_isRunning = true;				_timer = new Timer((_pollInterval * 1000), 0);				_timer.addEventListener(TimerEvent.TIMER, onTimer);				StageReference.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);				_timer.start();				onTimer(null);				visible = true;			}		}						/**		 * Stops the FPS Monitor.		 */		public function stop():void		{			if (_isRunning)			{				visible = false;				_timer.stop();				_timer.removeEventListener(TimerEvent.TIMER, onTimer);				StageReference.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);				_timer = null;				reset();			}		}						/**		 * Resets the FPSMeter to it's default state.		 */		public function reset():void		{			_fps = 0;			_defaultFPS = StageReference.stage.frameRate;			_delay = 0;			_prev = 0;			_isRunning = false;		}						/**		 * toggle		 */		public function toggle():void		{			if (_isRunning) stop();			else start();		}						/**		 * Disposes FPSMonitor.		 */		public function dispose():void		{			stop();			removeEventListeners();		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Returns the Singleton instance of FPSMonitor.		 */		public static function get instance():FPSMonitor		{			if (_instance == null)			{				_singletonLock = true;				_instance = new FPSMonitor();				_singletonLock = false;			}			return _instance;		}						/**		 * The poll interval of the fps monitor in seconds.		 */		public function get pollInterval():Number		{			return _pollInterval;		}		public function set pollInterval(v:Number):void		{			_pollInterval = v;		}						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @private		 */		protected function onTimer(e:TimerEvent):void		{			if (_fps > _defaultFPS) _fps = _defaultFPS;			_fpsTextField.text = _fps + "/" + _defaultFPS;			_memTextField.text = formatBytes(System.totalMemory);		}				/**		 * @private		 */		protected function onEnterFrame(e:Event):void		{			var t:int = getTimer();			_delay++;						if (_delay >= _delayMax)			{				_delay = 0;				_fps = int((1000 * _delayMax) / (t - _prev));				_prev = t;			}		}						protected function onStageResize(e:Event):void		{			x = StageReference.stage.stageWidth - width - 12;		}						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * setup		 * @private		 */		protected function setup():void		{			visible = false;			createChildren();			addEventListeners();			onStageResize(null);			reset();		}						/**		 * createChildren		 * @private		 */		protected function createChildren():void		{			var format:TextFormat = new TextFormat();			format.font = EmbeddedAssets.fontConsolas.fontName;			format.size = 20;			format.color = 0xFFFFFF;			format.bold = true;			format.align = TextFormatAlign.RIGHT;						_fpsTextField = new TextField();			_fpsTextField.width = 90;			_fpsTextField.height = 26;			_fpsTextField.defaultTextFormat = format;			_fpsTextField.embedFonts = true;			_fpsTextField.antiAliasType = AntiAliasType.ADVANCED;			_fpsTextField.selectable = false;			addChild(_fpsTextField);						format.size = 11;						_memTextField = new TextField();			_memTextField.width = 90;			_memTextField.height = 16;			_memTextField.defaultTextFormat = format;			_memTextField.embedFonts = true;			_memTextField.antiAliasType = AntiAliasType.ADVANCED;			_memTextField.selectable = false;			_memTextField.y = _fpsTextField.height - 4;			addChild(_memTextField);						var f:GlowFilter = new GlowFilter(0x000000, 1.0, 4, 4, 1000, 1);			filters = [f];						y = 10;		}						/**		 * addEventListeners		 * @private		 */		protected function addEventListeners():void		{			StageReference.stage.addEventListener(Event.RESIZE, onStageResize);		}						/**		 * removeEventListeners		 * @private		 */		protected function removeEventListeners():void		{			StageReference.stage.removeEventListener(Event.RESIZE, onStageResize);		}						/**		 * formatBytes		 * @private		 */		protected function formatBytes(bytes:int):String		{			var r:String;			if (bytes < 0x0400)			{				r = (String(bytes) + "b");			}			else 			{				if (bytes < 0x2800)				{					r = (Number((bytes / 0x0400)).toFixed(2) + "kb");				}				else 				{					if (bytes < 102400)					{						r = (Number((bytes / 0x0400)).toFixed(1) + "kb");					}					else 					{						if (bytes < 0x100000)						{							r = ((bytes >> 10) + "kb");						}						 else 						{							if (bytes < 0xA00000)							{								r = (Number((bytes / 0x100000)).toFixed(2) + "mb");							}							 else 							{								if (bytes < 104857600)								{									r = (Number((bytes / 0x100000)).toFixed(1) + "mb");								}								else 								{									r = ((bytes >> 20) + "mb");								}							}						}					}				}			}			return r;		}	}}