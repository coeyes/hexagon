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
	import com.hexagonstar.event.FrameEvent;
	import com.hexagonstar.time.FrameRateInterval;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.TimerEvent;
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
		
		/**
		 * 1: play
		 * 2: playThenBackwards
		 * 3: playAndStopAt
		 * 4: playAtAndStopAt
		 * 5: playAtThenBackwardsAt
		 * 
		 * @private
		 */
		protected var _intervalMode:int;
		
		/** @private */
		protected var _totalFrames:int;
		/** @private */
		protected var _currentFrame:int;
		/** @private */
		protected var _isPlaying:Boolean;
		/** @private */
		protected var _isDisposed:Boolean = false;
		/** @private */
		protected var _point:Point;
		/** @private */
		protected var _rect:Rectangle;
		/** @private */
		protected var _frameWidth:int;
		/** @private */
		protected var _frameHeight:int;
		/** @private */
		protected var _resetWidth:int;
		/**@private */
		protected var _addFrame:int;
		/**@private */
		protected var _startFrame:int;
		/**@private */
		protected var _stopFrame:int;

		
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
										   interval:FrameRateInterval,
										   transparent:Boolean = true,
										   pixelSnapping:String = "auto",
										   smoothing:Boolean = false)
		{
			_frameHeight = bitmap.height;
			_frameWidth = frameWidth;
			
			super(new BitmapData(frameWidth, _frameHeight, transparent, 0x00000000),
				pixelSnapping, smoothing);
			
			_buffer = bitmap.clone();
			_totalFrames = _buffer.width / _frameWidth;
			_currentFrame = 1;
			_addFrame = 1;
			_startFrame = 0;
			_stopFrame = 0;
			_isPlaying = false;
			_intervalMode = 1;
			_interval = interval;
			_point = new Point(0, 0);
			_rect = new Rectangle(0, 0, _frameWidth, _frameHeight);
		}
		
		
		/**
		 * Starts the playback of the animated bitmap. If the animated bitmap is already
		 * playing while calling this method, it calls stop() and then play again instantly
		 * to allow for framerate changes during playback.
		 */
		public function play():void
		{
			_intervalMode = 1;
			if (!_isPlaying)
			{
				draw();
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
		 * Starts the playback of the animated display object. If the animated display
		 * object is already playing while calling this method, it calls stop() and then
		 * plays again instantly to allow for framerate changes during playback.
		 * Once max frame is reached, plays backwards until first frame, and again.
		 */
		public function playThenBackwards():void
		{
			_intervalMode = 2;
			if (!_isPlaying)
			{
				draw();
				_isPlaying = true;
				_interval.addEventListener(TimerEvent.TIMER, onInterval);//, false, 0, true); //add of weak reference if needed
				_interval.start();
			}
			else
			{
				stop();

				playThenBackwards();
			}
		}

		
		/**
		 * Starts the playback of the animated display object. If the animated display
		 * object is already playing while calling this method, it calls stop() and then
		 * plays again instantly to allow for framerate changes during playback.
		 * Once given param f (stored in _stopFrame) is reached, the playback is stopped.
		 * 
		 * @param frameNr the number to which to stop playback
		 */
		public function playAndStopAt(f:int):void
		{
			_intervalMode = 3;
			_stopFrame = f;
			if (!_isPlaying)
			{
				draw();
				_isPlaying = true;
				_interval.addEventListener(TimerEvent.TIMER, onInterval);//, false, 0, true); //add of weak reference if needed
				_interval.start();
			}
			else
			{
				stop();
				playAndStopAt(f);
			}
		}

		
		/**
		 * Starts the playback of the animated display object at the given param f (stored in_startFrame). If the animated display
		 * object is already playing while calling this method, it calls stop() and then
		 * plays again instantly to allow for framerate changes during playback.
		 * Once given param g (stored in _stopFrame) is reached, the playback is stopped.
		 * 
		 * @param f the frame number to which to start playback
		 * @param g the frame number to which stop playback
		 */
		public function playAtAndStopAt(f:int,g:int):void
		{
			_intervalMode = 4;
			_currentFrame = f;
			_stopFrame = g;
			if (!_isPlaying)
			{
				draw();
				_isPlaying = true;
				_interval.addEventListener(TimerEvent.TIMER, onInterval);//, false, 0, true); //add of weak reference if needed
				_interval.start();
			}
			else
			{
				stop();
				playAtAndStopAt(f, g);
			}
		}

		
		/**
		 * Starts the playback of the animated display object at the given param f (stored in_startFrame). If the animated display
		 * object is already playing while calling this method, it calls stop() and then
		 * plays again instantly to allow for framerate changes during playback.
		 * Once given param g (stored in _stopFrame) is reached, the playback is restarted from f.
		 * @param f the frame number to which to start playback
		 * @param g the frame number to which to restart playback
		 */
		public function playAtThenBackwardsAt(f:int,g:int):void
		{
			_intervalMode = 5;
			_startFrame = f;
			_currentFrame = f;
			_stopFrame = g;
			if (!_isPlaying)
			{
				draw();
				_isPlaying = true;
				_interval.addEventListener(TimerEvent.TIMER, onInterval);//, false, 0, true); //add of weak reference if needed
				_interval.start();
			}
			else
			{
				stop();
				playAtThenBackwardsAt(f, g);
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
		 * @param scene unused.
		 */
		public function gotoAndPlay(frame:Object, scene:String = null):void
		{
			_currentFrame = int(frame) - 1;
			play();
		}

		
		/**
		 * Jumps to the specified frame nr. and stops the animated bitmap at that position.
		 * Note that the frames of an animated bitmap start at 1 just like a MovieClip.
		 * 
		 * @param frame an Integer that designates the frame to which to jump.
		 * @param scene unused.
		 */
		public function gotoAndStop(frame:Object, scene:String = null):void
		{
			var f:int = int(frame);
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
				switch (_intervalMode)
				{
					case 1:
						play();
					case 2:
						playThenBackwards();
					case 3:
						playAndStopAt(_stopFrame);
					case 4:
						playAtAndStopAt(_startFrame, _stopFrame);
					case 5:
						playAtThenBackwardsAt(_startFrame, _stopFrame);
				}
			}
			else
			{
				_interval = v;
			}
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
		 * Returns the total amount of frames that the animated bitmap has.
		 * 
		 * @return The total frame amount.
		 */
		public function get totalFrames():int
		{
			return _totalFrames;
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
			/* play mode */
			if (_intervalMode == 1)
			{
				_currentFrame++;
				if (_currentFrame > _totalFrames)
				{
					_currentFrame = 1;
				}
				else if (_currentFrame < 1)
				{
					_currentFrame = _totalFrames;
				}
			}
			
			/* playThenBackwards mode */
			else if (_intervalMode == 2)
			{
				_currentFrame += _addFrame;
				if (_currentFrame == _totalFrames || _currentFrame < 2)
				{
					_addFrame = -_addFrame;
				}
			}
			
			/* playAndStopAt and playAtAndStopAt modes */
			else if (_intervalMode == 3 || _intervalMode == 4)
			{
				_currentFrame++;
				if (_currentFrame > _stopFrame - 1)
				{
					stop();
				}
			}
			
			/* playAtThenBackwardsAt mode */
			else if (_intervalMode == 5)
			{
				_currentFrame += _addFrame;
				if (_currentFrame == _stopFrame || _currentFrame < _startFrame + 1)
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
			
			/*
			* Previously 
			* _rect.offset(_currentFrame == 1 ? _resetWidth : _frameWidth, 0);
			* If we use this way with resetWidth we lock to forward play only.
			* if we need to absolutely use the offset method, but compatible only with playUntil, then we'd use 
			* _rect.offset(_frameWidth*_addFrame,0);
			* but then locked again for no play anymore. Offset method that speedy compared to redefining new rectangle ? 
			* method that will work with either ways is this:
			*_rect = new Rectangle((_currentFrame-1) * _frameWidth, 0, _frameWidth, _frameHeight);
			*/
		}
	}
}
