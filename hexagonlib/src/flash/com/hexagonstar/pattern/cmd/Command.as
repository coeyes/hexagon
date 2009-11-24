package com.hexagonstar.pattern.cmd{	import com.hexagonstar.event.CommandEvent;	import flash.events.EventDispatcher;	import flash.utils.getQualifiedClassName;		/**	 * Abstract class for command implementations. A command encapsulates code that can be	 * instantiated and executed anywhere else in the application.<p>Commands can either be	 * executed without event listening if their execution code is processed synchronous or	 * a command can be listened to for events that are broadcasted by the command when the	 * it completes, an error occurs or during command progress steps.	 * 	 * @author Sascha Balkau	 */	public class Command extends EventDispatcher	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				/** @private */		protected var _listener:ICommandListener;		/** @private */		protected var _isAborted:Boolean;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new Command instance.		 */		public function Command()		{			super();		}						/**		 * Executes the command. In sub-classed commands you should override this		 * method, make a call to super.execute and then initiate all your command's		 * execution implementation from here.		 */ 		public function execute():void		{			_isAborted = false;		}						/**		 * Aborts the command's execution. Any sub-classed implementation needs		 * to take care of abort functionality by checking the _aborted property.		 */		public function abort():void		{			_isAborted = true;		}						/**		 * Returns a string representation of the command.		 * @return A string representation of the command.		 */		override public function toString():String		{			return "[" + getQualifiedClassName(this).match("[^:]*$")[0]				+ ", name=" + name + "]";		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * returns the name identifier of the command. Names are mainly used for the		 * command to be identified when it should be able to be executed through the CLI.		 * This is an abstract method which needs to be overriden in sub classes to		 * give it a unique command name.		 * 		 * @return the name identifier of the command.		 */		public function get name():String		{			return "command";		}						/**		 * Gets or sets the object that listens to events fired by this command. This		 * can be used as a shortcut. The listener has to implement the ICommandListener		 * interface to be able to use this.		 * 		 * @return The object that listens to events fired by this command.		 */		public function get listener():ICommandListener		{			return _listener;		}		public function set listener(v:ICommandListener):void		{			_listener = v;		}						/**		 * Gets the abort state of the command.		 */		public function get isAborted():Boolean		{			return _isAborted;		}						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Notifies listeners that the command has completed.		 * 		 * @private		 */		protected function notifyComplete():void		{			dispatchEvent(new CommandEvent(CommandEvent.COMPLETE, this));		}						/**		 * Notifies listeners that the command was aborted.		 * 		 * @private		 */		protected function notifyAbort():void		{			dispatchEvent(new CommandEvent(CommandEvent.ABORT, this));		}						/**		 * Notifies listeners that an error has occured while executing the command.		 * 		 * @private		 * @param errorMsg The error message to be broadcasted with the event.		 */		protected function notifyError(errorMsg:String):void		{			dispatchEvent(new CommandEvent(CommandEvent.ERROR, this, errorMsg));		}						/**		 * Completes the command. This is an abstract method that needs to be overridden		 * by subclasses. You put code here that should be executed when the command		 * finishes, like cleaning up event listeners etc. After your code, place a call		 * to super.complete().		 * 		 * @private		 */		protected function complete():void		{			if (!_isAborted) notifyComplete();			else notifyAbort();		}	}}