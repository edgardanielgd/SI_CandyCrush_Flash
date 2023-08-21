package com.midasplayer.games.candycrush.utils
{
   import flash.display.MovieClip;
   
   public class MCAnimation
   {
       
      
      public var mc:MovieClip = null;
      
      protected var _lastFrame:int = -1;
      
      protected var _numFrames:int;
      
      protected var _looping:Boolean;
      
      public function MCAnimation(param1:MovieClip, param2:Boolean = false)
      {
         super();
         this.mc = param1;
         this._looping = param2;
         this._numFrames = this.mc.totalFrames;
      }
      
      public function set frame(param1:int) : void
      {
         if(param1 != this._lastFrame)
         {
            if(this._looping)
            {
               param1 = 1 + (param1 - 1) % this._numFrames;
            }
            this.mc.gotoAndStop(param1);
            this._lastFrame = param1;
         }
      }
      
      public function get frame() : int
      {
         return this.mc.currentFrame;
      }
   }
}
