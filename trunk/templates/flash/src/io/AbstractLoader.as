package io{	import util.Log;	import com.hexagonstar.env.event.FileIOEvent;	import com.hexagonstar.io.file.IFileIOEventListener;	import com.hexagonstar.io.file.QueueFileLoader;	import com.hexagonstar.util.debug.Debug;	import flash.events.EventDispatcher;	import flash.system.Capabilities;		/**	 * Provides common implementation for concrete loader classes.	 * @author Sascha Balkau	 */	public class AbstractLoader extends EventDispatcher implements IFileIOEventListener	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				protected var _loader:QueueFileLoader;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new AbstractLoader instance.		 */		public function AbstractLoader()		{			super();		}						/**		 * Starts the load process.		 * Abstract method! Subclasses should override and call super.load()!		 */		public function load():void		{			_loader = new QueueFileLoader();			_loader.addEventListenersFor(this);		}						/**		 * Disposes the loader.		 */		public function dispose():void		{			_loader.removeEventListenersFor(this);			_loader.dispose();			_loader = null;		}						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Abstract Method.		 */		public function onOpen(e:FileIOEvent):void		{			//Debug.trace(toString() + " Opened: " + e.file.path);		}				/**		 * Abstract Method.		 */		public function onProgress(e:FileIOEvent):void		{			//Debug.trace(toString() + " Load Progress: " + e.file.path);		}				/**		 * Abstract Method.		 */		public function onFileComplete(e:FileIOEvent):void		{			Log.debug(toString() + " Loaded: " + e.file.path);		}				/**		 * Abstract Method.		 */		public function onComplete(e:FileIOEvent):void		{			//Debug.trace(toString() + " onComplete");		}				/**		 * Abstract Method.		 */		public function onAbort(e:FileIOEvent):void		{			Debug.trace(toString() + " onAbort");		}				/**		 * Abstract Method.		 */		public function onPause(e:FileIOEvent):void		{			Debug.trace(toString() + " onPause");		}				/**		 * Abstract Method.		 */		public function onUnpause(e:FileIOEvent):void		{			Debug.trace(toString() + " onUnpause");		}				/**		 * Abstract Method.		 */		public function onHTTPStatus(e:FileIOEvent):void		{			var code:int = e.httpStatus;			if (code > 0)			{				var status:String = e.httpStatusInfo;				if (code > 399 && code < 600)					Log.warn(toString() + " HTTPStatus: " + status);				else					Log.debug(toString() + " HTTPStatus: " + status);			}		}				/**		 * Abstract Method.		 */		public function onIOError(e:FileIOEvent):void		{			notifyLoadError(e);		}				/**		 * Abstract Method.		 */		public function onSecurityError(e:FileIOEvent):void		{			notifyLoadError(e);		}						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @private		 */		protected function notifyLoadError(e:FileIOEvent):void		{			if (!Capabilities.isDebugger)			{				notifyError("Could not load \"" + e.file.path + "\" (" + e.text + ").");			}			else			{				notifyError(e.text);			}		}						/**		 * Abstract Method.		 * @private		 */		protected function notifyError(msg:String):void		{		}						/**		 * Trims whitespace from the start and end of the specified string.		 * @private		 */		protected function trim(s:String):String		{			return s.replace(/^[ \t]+|[ \t]+$/g, "");		}	}}