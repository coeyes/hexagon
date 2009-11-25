package com.hexagonstar.event
{
	import com.hexagonstar.pattern.cmd.Command;

	import flash.events.Event;

	
	/**
	 * An event that is used to be broadcast from commands to indicate the
	 * state of the command.
	 */
	public class CommandEvent extends Event
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		
		public static const COMPLETE:String	= "commandComplete";
		public static const PROGRESS:String	= "commandProgress";
		public static const ABORT:String		= "commandAbort";
		public static const ERROR:String		= "commandError";
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		protected var _command:Command;
		protected var _message:String;
		protected var _progress:int;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new CommandEvent instance.
		 * 
		 * @param type The type string for the event.
		 * @param command The command this event is fired from.
		 * @param message The progress message of the command.
		 * @param progress The progress value of the command.
		 */
		public function CommandEvent(type:String,
										 command:Command,
										 message:String = null,
										 progress:int = -1)
		{
			super(type);
			
			_command = command;
			_message = message;
			_progress = progress;
		}
		
		
		/**
		 * Clones the event.
		 */
		override public function clone():Event
		{
			return new CommandEvent(type, _command, _message, _progress);
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @return The command that broadcasted the event.
		 */
		public function get command():Command
		{
			return _command;
		}
		
		
		/**
		 * @return For an error event the error message and for a progress event
		 *          the message string associated with the command progress.
		 */
		public function get message():String
		{
			return _message;
		}
		
		
		/**
		 * @return The progress value of the command.
		 */
		public function get progress():int
		{
			return _progress;
		}
	}
}
