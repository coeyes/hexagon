package com.hexagonstar.flex.util
{
	public class Constant
	{
		//[Embed(source="../assets/cursor_mouseMove.png")]
		//public static const CURSOR_MOVE:Class;
		[Embed(source="../assets/cursor_verticalResize.png")]
		public static const VERTICAL_SIZE:Class;
		[Embed(source="../assets/cursor_horizontalResize.png")]
		public static const HORIZONTAL_SIZE:Class;
		[Embed(source="../assets/cursor_leftObliqueResize.png")]
		public static const LEFT_OBLIQUE_SIZE:Class;
		[Embed(source="../assets/cursor_rightObliqueResize.png")]
		public static const RIGHT_OBLIQUE_SIZE:Class;
		
		[Embed(source="../assets/WindowMinButton.gif")]
		public static const WINDOW_MIN_BUTTON_1:Class;
		[Embed(source="../assets/WindowMinButton2.gif")]
		public static const WINDOW_MIN_BUTTON_2:Class;
		[Embed(source="../assets/WindowMaxButton.gif")]
		public static const WINDOW_MAX_BUTTON_1:Class;
		[Embed(source="../assets/WindowMaxButton2.gif")]
		public static const WINDOW_MAX_BUTTON_2:Class;
		[Embed(source="../assets/WindowCloseButton.gif")]
		public static const WINDOW_CLOSE_BUTTON_1:Class;
		[Embed(source="../assets/WindowCloseButton2.gif")]
		public static const WINDOW_CLOSE_BUTTON_2:Class;
		
		public static const SIDE_OTHER:Number	= 0;
		public static const SIDE_TOP:Number		= 1;
		public static const SIDE_BOTTOM:Number	= 2;
		public static const SIDE_LEFT:Number		= 4;
		public static const SIDE_RIGHT:Number	= 8;
		
		public static const TARGET_TAB_INDEX:String		= "targetTabIndex";
		
		public static const RESIZE_OLD_POINT:String		= "oldPoint";
		public static const RESIZE_OLD_HEIGHT:String		= "oldHeight";
		public static const RESIZE_OLD_WIDTH:String		= "oldWidth";
		public static const RESIZE_OLD_X:String			= "oldX";
		public static const RESIZE_OLD_Y:String			= "oldY";
		public static const RESIZE_MIN_SIZE:String		= "minSize";
		public static const RESIZE_IS_POPUPE:String		= "isPopup";
	}
}
