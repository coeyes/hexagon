package view 
{
	/**
	 * IView interface
	 * @author Sascha Balkau <sascha@hexagonstar.com>
	 */
	public interface IView 
	{
		function init():void;
		function update():void;
		function dispose():void;
		function toString():String;
	}
}
