package com.midasplayer.games.candycrush.render
{
   import com.midasplayer.games.candycrush.Ticks;
   import flash.display.BitmapData;
   import flash.filters.BitmapFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   
   public class BitmapSprite
   {
      
      public static const ALIGN_LEFT:int = 0;
      
      public static const ALIGN_CENTER:int = 1;
      
      public static const ALIGN_RIGHT:int = 2;
      
      public static const VALIGN_TOP:int = 3;
      
      public static const VALIGN_MIDDLE:int = 4;
      
      public static const VALIGN_BOTTOM:int = 5;
      
      private static const _STATE_STOPPED:String = "Sprite._STATE_STOPPED";
      
      private static const _STATE_PLAYING:String = "Sprite._STATE_PLAYING";
      
      private static const _STATE_PLAYING_REVERSE:String = "Sprite._STATE_PLAYING_REVERSE";
      
      private static const _STATE_PLAY_REPEAT:String = "Sprite._STATE_PLAY_REPEAT";
      
      private static const _STATE_PLAY_REPEAT_REVERSE:String = "Sprite._STATE_PLAY_REPEAT_REVERSE";
       
      
      private var _state:String;
      
      private var _spriteSet:BitmapData;
      
      public var _frameBuffer:BitmapData;
      
      private var _frameBufferRect:Rectangle;
      
      private var _frameBufferOffset:Point;
      
      private var _needToUpdateFrameBuffer:Boolean;
      
      private var _frameBufferScale:Number;
      
      public var hideOnStop:Boolean = false;
      
      private var _doHide:Boolean = false;
      
      private var _filter:BitmapFilter;
      
      private var _numFrames:int;
      
      private var _frameSize:Point;
      
      private var _currentFrame:Number;
      
      public var _realFrame:Number;
      
      private var _lastFrame:Number;
      
      private var _fps:Number;
      
      private var _clipRect:Rectangle;
      
      private var _alpha:Number;
      
      public var smoothing:Boolean = false;
      
      private var _rotation:Number;
      
      private var _scaleX:Number;
      
      private var _scaleY:Number;
      
      private var _scaleSource:Boolean = false;
      
      private var _blendMode:String;
      
      public var name:String = "";
      
      public var removeAtEnd:Boolean = false;
      
      private var _transparent:Boolean;
      
      private var _lastTick:Number = -1;
      
      public function BitmapSprite(param1:BitmapData, param2:int = 1, param3:Number = 2, param4:Boolean = true)
      {
         super();
         this._spriteSet = param1;
         this._numFrames = param2;
         this._frameSize = new Point(param1.width / this._numFrames,param1.height);
         this._clipRect = new Rectangle(0,0,this._frameSize.x,this._frameSize.y);
         this._currentFrame = 0;
         this._realFrame = 0;
         this._lastFrame = 0;
         this._rotation = 0;
         this._alpha = 1;
         this._scaleX = this._scaleY = 1;
         this._blendMode = null;
         this._filter = null;
         this._frameBuffer = null;
         this._needToUpdateFrameBuffer = false;
         this._frameBufferScale = param3;
         this.setFPS(25);
         this.stop();
         this._transparent = param4;
      }
      
      private function _setState(param1:String) : void
      {
         this._state = param1;
      }
      
      public function setFPS(param1:Number) : void
      {
         this._fps = param1;
      }
      
      public function get alpha() : Number
      {
         return this._alpha;
      }
      
      public function set alpha(param1:Number) : void
      {
         this._alpha = param1;
      }
      
      public function get scaleX() : Number
      {
         return this._scaleX;
      }
      
      public function get scaleY() : Number
      {
         return this._scaleY;
      }
      
      public function set scaleX(param1:Number) : void
      {
         this._scaleX = param1;
      }
      
      public function set scaleY(param1:Number) : void
      {
         this._scaleY = param1;
      }
      
      public function set scaleSourceInsteadOfTarget(param1:Boolean) : void
      {
         this._scaleSource = param1;
      }
      
      public function width() : Number
      {
         return this._clipRect.width;
      }
      
      public function height() : Number
      {
         return this._clipRect.height;
      }
      
      public function currentFrame() : Number
      {
         return this._currentFrame;
      }
      
      public function setFrame(param1:int) : void
      {
         var _loc2_:* = Math.floor(this._currentFrame) != param1;
         this._currentFrame = param1;
         this._realFrame = param1;
         this._clipRect.x = Math.floor(this._currentFrame) * this._frameSize.x;
         if(_loc2_)
         {
            this._needToUpdateFrameBuffer = true;
         }
      }
      
      public function gotoLastFrame() : void
      {
         this.setFrame(this._numFrames - 1);
      }
      
      public function gotoFirstFrame() : void
      {
         this.setFrame(0);
      }
      
      public function play(param1:Boolean = false, param2:Boolean = false) : void
      {
         this._doHide = false;
         if(param1 && param2)
         {
            this._setState(_STATE_PLAY_REPEAT_REVERSE);
         }
         else if(param1)
         {
            this._setState(_STATE_PLAY_REPEAT);
         }
         else if(param2)
         {
            this._setState(_STATE_PLAYING_REVERSE);
         }
         else
         {
            this._setState(_STATE_PLAYING);
         }
      }
      
      public function isPlaying() : Boolean
      {
         return this._state == _STATE_PLAYING || this._state == _STATE_PLAY_REPEAT;
      }
      
      public function stop() : void
      {
         if(this.hideOnStop)
         {
            this._doHide = true;
         }
         this._setState(_STATE_STOPPED);
      }
      
      public function setRotation(param1:Number) : void
      {
         if(param1 != 0 && param1 != this._rotation)
         {
            this._needToUpdateFrameBuffer = true;
         }
         this._rotation = param1;
      }
      
      public function setBlendMode(param1:String) : void
      {
         this._blendMode = param1;
      }
      
      private function _setupFrameBuffer() : void
      {
         if(this._frameBuffer == null)
         {
            this._frameBuffer = new BitmapData(this._frameSize.x * this._frameBufferScale,this._frameSize.y * this._frameBufferScale,this._transparent,0);
            this._frameBufferRect = new Rectangle(0,0,this._frameBuffer.width,this._frameBuffer.height);
            this._frameBufferOffset = new Point(Math.floor((this._frameBuffer.width - this._frameSize.x) * 0.5),Math.floor((this._frameBuffer.height - this._frameSize.y) * 0.5));
            this._updateFrameBuffer();
         }
      }
      
      public function applyFilter(param1:BitmapFilter) : void
      {
         if(param1)
         {
            this._setupFrameBuffer();
            this._frameBuffer.fillRect(this._frameBufferRect,16777215);
            this._frameBuffer.copyPixels(this._spriteSet,this._clipRect,this._frameBufferOffset,null,null,this._transparent);
            if(param1)
            {
               this._frameBuffer.applyFilter(this._frameBuffer,this._frameBufferRect,new Point(0,0),param1);
            }
         }
         this._filter = param1;
         this._needToUpdateFrameBuffer = true;
      }
      
      public function applyFilters(param1:Array) : void
      {
         var _loc2_:BitmapFilter = null;
         if(param1)
         {
            this._setupFrameBuffer();
            this._frameBuffer.fillRect(this._frameBufferRect,16777215);
            this._frameBuffer.copyPixels(this._spriteSet,this._clipRect,this._frameBufferOffset,null,null,this._transparent);
            for each(_loc2_ in param1)
            {
               this._frameBuffer.applyFilter(this._frameBuffer,this._frameBufferRect,new Point(0,0),_loc2_);
            }
         }
         this._filter = !!param1 ? param1[0] : null;
         this._needToUpdateFrameBuffer = true;
      }
      
      private function _updateFrameBuffer() : void
      {
         if(this._frameBuffer != null)
         {
            if(this._filter)
            {
               this.applyFilter(this._filter);
            }
            else
            {
               this._frameBuffer.fillRect(this._frameBufferRect,16777215);
               this._frameBuffer.copyPixels(this._spriteSet,this._clipRect,this._frameBufferOffset,null,null,this._transparent);
            }
         }
      }
      
      public function tick(param1:Number) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         this._lastFrame = this._currentFrame;
         switch(this._state)
         {
            case _STATE_PLAYING:
               this._currentFrame = this._currentFrame + this._fps * Ticks.SecondsPerTick;
               this._realFrame = this._realFrame + this._fps * Ticks.SecondsPerTick;
               if(this._currentFrame > this._numFrames - 1)
               {
                  this._currentFrame = this._numFrames - 1;
                  this._realFrame = this._numFrames + 1;
                  this.stop();
               }
               break;
            case _STATE_PLAYING_REVERSE:
               this._currentFrame = this._currentFrame - this._fps * Ticks.SecondsPerTick;
               if(this._currentFrame < 0)
               {
                  this._currentFrame = 0;
                  this.stop();
               }
               break;
            case _STATE_PLAY_REPEAT:
               this._currentFrame = this._currentFrame + this._fps * Ticks.SecondsPerTick;
               if(this._currentFrame > this._numFrames - 1)
               {
                  _loc2_ = this._currentFrame;
                  _loc3_ = this._currentFrame - _loc2_;
                  this._currentFrame = _loc3_ + _loc2_ % this._numFrames;
               }
               break;
            case _STATE_PLAY_REPEAT_REVERSE:
               this._currentFrame = this._currentFrame - this._fps * Ticks.SecondsPerTick;
               if(this._currentFrame < 0)
               {
                  this._currentFrame = this._currentFrame + (this._numFrames - 1);
               }
         }
         this._clipRect.x = Math.floor(this._currentFrame) * this._frameSize.x;
         if(this._currentFrame != this._lastFrame)
         {
            this._needToUpdateFrameBuffer = true;
         }
         this._lastTick = param1;
      }
      
      public function update(param1:int) : void
      {
         if(this._lastTick < 0)
         {
            return;
         }
         while(this._lastTick < param1)
         {
            var _loc2_:*;
            var _loc3_:* = (_loc2_ = this)._lastTick + 1;
            _loc2_._lastTick = _loc3_;
            this.tick(this._lastTick);
         }
      }
      
      public function renderDecal(param1:Vector3D, param2:BitmapSprite, param3:int = 0, param4:int = 3) : void
      {
         this.renderDecal2(param1.x,param1.y,param2,param3,param4);
      }
      
      public function renderDecal2(param1:Number, param2:Number, param3:BitmapSprite, param4:int = 0, param5:int = 3) : void
      {
         this._setupFrameBuffer();
         param3.render2(0,param1 + this._frameBufferOffset.x,param2 + this._frameBufferOffset.y,this._frameBuffer,param4,param5);
      }
      
      public function clearDecals() : void
      {
         this._updateFrameBuffer();
      }
      
      public function render(param1:Number, param2:Vector3D, param3:BitmapData, param4:int = 0, param5:int = 3) : void
      {
         this.render2(param1,param2.x,param2.y,param3,param4,param5);
      }
      
      public function render2(param1:Number, param2:Number, param3:Number, param4:BitmapData, param5:int = 0, param6:int = 3) : void
      {
         var _loc9_:Matrix = null;
         var _loc10_:Rectangle = null;
         if(this._currentFrame < 0)
         {
            return;
         }
         if(this._realFrame >= this._numFrames - 1 && this.removeAtEnd)
         {
            return;
         }
         if(this._doHide)
         {
            return;
         }
         var _loc7_:Number = 0;
         var _loc8_:Number = 0;
         if(this._needToUpdateFrameBuffer && (this._filter != null || this._rotation != 0))
         {
            this._setupFrameBuffer();
            this._updateFrameBuffer();
         }
         this._needToUpdateFrameBuffer = false;
         if(this._frameBuffer != null)
         {
            switch(param5)
            {
               case ALIGN_LEFT:
                  _loc7_ = -this._frameBufferOffset.x;
                  break;
               case ALIGN_CENTER:
                  _loc7_ = -this._frameBufferRect.width * 0.5;
                  break;
               case ALIGN_RIGHT:
                  _loc7_ = -this._frameBufferRect.width + this._frameBufferOffset.x;
            }
            switch(param6)
            {
               case VALIGN_TOP:
                  _loc8_ = -this._frameBufferOffset.y;
                  break;
               case VALIGN_MIDDLE:
                  _loc8_ = -this._frameBufferRect.height * 0.5;
                  break;
               case VALIGN_BOTTOM:
                  _loc8_ = -this._frameBufferRect.height + this._frameBufferOffset.y;
            }
            if(this._alpha >= 1 && this._scaleX == 1 && this._scaleY == 1 && this._rotation == 0 && this._blendMode == null)
            {
               param4.copyPixels(this._frameBuffer,this._frameBufferRect,new Point(int(param2 + _loc7_),int(param3 + _loc8_)),null,null,this._transparent);
            }
            else if(this._alpha > 0)
            {
               _loc9_ = new Matrix(1,0,0,1,_loc7_,_loc8_);
               if(this._scaleSource)
               {
                  _loc9_.scale(this._scaleX,this._scaleY);
               }
               if(this._rotation != 0)
               {
                  _loc9_.rotate(this._rotation);
               }
               if(!this._scaleSource)
               {
                  _loc9_.scale(this._scaleX,this._scaleY);
               }
               _loc9_.translate(int(param2),int(param3));
               param4.draw(this._frameBuffer,_loc9_,new ColorTransform(1,1,1,this._alpha),this._blendMode,null,this.smoothing);
            }
         }
         else
         {
            _loc10_ = this._clipRect.clone();
            _loc10_.x = _loc10_.x * this._scaleX;
            _loc10_.y = _loc10_.y * this._scaleY;
            switch(param5)
            {
               case ALIGN_CENTER:
                  _loc7_ = -this._frameSize.x * 0.5 * this._scaleX;
                  break;
               case ALIGN_RIGHT:
                  _loc7_ = -this._frameSize.x * this._scaleX;
            }
            switch(param6)
            {
               case VALIGN_MIDDLE:
                  _loc8_ = -this._frameSize.y * 0.5 * this._scaleY;
                  break;
               case VALIGN_BOTTOM:
                  _loc8_ = -this._frameSize.y * this._scaleY;
            }
            if(this._alpha >= 1 && this._scaleX == 1 && this._scaleY == 1 && this._blendMode == null)
            {
               param4.copyPixels(this._spriteSet,this._clipRect,new Point(int(param2 + _loc7_),int(param3 + _loc8_)),null,null,this._transparent);
            }
            else if(this._alpha > 0)
            {
               _loc9_ = new Matrix(this._scaleX,0,0,this._scaleY,int(param2 - _loc10_.x + _loc7_),int(param3 - _loc10_.y + _loc8_));
               param4.draw(this._spriteSet,_loc9_,new ColorTransform(1,1,1,this._alpha),this._blendMode,new Rectangle(int(param2 + _loc7_),int(param3 + _loc8_),this._frameSize.x * this._scaleX,this._frameSize.y * this._scaleY),this.smoothing);
            }
         }
      }
      
      public function getTotalFrames() : int
      {
         return this._numFrames;
      }
      
      public function toString() : String
      {
         return "Name: " + this.name + ", " + this._state;
      }
   }
}
