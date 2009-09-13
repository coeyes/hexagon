/*
 * hexagonlib - Multi-Purpose ActionScript 3 Library.
 *       __    __
 *    __/  \__/  \__    __
 *   /  \__/HEXAGON \__/  \
 *   \__/  \__/  LIBRARY _/
 *            \__/  \__/
 *
 * Licensed under the MIT License
 * 
 * Copyright (c) 2007-2008 Sascha Balkau / Hexagon Star Softworks
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
package com.hexagonstar.ui.controls.listclasses 
{
	import com.hexagonstar.ui.controls.LabelButton;

	import flash.events.MouseEvent;

	//--------------------------------------
	//  Styles
	//--------------------------------------
	/**
	 * @copy fl.controls.LabelButton#style:upSkin
	 *
	 * @default CellRenderer_upSkin
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	[Style(name="upSkin", type="Class")]

	/**
	 * @copy fl.controls.LabelButton#style:downSkin
	 *
	 * @default CellRenderer_downSkin
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	[Style(name="downSkin", type="Class")]

	/**
	 *  @copy fl.controls.LabelButton#style:overSkin
	 *
	 *  @default CellRenderer_overSkin
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	[Style(name="overSkin", type="Class")]

	/**
	 *  @copy fl.controls.LabelButton#style:disabledSkin
	 *
	 *  @default CellRenderer_disabledSkin
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	[Style(name="disabledSkin", type="Class")]

	/**
	 *  @copy fl.controls.LabelButton#style:selectedDisabledSkin
	 *
	 *  @default CellRenderer_selectedDisabledSkin
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	[Style(name="selectedDisabledSkin", type="Class")]

	/**
	 *  @copy fl.controls.LabelButton#style:selectedUpSkin
	 *
	 *  @default CellRenderer_selectedUpSkin
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	[Style(name="selectedUpSkin", type="Class")]

	/**
	 *  @copy fl.controls.LabelButton#style:selectedDownSkin
	 *
	 *  @default CellRenderer_selectedDownSkin
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	[Style(name="selectedDownSkin", type="Class")]

	/**
	 *  @copy fl.controls.LabelButton#style:selectedOverSkin
	 *
	 *  @default CellRenderer_selectedOverSkin
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	[Style(name="selectedOverSkin", type="Class")]

	/**
	 *  @copy fl.core.UIComponent#style:textFormat
	 *
	 *  @default null
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	[Style(name="textFormat", type="flash.text.TextFormat")]

	/**
	 *  @copy fl.core.UIComponent#style:disabledTextFormat
	 *
	 *  @default null
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	[Style(name="disabledTextFormat", type="flash.text.TextFormat")]

	/**
	 *  @copy fl.controls.LabelButton#style:textPadding
	 *
	 *  @default 5
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	[Style(name="textPadding", type="Number", format="Length")]

	
	//--------------------------------------
	//  Class description
	//--------------------------------------
	/**
	 * The CellRenderer class defines methods and properties for  
	 * list-based components to use to manipulate and display custom 
	 * cell content in each of their rows. A customized cell can contain
	 * text, an existing component such as a CheckBox, or any class that 
	 * you create. The list-based components that use this class include 
	 * the List, DataGrid, TileList, and ComboBox components.
	 *
	 * @see ICellRenderer
	 *
	 * @includeExample examples/CellRendererExample.as
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	public class CellRenderer extends LabelButton implements ICellRenderer 
	{
		/**
		 * @private (protected)
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		protected var _listData:ListData;
		/**
		 * @private (protected)
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		protected var _data:Object;

		
		/**
		 * Creates a new CellRenderer instance.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public function CellRenderer():void 
		{
			super();
			toggle = true;
			focusEnabled = false;
		}

		
		/**
		 * @private
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		private static var defaultStyles:Object = {upSkin:"CellRenderer_upSkin", downSkin:"CellRenderer_downSkin", overSkin:"CellRenderer_overSkin", disabledSkin:"CellRenderer_disabledSkin", selectedDisabledSkin:"CellRenderer_selectedDisabledSkin", selectedUpSkin:"CellRenderer_selectedUpSkin", selectedDownSkin:"CellRenderer_selectedDownSkin", selectedOverSkin:"CellRenderer_selectedOverSkin", textFormat:null, disabledTextFormat:null, embedFonts:null, textPadding:5};

		
		/**
		 * @copy fl.core.UIComponent#getStyleDefinition()
		 *
		 * @includeExample ../../core/examples/UIComponent.getStyleDefinition.1.as -noswf
		 *
		 * @see fl.core.UIComponent#getStyle()
		 * @see fl.core.UIComponent#setStyle()
		 * @see fl.managers.StyleManager
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public static function get styleDefinition():Object 
		{ 
			return defaultStyles; 
		}

		
		/**
		 * Specifies the dimensions at which the data should be rendered. 
		 * These dimensions affect both the data and the cell that contains it; 
		 * the cell renderer uses them to ensure that the data fits the cell and 
		 * does not bleed into adjacent cells. 
		 *
		 * @param width The width of the object, in pixels.
		 *
		 * @param height The height of the object, in pixels.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		override public function setSize(width:Number,height:Number):void 
		{
			super.setSize(width, height);
		}

		
		/**
		 * @copy fl.controls.listClasses.ICellRenderer#listData
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public function get listData():ListData 
		{
			return _listData;
		}	

		
		/**
		 * @private (setter)
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public function set listData(value:ListData):void 
		{
			_listData = value;
			label = _listData.label;
			setStyle("icon", _listData.icon);
		}

		
		/**
		 * @copy fl.controls.listClasses.ICellRenderer#data
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public function get data():Object 
		{
			return _data;
		}		

		
		/**
		 * @private (setter)
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public function set data(value:Object):void 
		{
			_data = value;
		}

		
		/**
		 * @copy fl.controls.listClasses.ICellRenderer#selected
		 *
		 * @default false
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		override public function get selected():Boolean 
		{
			return super.selected;
		}

		
		/**
		 * @private (setter)
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		override public function set selected(value:Boolean):void 
		{
			super.selected = value;
		}

		
		/**
		 * @private (protected)
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		override protected function onToggleSelected(e:MouseEvent):void 
		{
			// don't set selected or dispatch change event.
		}

		
		/**
		 * @private (protected)
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		override protected function drawLayout():void 
		{
			var textPadding:Number = Number(getStyleValue("textPadding"));
			var textFieldX:Number = 0;
			
			// Align icon
			if (_icon != null) 
			{
				_icon.x = textPadding;
				_icon.y = Math.round((height - _icon.height) >> 1);
				textFieldX = _icon.width + textPadding;
			}
			
			// Align text
			if (label.length > 0) 
			{
				_tf.visible = true;
				var textWidth:Number = Math.max(0, width - textFieldX - textPadding * 2);
				_tf.width = textWidth;
				_tf.height = _tf.textHeight + 4;
				_tf.x = textFieldX + textPadding;
				_tf.y = Math.round((height - _tf.height) >> 1);
			} 
			else 
			{
				_tf.visible = false;
			}
			
			// Size background
			_bg.width = width;
			_bg.height = height;
		}
	}
}
