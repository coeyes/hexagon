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
 * Copyright (c) 2007-2010 Sascha Balkau / Hexagon Star Softworks
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
package com.hexagonstar.display.bitmaps
{
	import com.hexagonstar.core.IDisposable;
	import com.hexagonstar.display.IAnimatedDisplayObject;
	import com.hexagonstar.display.PlayMode;
	import com.hexagonstar.event.FrameEvent;
	import com.hexagonstar.time.FrameRateInterval;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * Dispatched everytime a frame is entered.
	 * @eventType com.hexagonstar.event.FrameEvent
	 */
	[Event(name="enterFrame", type="com.hexagonstar.event.FrameEvent")]

	
	/**
	 * Represents an animateable bitmap. When creating the AnimatedBitmap a bitmapData
	 * object has to be specified that consists of horizonally layed out, same-sized
	 * single frames that the AnimatedBitmap uses as frames for it's animation.
	 * 
	 * @author Sascha Balkau
	 * @additional backwards play and custom loops Nilsen Filc
	 * @version 1.1.0
	 */
	public class AnimatedBitmap extends Bitmap implements IAnimatedDisplayObject,
		IDisposable
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/** @private */
		protected var _buffer:BitmapData;
		/** @private */
		protected var _interval:FrameRateInterval;
		/** @private */
		protected static var _globalInterval:FrameRateInterval;
		/** @private */
		protected static var _globalFrameRate:int = 12;
		/** @private */
		protected var _point:Point;
		/** @private */
		protected var _rect:Rectangle;
		/** @private */
		protected var _ranges:Object;
		/** @private */
		protected var _currentRange:Range;
		/** @private */
		protected var _startFrame:int;
		/** @private */
		protected var _endFrame:int;
		
		/** @private */
		protected var _frameWidth:int;
		/** @private */
		protected var _frameHeight:int;
		
		/**@private */
		protected var _playMode:int;
		
		/** @private */
		protected var _totalFrames:int;
		/** @private */
		protected var _currentFrame:int;
		/**@private */
		protected var _addFrame:int = 1;
		
		/** @private */
		protected var _isPlaying:Boolean = false;
		/** @private */
		protected var _isFlipX:Boolean = false;
		/** @private */
		protected var _isFlipY:Boolean = false;
		/** @private */
		protected var _isDisposed:Boolean = false;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new AnimatedBitmap instance.
		 * 
		 * @param bitmap The bitmapData object that contains the image sequence for the
		 *            animated bitmap.
		 * @param frameWidth The width of the AnimatedBitmap, this should be equal to the
		 *            width of a single animation frame on the specified bitmapData.
		 * @param interval The framerate interval used for the animated bitmap.
		 */
		public function AnimatedBitmap(bitmap:BitmapData,
										   frameWidth:int,
										   playMode:int = 0,
										   interval:FrameRateInterval = null,
										   transparent:Boolean = true,
										   pixelSnapping:String = "auto",
										   smoothing:Boolean = false)
		{
			_frameHeight = bitmap.height;
			_frameWidth = frameWidth;
			
			super(new BitmapData(frameWidth, _frameHeight, transparent, 0x00000000),
				pixelSnapping, smoothing);
			
			_buffer = bitmap.clone();
			_playMode = playMode;
			_totalFrames = _buffer.width / _frameWidth;
			_startFrame = _currentFrame = 1;
			_endFrame = _totalFrames;
			_point = new Point(0, 0);
			_ranges = {};
			
			if (interval)
			{
				_interval = interval;
			}
			else
			{
				if (!_globalInterval) _globalInterval = new FrameRateInterval(_globalFrameRate);
				_interval = _globalInterval;
			}
			
			draw();
		}
		
		
		/**
		 * Starts the playback of the animated bitmap. If the animated bitmap is already
		 * playing while calling this method, it calls stop() and then play again instantly
		 * to allow for framerate changes during playback.
		 */
		public function play():void
		{
			if (!_isPlaying)
			{
				_isPlaying = true;
				_interval.addEventListener(TimerEvent.TIMER, onInterval, false, 0, true);
				_interval.start();
			}
			else
			{
				stop();
				play();
			}
		}
		
		
		/**
		 * Stops the playback of the animated bitmap.
		 */
		public function stop():void
		{
			if (_isPlaying)
			{
				_interval.stop();
				_interval.removeEventListener(TimerEvent.TIMER, onInterval);
				_isPlaying = false;
			}
		}
		
		
		/**
		 * Jumps to the specified frame nr. and plays the animated bitmap from that
		 * position. Note that the frames of an animated bitmap start at 1 just like
		 * a MovieClip.
		 * 
		 * @param frame an Integer that designates the frame from which to start play.
		 * @param scene unused in animated bitmaps.
		 */
		public function gotoAndPlay(frameOrRange:Object, scene:String = null):void
		{
			_currentFrame = resolveFrame(frameOrRange) - 1;
			play();
		}

		
		/**
		 * Jumps to the specified frame nr. and stops the animated bitmap at that position.
		 * Note that the frames of an animated bitmap start at 1 just like a MovieClip.
		 * 
		 * @param frame an Integer that designates the frame to which to jump.
		 * @param scene unused in animated bitmaps.
		 */
		public function gotoAndStop(frameOrRange:Object, scene:String = null):void
		{
			var f:int = resolveFrame(frameOrRange);
			if (f >= _currentFrame)
			{
				_currentFrame = f - 1;
				nextFrame();
			}
			else
			{
				_currentFrame = f + 1;
				prevFrame();
			}
		}
		
		
		/**
		 * Moves the animation to the next of the current frame. If the animated bitmap is
		 * playing, the playback is stopped by this operation.
		 */
		public function nextFrame():void
		{
			if (_isPlaying) stop();
			_currentFrame++;
			if (_currentFrame > _totalFrames) _currentFrame = _totalFrames;
			draw();
		}

		
		/**
		 * Moves the animation to the previous of the current frame. If the animated bitmap
		 * is playing, the playback is stopped by this operation.
		 */
		public function prevFrame():void
		{
			if (_isPlaying) stop();
			_currentFrame--;
			if (_currentFrame < 1) _currentFrame = 1;
			draw();
		}

		
		/**
		 * Defines a new animation range to the animated bitmap.
		 * 
		 * @param name The name of the range.
		 * @param startFrame Starting frame number of the range.
		 * @param endFrame Ending frame number of the range.
		 */
		public function defineRange(name:String, startFrame:int, endFrame:int):void
		{
			_ranges[name] = new Range(name, startFrame, endFrame);
		}
		
		
		/**
		 * removeRange
		 */
		public function removeRange(name:String):void
		{
			delete(_ranges[name]);
		}
		
		
		/**
		 * Disposes the animated bitmap.
		 */
		public function dispose():void
		{
			stop();
			_isDisposed = true;
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Sets the frame rate timer object used for the animated bitmap. This method is
		 * useful when it is desired to change the framerate at a later timer.
		 * 
		 * @param timer The frame rate timer used for the animated bitmap.
		 */
		public function set frameRateInterval(v:FrameRateInterval):void
		{
			if (_isPlaying)
			{
				stop();
				_interval = v;
				play();
			}
			else
			{
				_interval = v;
			}
		}
		
		
		/**
		 * Indicates the framerate of the global framerate Interval that can be used
		 * as a default interval for all animated objects. The valid range is
		 * between 1 and 1000.
		 */
		static public function get globalFrameRate():int
		{
			return _globalFrameRate;
		}
		static public function set globalFrameRate(v:int):void
		{
			if (v < 1) v = 1;
			else if (v > 1000) v = 1000;
			_globalFrameRate = v;
			if (_globalInterval) _globalInterval.frameRate = _globalFrameRate;
		}

		
		/**
		 * Returns the frame rate with that the animated bitmap is playing.
		 * 
		 * @return The fps value of the animated bitmap.
		 */
		public function get frameRate():int
		{
			return _interval.frameRate;
		}
		public function set frameRate(v:int):void
		{
			_interval.frameRate = v;
		}
		
		
		/**
		 * Returns the current frame position of the animated bitmap.
		 * 
		 * @return The current frame position.
		 */
		public function get currentFrame():int
		{
			return _currentFrame;
		}
		
		
		/**
		 * Returns the name of the range that the current frame is in or null if the
		 * current frame is not in any defined range.
		 */
		public function get currentRange():String
		{
			for (var n:String in _ranges)
			{
				var r:Range = _ranges[n];
				if (_currentFrame >= r.start && _currentFrame <= r.end)
				{
					return n;
				}
			}
			return null;
		}
		
		
		/**
		 * Returns the total amount of frames that the animated bitmap has.
		 * 
		 * @return The total frame amount.
		 */
		public function get totalFrames():int
		{
			return _totalFrames;
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function get playMode():int
		{
			return _playMode;
		}
		public function set playMode(v:int):void
		{
			_playMode = v;
		}
		
		
		/**
		 * The name of the animation range that should be played.
		 * 
		 * @see addRange
		 * @see removeRange
		 */
		public function get range():String
		{
			if (_currentRange) return _currentRange.name;
			return null;
		}
		public function set range(v:String):void
		{
			if (_currentRange && v == _currentRange.name) return;
			_currentRange = _ranges[v];
			if (_currentRange)
			{
				_startFrame = _currentFrame = _currentRange.start;
				_endFrame = _currentRange.end;
				draw();
			}
		}
		
		
		/**
		 * Shortcut property to set horizontal and vertical scaling equally.
		 */
		public function get scale():Number
		{
			return scaleX;
		}
		public function set scale(v:Number):void
		{
			scaleX = scaleY = v;
		}
		
		
		public function get xPos():Number
		{
			if (_isFlipX) return x - width;
			return x;
		}
		public function set xPos(v:Number):void
		{
			x = xPos;
		}
		
		
		public function get flipX():Boolean
		{
			return _isFlipX;
		}
		public function set flipX(v:Boolean):void
		{
			if (v == _isFlipX) return;
			
			_isFlipX = v;
			var m:Matrix = transform.matrix;
			m.transformPoint(new Point(width / 2, height / 2));
			m.a = -1 * m.a;
			
			if (_isFlipX) m.tx = width + x;
			else m.tx = x - width;
			
			transform.matrix = m;
		}
		
		
		public function get flipY():Boolean
		{
			return _isFlipY;
		}
		public function set flipY(v:Boolean):void
		{
			if (v == _isFlipY) return;
			
			_isFlipY = v;
			var m:Matrix = transform.matrix;
			m.transformPoint(new Point(width / 2, height / 2));
			m.d = -1 * m.d;
			
			if (_isFlipY) m.ty = y + height;
			else m.ty = y - height;
			
			transform.matrix = m;
		}
		
		
		/**
		 * Returns whether the animated bitmap is playing or not.
		 * 
		 * @return true if the animated bitmap is playing, else false.
		 */
		public function get isPlaying():Boolean
		{
			return _isPlaying;
		}
		
		
		/**
		 * Determines if the object has been disposed (true), or is still available
		 * for use (false).
		 */
		public function get isDisposed():Boolean
		{
			return _isDisposed;
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Event Handlers                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Plays the animation according the the interval mode.
		 * @private
		 */
		protected function onInterval(e:TimerEvent):void
		{
			if (_playMode == PlayMode.FORWARD)
			{
				_currentFrame++;
				if (_currentFrame > _endFrame)
				{
					_currentFrame = _startFrame;
				}
			}
			else if (_playMode == PlayMode.BACKWARD)
			{
				_currentFrame--;
				if (_currentFrame < _startFrame)
				{
					_currentFrame = _endFrame;
				}
			}
			else if (_playMode == PlayMode.PINGPONG)
			{
				_currentFrame += _addFrame;
				if (_currentFrame == _endFrame || _currentFrame < _startFrame + 1)
				{
					_addFrame = -_addFrame;
				}
			}
			
			draw();
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Draws the next bitmap frame from the buffer to the visible area.
		 * @private
		 */
		protected function draw():void
		{
			dispatchEvent(new FrameEvent(FrameEvent.ENTER_FRAME, _currentFrame));
			_rect = new Rectangle((_currentFrame - 1) * _frameWidth, 0, _frameWidth, _frameHeight);
			bitmapData.copyPixels(_buffer, _rect, _point);
		}
		
		
		/**
		 * Resolves the frame number of the specified value. If v is a number it is
		 * returned direclly. If v is not a number it is seen as the name of a range
		 * and the start frame number of the range is tried to be returned.
		 * @private
		 */
		protected function resolveFrame(v:*):int
		{
			if (isNaN(v))
			{
				var r:Range = _ranges[String(v)];
				if (r) return r.start;
			}
			return v;
		}
	}
}

class Range
{
	public var name:String;
	public var start:int;
	public var end:int;
	
	public function Range(n:String, s:int, e:int)
	{
		name = n;
		start = s;
		end = e;
	}
}
